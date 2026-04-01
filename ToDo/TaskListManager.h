//
//  TaskListManager.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskListManager : NSObject

@property (nonatomic, strong) NSArray<Task *> *originalTasks;
@property (nonatomic, strong, readonly) NSArray<Task *> *lowPriorityArr;
@property (nonatomic, strong, readonly) NSArray<Task *> *mediumPriorityArr;
@property (nonatomic, strong, readonly) NSArray<Task *> *highPriorityArr;

@property (nonatomic, copy) NSString * _Nullable  searchQuery;
@property (nonatomic, assign) int filterNo;
@property (nonatomic, assign) int sec;

- (void)loadTasks:(NSArray<Task *> *)tasks;
- (void)updateFilterNo:(int)filterNo;
- (void)updateSearchQuery:(NSString * _Nullable)query;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (Task * _Nullable)taskAtIndexPath:(NSIndexPath *)indexPath;
- (NSString * _Nullable)titleForHeaderInSection:(NSInteger)section;
+ (UIColor *)getPriorityColor:(TaskPriority)taskPriority;
@end

NS_ASSUME_NONNULL_END
