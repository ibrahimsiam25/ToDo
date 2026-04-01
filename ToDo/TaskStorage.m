//
//  TaskStorage.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "TaskStorage.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TaskStorage

static NSString * const kTasksKey = @"tasksArray";

+ (void)saveTask:(Task *)task {
    NSMutableArray *savedDicts = [[[NSUserDefaults standardUserDefaults] objectForKey:kTasksKey] mutableCopy];
     if (!savedDicts) {
         savedDicts = [NSMutableArray array];
     }

     NSDictionary *taskDict = [task toDictionary];
     [savedDicts addObject:taskDict];

     [[NSUserDefaults standardUserDefaults] setObject:savedDicts forKey:kTasksKey];
     [[NSUserDefaults standardUserDefaults] synchronize];


     NSLog(@"Saved Task: %@", taskDict);
}


+ (NSArray<Task *> *)allTasks {
    NSArray *savedDicts = [[NSUserDefaults standardUserDefaults] objectForKey:kTasksKey];
    NSMutableArray<Task *> *tasks = [NSMutableArray array];
    for (NSDictionary *dict in savedDicts) {
        [tasks addObject:[Task fromDictionary:dict]];
    }
    return tasks;
}


+ (NSArray<Task *> *)tasksTodo {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %d", TaskStatusTodo];
    return [[self allTasks] filteredArrayUsingPredicate:pred];
}

+ (NSArray<Task *> *)tasksInProgress {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %d", TaskStatusInProgress];
    return [[self allTasks] filteredArrayUsingPredicate:pred];
}

+ (NSArray<Task *> *)tasksDone {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"status == %d", TaskStatusDone];
    return [[self allTasks] filteredArrayUsingPredicate:pred];
}


+ (void)deleteTaskById:(NSString *)taskId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tasks = [[defaults objectForKey:kTasksKey] mutableCopy];

    if (!tasks) return;

    for (NSDictionary *dict in tasks) {
        if ([dict[@"taskId"] isEqual:taskId]) {
            [tasks removeObject:dict];
            break;
        }
    }

    [defaults setObject:tasks forKey:kTasksKey];
    

}


+ (void)updateTask:(Task *)task {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tasks = [[defaults objectForKey:kTasksKey] mutableCopy];
    if (!tasks) {
        tasks = [NSMutableArray array];
    }

    BOOL updated = NO;
    for (NSUInteger i = 0; i < tasks.count; i++) {
        NSDictionary *dict = tasks[i];
        if ([dict[@"taskId"] isEqual:task.taskId]) {
            tasks[i] = [task toDictionary];
            updated = YES;
            break;
        }
    }

    if (!updated) {
        [tasks addObject:[task toDictionary]];
    }

    [defaults setObject:tasks forKey:kTasksKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end

NS_ASSUME_NONNULL_END
