// 
// Copyright 2020 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

class AlternateHomeDataSource: RecentsDataSource {
    var _viewMode: HomeViewMode = HomeViewMode.Chats
    
    //this may be changed to include invites
    override func numberOfSections(in tableView: UITableView) -> Int {
        _ = super.numberOfSections(in: tableView) //we need to call this so that the proper number of sections is reported by the "underlying" tableview
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var returnString = ""
        switch _viewMode {
        case .Chats:
            returnString = "Chats "
        case .Favourites:
            returnString = "Favourites"
        case .Invites:
            returnString = "Invites"
        case .LowPriority:
            returnString = "Low Priority"
        }
        return returnString + " " + String(self.tableView(tableView, numberOfRowsInSection: 0))
    }
    
    func getBadgeValueForSectionMode(section: HomeViewMode) -> UInt {
        switch section {
        case .Favourites:
            return super.missedFavouriteCount
        case .Chats:
            return super.missedChatCount
        case .LowPriority:
            return super.missedLowPriorityCount
        case .Invites:
            return super.missedInviteCount
        }
    }
        
    //do work here sorting etc.
    func getIndexPathInUnderlying(indexPathFor uIndex: IndexPath) -> IndexPath {
        switch _viewMode {
        case HomeViewMode.Chats: //here we actually have to worry about interleaving the chats and rooms
            var interleaveRecord = [(Int, Int)]()
            var peopleIndex = 0
            var conversationIndex = 0
            if peopleCellDataArray.count > 0 && conversationCellDataArray.count > 0 {
                for _ in 0..<peopleCellDataArray.count + conversationCellDataArray.count {
                    if peopleIndex == peopleCellDataArray.count {
                        interleaveRecord.append((1, conversationIndex))
                        conversationIndex += 1
                        continue
                    }
                    if conversationIndex == conversationCellDataArray.count {
                        interleaveRecord.append((0, peopleIndex))
                        peopleIndex += 1
                        continue
                    }
                    let peopleCell: MXKRecentCellDataStoring? = peopleCellDataArray[peopleIndex] as? MXKRecentCellDataStoring
                    let conversationCell: MXKRecentCellDataStoring? = (conversationCellDataArray[conversationIndex]) as? MXKRecentCellDataStoring
                    let comparer = homeGetComparator()
                    if comparer != nil {
                        let res = AlternateHomeTools.runComparer(comparer, against: peopleCell, andThen: conversationCell)
                        if res == ComparrisonResult.equalTo {
                            if let pCell = peopleCell, let cCell = conversationCell {
                                if pCell.lastEvent.originServerTs >= cCell.lastEvent.originServerTs {
                                    interleaveRecord.append((0, peopleIndex))
                                    peopleIndex += 1
                                } else {
                                    interleaveRecord.append((1, conversationIndex))
                                    conversationIndex += 1
                                }
                            } else {
                                interleaveRecord.append((0, peopleIndex))
                                peopleIndex += 1
                            }
                        } else if res == ComparrisonResult.lessThan {
                            interleaveRecord.append((1, conversationIndex))
                            conversationIndex += 1
                        } else {
                            interleaveRecord.append((0, peopleIndex))
                            peopleIndex += 1
                        }
                    } else if peopleCell != nil && conversationCell != nil {
                        if (peopleCell?.lastEvent.originServerTs)! >= (conversationCell?.lastEvent.originServerTs)! {
                            interleaveRecord.append((0, peopleIndex))
                            peopleIndex += 1
                        } else {
                            interleaveRecord.append((1, conversationIndex))
                            conversationIndex += 1
                        }
                    }
                }
                let val = interleaveRecord[uIndex.row]
                if val.0 == 0 {
                    return IndexPath(row: val.1, section: peopleSection)
                } else {
                    return IndexPath(row: val.1, section: conversationSection)
                }
            }
            if uIndex.row < peopleCellDataArray.count {
                return IndexPath(row: uIndex.row, section: peopleSection)
            } else if uIndex.row < peopleCellDataArray.count + conversationCellDataArray.count {
                return IndexPath(row: uIndex.row - peopleCellDataArray.count, section: conversationSection)
            } else {
                return IndexPath(row: -1, section: -1)
            }
        case HomeViewMode.Favourites:
            return IndexPath(row: uIndex.row, section: favoritesSection)
        case HomeViewMode.LowPriority:
            return IndexPath(row: uIndex.row, section: lowPrioritySection)
        case HomeViewMode.Invites:
            return IndexPath(row: uIndex.row, section: invitesSection)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return super.tableView(tableView, canEditRowAt: getIndexPathInUnderlying(indexPathFor: indexPath))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch _viewMode {
        case HomeViewMode.Chats:
            let returnval = peopleCellDataArray.count + conversationCellDataArray.count
            return returnval
        case HomeViewMode.Favourites:
            if favoritesSection == -1 {
                return 0
            }
            return super.tableView(tableView, numberOfRowsInSection: favoritesSection)
        case HomeViewMode.LowPriority:
            if lowPrioritySection == -1 {
                return 0
            }
            return super.tableView(tableView, numberOfRowsInSection: lowPrioritySection)
        case HomeViewMode.Invites:
            return Int(super.missedInviteCount)
        }
    }
    
    override func cellHeight(at indexPath: IndexPath!) -> CGFloat {
        let underlyingIndexPath = getIndexPathInUnderlying(indexPathFor: indexPath)
        if underlyingIndexPath.section < 0 || underlyingIndexPath.row < 0 {
            return 0
        }
        return super.cellHeight(at: underlyingIndexPath)
    }
    
    func cellDataForIndexPath(_ tableView: UITableView, realIndexPath indexPath: IndexPath, intendedIndexPath destination: IndexPath) -> UITableViewCell {
        let cellData: MXKRecentCellDataStoring = self.cellData(at: indexPath)
        guard let reuseId = self.cellReuseIdentifier(for: cellData as? MXKCellData) else { return UITableViewCell() }
        guard let cell: MXKCellRendering = tableView.dequeueReusableCell(withIdentifier: reuseId, for: destination) as? MXKCellRendering else {return UITableViewCell()}
        
        //this is needed because "cell.delegate = self" is ambiguous to Swift's type system, even when surrounded in if lets / casts
        AlternateHomeTools.setDelegateForCell(cell, with: self)
        cell.render(cellData as? MXKCellData)
        return cell as? UITableViewCell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellDataForIndexPath(tableView, realIndexPath: getIndexPathInUnderlying(indexPathFor: indexPath), intendedIndexPath: indexPath)
    }
    
    
    func setViewMode(m: HomeViewMode) {
        _viewMode = m
        
    }
}
