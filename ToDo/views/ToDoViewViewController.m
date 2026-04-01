//
//  ToDoViewViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "ToDoViewViewController.h"
#import "AddTaskViewController.h"
@interface ToDoViewViewController ()

@end

@implementation ToDoViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)addBtn:(id)sender {
    AddTaskViewController *addTaskView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    [self.navigationController pushViewController:addTaskView animated:YES];
}

@end
