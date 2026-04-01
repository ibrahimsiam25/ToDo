//
//  AddTaskViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "AddTaskViewController.h"
#import "../Task.h"
#import "../TaskStorage.h"
@interface AddTaskViewController ()

@end

@implementation AddTaskViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.task =[Task new];
    self.task.status =   TaskStatusTodo;
    self.task.priority = TaskPriorityLow;
}


- (IBAction)addTask:(id)sender {
    NSString *titleText = self.titleTxtField.text;
    NSString *desText = self.desTxtView.text;
    
    if ( [titleText isEqualToString:@""] ||[desText isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"message:@"Please fill title and description"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.task.taskId =[[NSUUID UUID] UUIDString];
    self.task.title = titleText;
    self.task.taskDescription =  desText;;
    
    self.task.date= [NSDate date];
    
    [TaskStorage saveTask:self.task];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)prioritySeg:(id)sender {
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    NSInteger index = seg.selectedSegmentIndex;
    
    switch (index) {
        case 0:
            self.task.priority = TaskPriorityLow;
            break;
        case 1:
            self.task.priority = TaskPriorityMedium;
            break;
        case 2:
            self.task.priority = TaskPriorityHigh;
            break;
        default:
            break;
    }
    
}

@end
