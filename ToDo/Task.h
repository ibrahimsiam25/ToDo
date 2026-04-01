//
//  Task.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, TaskPriority) {
    TaskPriorityLow,
    TaskPriorityMedium,
    TaskPriorityHigh
};

typedef NS_ENUM(NSInteger, TaskStatus) {
    TaskStatusTodo,
    TaskStatusInProgress,
    TaskStatusDone
};

@interface Task : NSObject

@property NSString *taskId;
@property NSString *title;
@property NSString *taskDescription;
@property TaskPriority priority;
@property TaskStatus status;
@property NSDate *date;
@property NSString *filePath;


- (NSDictionary *)toDictionary;
+ (Task *)fromDictionary:(NSDictionary *)dict;
@end


