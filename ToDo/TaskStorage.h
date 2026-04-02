//
//  TaskStorage.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <Foundation/Foundation.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface TaskStorage : NSObject

+ (void)saveTask:(Task *)task;


+ (NSArray<Task *> *)allTasks;


+ (NSArray<Task *> *)tasksTodo;
+ (NSArray<Task *> *)tasksInProgress;
+ (NSArray<Task *> *)tasksDone;
+ (void)deleteTaskById:(NSString *)taskId ;
+ (void)updateTask:(Task *)task;

@end

NS_ASSUME_NONNULL_END

