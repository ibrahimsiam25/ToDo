//
//  TaskListManager.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "TaskListManager.h"
#import "TaskStorage.h"

@implementation TaskListManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _filterNo = 0;
        _sec = 3;
    }
    return self;
}

- (void)loadTasks:(NSArray<Task *> *)tasks {
    self.originalTasks = tasks;
    
    NSPredicate *lowPredicate = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityLow];
    NSPredicate *mediumPredicate = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityMedium];
    NSPredicate *highPredicate = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityHigh];
    
    NSArray<Task *> *lowArr = [tasks filteredArrayUsingPredicate:lowPredicate];
    NSArray<Task *> *mediumArr = [tasks filteredArrayUsingPredicate:mediumPredicate];
    NSArray<Task *> *highArr = [tasks filteredArrayUsingPredicate:highPredicate];
    
    if (self.searchQuery != nil && self.searchQuery.length > 0) {
        NSPredicate *searchPred = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", self.searchQuery];
        _lowPriorityArr = [lowArr filteredArrayUsingPredicate:searchPred];
        _mediumPriorityArr = [mediumArr filteredArrayUsingPredicate:searchPred];
        _highPriorityArr = [highArr filteredArrayUsingPredicate:searchPred];
    } else {
        _lowPriorityArr = lowArr;
        _mediumPriorityArr = mediumArr;
        _highPriorityArr = highArr;
    }
}

- (void)updateFilterNo:(int)filterNo {
    self.filterNo = filterNo;
    self.sec = filterNo ? 1 : 3;
}

- (void)updateSearchQuery:(NSString *)query {
    self.searchQuery = query;
}

- (NSInteger)numberOfSections {
    return self.sec;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    if (self.filterNo != 0) {
        switch (self.filterNo) {
            case 3:
                return self.lowPriorityArr.count;
            case 2:
                return self.mediumPriorityArr.count;
            case 1:
                return self.highPriorityArr.count;
            default:
                return 0;
        }
    } else {
        switch (section) {
            case 0:
                return self.lowPriorityArr.count;
            case 1:
                return self.mediumPriorityArr.count;
            case 2:
                return self.highPriorityArr.count;
            default:
                return 0;
        }
    }
}

- (Task *)taskAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = nil;
    if (self.filterNo != 0) {
        switch (self.filterNo) {
            case 3:
                task = self.lowPriorityArr[indexPath.row];
                break;
            case 2:
                task = self.mediumPriorityArr[indexPath.row];
                break;
            case 1:
                task = self.highPriorityArr[indexPath.row];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.section) {
            case 0:
                task = self.lowPriorityArr[indexPath.row];
                break;
            case 1:
                task = self.mediumPriorityArr[indexPath.row];
                break;
            case 2:
                task = self.highPriorityArr[indexPath.row];
                break;
            default:
                break;
        }
    }
    return task;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    if (self.filterNo != 0) {
        switch (self.filterNo) {
            case 3:
                return (self.lowPriorityArr.count > 0) ? @"Low" : nil;
            case 2:
                return (self.mediumPriorityArr.count > 0) ? @"Medium" : nil;
            case 1:
                return (self.highPriorityArr.count > 0) ? @"High" : nil;
            default:
                return nil;
        }
    } else {
        switch (section) {
            case 0:
                return (self.lowPriorityArr.count > 0) ? @"Low" : nil;
            case 1:
                return (self.mediumPriorityArr.count > 0) ? @"Medium" : nil;
            case 2:
                return (self.highPriorityArr.count > 0) ? @"High" : nil;
            default:
                return nil;
        }
    }
}

+ (UIColor *)getPriorityColor:(TaskPriority)taskPriority{
    UIColor *color =nil;
    switch (taskPriority) {
      case TaskPriorityHigh:
            color = [UIColor systemRedColor];
            break;
        case TaskPriorityMedium:
            color= [UIColor systemOrangeColor];
            break;
        case TaskPriorityLow:
            color = [UIColor systemGreenColor];
            break;
        default:
            color = [UIColor clearColor];
            break;
    }
    return  color;
}

@end
