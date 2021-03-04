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

#import <Foundation/Foundation.h>
#import "AlternateHomeTools.h"
//#import <MXKCellRendering.h>

@implementation AlternateHomeTools : NSObject

+ (NSString*)getNSLocalized:(NSString*)String In:(NSString*)table{
    return NSLocalizedStringFromTable(String, table, nil);
}
+ (ComparrisonResult)runComparer:(NSComparator)Comparator Against:(id)FirstObject AndThen:(id)SecondObject{
    NSComparisonResult result = Comparator(FirstObject,SecondObject);
    switch (result){
        case (NSOrderedAscending):
            return ComparrisonResultGreaterThan;
        case (NSOrderedDescending):
            return ComparrisonResultLessThan;
        case (NSOrderedSame):
            return ComparrisonResultEqualTo;
    }
}
//this is needed because doing this in swift leads swift to believe the expression is ambiguous.
+ (void)setDelegateForCell:(id<MXKCellRendering>)cell With:(id<MXKCellRenderingDelegate>)delegate {
    cell.delegate = delegate;
}
@end

