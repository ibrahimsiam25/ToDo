//
//  AddTaskViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "AddTaskViewController.h"
#import "../Task.h"
#import "../TaskStorage.h"

#import <UserNotifications/UserNotifications.h>
@implementation AddTaskViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupDefaultTask];
    [self setupDateButton];
    [self requestNotificationPermission];
    self.titleTxtField.layer.cornerRadius = 10;
    self.titleTxtField.layer.borderWidth = 1;
    self.titleTxtField.layer.borderColor= [UIColor lightGrayColor].CGColor;
    self.titleTxtField.clipsToBounds = YES;
    
    self.desTxtView.layer.cornerRadius = 10;
    self.desTxtView.layer.borderWidth = 1;
    self.desTxtView.layer.borderColor= [UIColor lightGrayColor].CGColor;
    self.desTxtView.clipsToBounds = YES;
}



- (void)setupDefaultTask {
    self.task = [Task new];
    self.task.status = TaskStatusTodo;
    self.task.priority = TaskPriorityLow;
    self.task.date = [NSDate date];
}

- (void)setupDateButton {
    if (!self.selectDateButton) {
        return;
    }

    [self.selectDateButton setTitle:[self formatDate:self.task.date] forState:UIControlStateNormal];
    [self.selectDateButton addTarget:self action:@selector(showDatePickerSheet:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)requestNotificationPermission {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
        completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
}

- (void)configureDatePickerIfNeeded {
    if (self.datePicker) {
        return;
    }

    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    if (@available(iOS 14.0, *)) {
        self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
}

- (NSDate *)selectedDateForTask {
    return self.datePicker ? self.datePicker.date : [NSDate date];
}

- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    return [df stringFromDate:date];
}

- (void)showDatePickerSheet:(id)sender {
    UIViewController *sheetVC = [[UIViewController alloc] init];
    sheetVC.view.backgroundColor = [UIColor systemBackgroundColor];

    [self configureDatePickerIfNeeded];
    
    self.datePicker.date = self.task.date ?: [NSDate date];
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [sheetVC.view addSubview:self.datePicker];

    if (@available(iOS 15.0, *)) {
        UISheetPresentationController *sheet = sheetVC.sheetPresentationController;
        sheet.detents = @[[UISheetPresentationControllerDetent mediumDetent]];
        sheet.prefersGrabberVisible = YES;
    }

    [self presentViewController:sheetVC animated:YES completion:nil];
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
    
    self.task.date = [self selectedDateForTask];

    [TaskStorage saveTask:self.task];


    if ([self.task.date timeIntervalSinceNow] > 0) {
        [self scheduleNotificationForTask:self.task];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dateChanged:(id)sender {
    if (self.datePicker) {
        self.task.date = self.datePicker.date;
        if (self.selectDateButton) {
            [self.selectDateButton setTitle:[self formatDate:self.task.date] forState:UIControlStateNormal];
        }
    }
}


- (void)scheduleNotificationForTask:(Task *)task {
    if (!task || !task.date) return;
    if ([task.date timeIntervalSinceNow] <= 0) return;

    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = task.title && task.title.length > 0 ? task.title : @"Task Reminder";
    content.body = task.taskDescription ?: @"";
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{ @"taskId": task.taskId ?: @"" };

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:task.date];

    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];

    NSString *identifier = task.taskId && task.taskId.length > 0 ? [NSString stringWithFormat:@"task-%@", task.taskId] : [[NSUUID UUID] UUIDString];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {}];
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
