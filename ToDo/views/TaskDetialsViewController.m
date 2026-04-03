//
//  TaskDetialsViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "TaskDetialsViewController.h"
#import "../AppDelegate.h"
#import "../TaskStorage.h"

 
@interface TaskDetialsViewController ()

@property (nonatomic, assign) TaskStatus initialStatus;

@end

@implementation TaskDetialsViewController

{
    bool btnStatus ;
}

- (void)updateInputAppearanceForEditing:(BOOL)isEditing {
    UIColor *borderColor = isEditing
        ? [[ThemeHelper accentPurpleColor] colorWithAlphaComponent:0.85]
        : [[ThemeHelper accentPurpleColor] colorWithAlphaComponent:0.25];

    UIColor *backgroundColor = isEditing
        ? [[ThemeHelper accentPurpleColor] colorWithAlphaComponent:0.20]
        : [ThemeHelper cardBackgroundColor];

    self.titleTxtField.backgroundColor = backgroundColor;
    self.desTxtView.backgroundColor = backgroundColor;
    self.titleTxtField.textColor = [ThemeHelper textPrimaryColor];
    self.desTxtView.textColor = [ThemeHelper textPrimaryColor];

    self.titleTxtField.layer.cornerRadius = 14;
    self.desTxtView.layer.cornerRadius = 14;
    self.titleTxtField.layer.borderWidth = 1.2;
    self.desTxtView.layer.borderWidth = 1.2;
    self.titleTxtField.layer.borderColor = borderColor.CGColor;
    self.desTxtView.layer.borderColor = borderColor.CGColor;
}

- (void)styleSubviews:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subview;
            NSString *title = [btn titleForState:UIControlStateNormal];
            NSArray<NSString *> *actions = [btn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
            if ([title isEqualToString:@"Edit"] || [title isEqualToString:@"Cancel"]) {
                btn.hidden = YES;
                btn.alpha = 0;
            } else if ([title isEqualToString:@"Save"] || [title isEqualToString:@"Add"] || [actions containsObject:@"saveBtn:"]) {
                [ThemeHelper stylePrimaryButton:btn];
            }
        }
        [self styleSubviews:subview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ThemeHelper appBackgroundColor];
    
    self.titleTxtField.enabled = NO;
    self.desTxtView.editable = NO;
    btnStatus = NO;
    
    [ThemeHelper styleTextField:self.titleTxtField];
    [ThemeHelper styleTextView:self.desTxtView];
    [self updateInputAppearanceForEditing:NO];
    
    self.initialStatus = self.task.status;
    
    // Add Edit Button to Nav Bar and Hide Storyboard one if found
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(navEditBtn:)];
    self.navigationItem.rightBarButtonItem = editItem;

    
    // Optional: Hide the old edit button from view by iterating subviews (since we don't have its specific outlet in header)
    [self styleSubviews:self.view];
[self fillUIFromTask];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self styleSubviews:self.view];
    [self updateInputAppearanceForEditing:btnStatus];
}


- (void)navEditBtn:(UIBarButtonItem *)sender {
    if (btnStatus) { // Canceling edit mode
        self.titleTxtField.enabled = NO;
        self.desTxtView.editable = NO;
        [self updateInputAppearanceForEditing:NO];
        sender.title = @"Edit";
        sender.tintColor = [ThemeHelper accentPurpleColor];
        btnStatus = NO;
    } else { // Entering edit mode
        self.titleTxtField.enabled = YES;
        self.desTxtView.editable = YES;
        [self updateInputAppearanceForEditing:YES];
        sender.title = @"Cancel";
        sender.tintColor = [UIColor systemRedColor];
        btnStatus = YES;
    }
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
