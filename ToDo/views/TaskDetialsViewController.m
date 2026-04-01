//
//  TaskDetialsViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "TaskDetialsViewController.h"
#import "../TaskStorage.h"

 
@interface TaskDetialsViewController ()

@property (nonatomic, assign) TaskStatus initialStatus;

@end

@implementation TaskDetialsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.initialStatus = self.task.status;
    [self fillUIFromTask];
}

- (void)fillUIFromTask {
    if (!self.task) {
        return;
    }

    self.titleTxtField.text = self.task.title ?: @"";
    self.desTxtView.text = self.task.taskDescription ?: @"";
    self.prioritySeg.selectedSegmentIndex = [self segmentIndexForPriority:self.task.priority];
    self.statusSeg.selectedSegmentIndex = [self segmentIndexForStatus:self.task.status];
}

- (NSInteger)segmentIndexForPriority:(TaskPriority)priority {
    switch (priority) {
        case TaskPriorityLow:
            return 0;
        case TaskPriorityMedium:
            return 1;
        case TaskPriorityHigh:
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)segmentIndexForStatus:(TaskStatus)status {
    switch (status) {
        case TaskStatusTodo:
            return 0;
        case TaskStatusInProgress:
            return 1;
        case TaskStatusDone:
            return 2;
        default:
            return 0;
    }
}

- (TaskPriority)priorityFromSegmentIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return TaskPriorityLow;
        case 1:
            return TaskPriorityMedium;
        case 2:
            return TaskPriorityHigh;
        default:
            return TaskPriorityLow;
    }
}

- (TaskStatus)statusFromSegmentIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return TaskStatusTodo;
        case 1:
            return TaskStatusInProgress;
        case 2:
            return TaskStatusDone;
        default:
            return TaskStatusTodo;
    }
}



- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
        message:message
        preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
    style:UIAlertActionStyleDefault  handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)priroritySeg:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    self.task.priority = [self priorityFromSegmentIndex:seg.selectedSegmentIndex];
}

- (IBAction)statusSeg:(id)sender {
    UISegmentedControl *seg = (UISegmentedControl *)sender;
       
       TaskStatus selectedStatus = [self statusFromSegmentIndex:seg.selectedSegmentIndex];
     
      
    if (self.initialStatus== TaskStatusTodo && selectedStatus == TaskStatusDone) {
           [self showAlertWithTitle:@"Invalid Status Change"
                           message:@"Task must go to In Progress first"];
           
           seg.selectedSegmentIndex = self.initialStatus;
           return;
       }
             if (self.initialStatus == TaskStatusInProgress && selectedStatus == TaskStatusTodo) {
           [self showAlertWithTitle:@"Invalid Status Change"
                           message:@"Cannot move back to To Do"];
           
           seg.selectedSegmentIndex = self.initialStatus;
           return;
       }
       
    if (self.initialStatus == TaskStatusDone) {
           [self showAlertWithTitle:@"Invalid Status Change"
                           message:@"Completed task cannot be modified"];
           
           seg.selectedSegmentIndex = self.initialStatus;
           return;
       }
         self.task.status = selectedStatus;
}

- (IBAction)saveBtn:(id)sender {
    NSString *titleText = self.titleTxtField.text ;
    NSString *descText = self.desTxtView.text;

    if (titleText.length == 0 || descText.length == 0) {
        [self showAlertWithTitle:@"Validation Error"
                         message:@"Please fill title and description."];
        return;
    }

    TaskStatus selectedStatus =  [self statusFromSegmentIndex:self.statusSeg.selectedSegmentIndex];
    
    TaskPriority selectedPriority = [self priorityFromSegmentIndex:self.prioritySeg.selectedSegmentIndex];
    
    self.task.title = titleText;
    self.task.taskDescription = descText;
    self.task.priority = selectedPriority;
    self.task.status = selectedStatus;

    [TaskStorage updateTask:self.task];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
