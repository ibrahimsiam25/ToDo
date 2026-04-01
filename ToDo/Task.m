//
//  Task.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@implementation Task

- (NSDictionary *)toDictionary {
    return @{
        @"taskId": self.taskId,
        @"title": self.title ?: @"",
        @"taskDescription": self.taskDescription ?: @"",
        @"priority": @(self.priority),
        @"status": @(self.status),
        @"date": self.date ?: [NSDate date],
        @"filePath": self.filePath ?: @""
    };
}

+ (Task *)fromDictionary:(NSDictionary *)dict {
    Task *task = [[Task alloc] init];
    task.taskId = dict[@"taskId"] ;
    task.title = dict[@"title"];
    task.taskDescription = dict[@"taskDescription"];
    task.priority = [dict[@"priority"] integerValue];
    task.status = [dict[@"status"] integerValue];
    task.date = dict[@"date"];
    task.filePath = dict[@"filePath"];
    return task;
}
@end

NS_ASSUME_NONNULL_END
