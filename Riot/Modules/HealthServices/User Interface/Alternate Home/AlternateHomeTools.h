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

#ifndef AlternateHomeTools_h
#define AlternateHomeTools_h


#endif /* AlternateHomeTools_h */
#import <MatrixKit/MatrixKit.h>

typedef NS_ENUM(NSUInteger, ComparrisonResult)//enum : NSUInteger
{
    ComparrisonResultGreaterThan,
    ComparrisonResultLessThan,
    ComparrisonResultEqualTo,
};

@interface AlternateHomeTools : NSObject
+ (NSString*)getNSLocalized:(NSString*)String In:(NSString*)table;
+ (ComparrisonResult)runComparer:(NSComparator)Comparator Against:(id)FirstObject AndThen:(id)SecondObject;
+ (void)setDelegateForCell:(id<MXKCellRendering>)cell With:(id<MXKCellRenderingDelegate>)delegate;
@end
