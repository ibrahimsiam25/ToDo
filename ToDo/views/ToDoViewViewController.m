//
//  ToDoViewViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "ToDoViewViewController.h"
#import "AddTaskViewController.h"
#import "../TaskStorage.h"
@interface ToDoViewViewController ()

@end

@implementation ToDoViewViewController
{
    NSArray<Task *> *todoArr ;
    NSArray<Task *> *lowPriorityArr;
    NSArray<Task *> *mediumPriorityArr;
    NSArray<Task *> *highPriorityArr;
    int filterNo ;
    int sec;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    filterNo =0;
    sec = 3;
    [self loadTasks];
}
- (IBAction)filterSeg:(id)sender {
    UISegmentedControl *seg  = (UISegmentedControl *) sender;
    NSInteger index  =seg.selectedSegmentIndex;
    filterNo = (int)index;
    sec = filterNo ?   1:3;
    [self.tabelView reloadData];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTasks];
    NSLog(@"viewWillAppear");
}



- (void)loadTasks {
    todoArr = [TaskStorage tasksTodo];

    NSPredicate *lowPredicate = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityLow];
    NSPredicate *mediumPredicate = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityMedium];
    NSPredicate *highPredicate = [NSPredicate predicateWithFormat:@"priority == %d", TaskPriorityHigh];

    lowPriorityArr = [todoArr filteredArrayUsingPredicate:lowPredicate];
    mediumPriorityArr = [todoArr filteredArrayUsingPredicate:mediumPredicate];
    highPriorityArr = [todoArr filteredArrayUsingPredicate:highPredicate];

    [self.tabelView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sec;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (filterNo != 0){
        switch (filterNo) {
            case 3:
                return lowPriorityArr.count;
            case 2:
                return mediumPriorityArr.count;
            case 1:
                return highPriorityArr.count;
            default:
                return 0;
        }}
        else{
        switch (section) {
            case 0:
                return lowPriorityArr.count;
            case 1:
                return mediumPriorityArr.count;
            case 2:
                return highPriorityArr.count;
            default:
                return 0;
        }}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    Task *task  = [Task new];
    if(filterNo != 0){
        switch (filterNo) {
            case 3:
                task= lowPriorityArr[indexPath.row];
                break;
            case 2:
                task= mediumPriorityArr[indexPath.row];
                break;
            case 1:
                task= highPriorityArr[indexPath.row];
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.section) {
            case 0:
                task= lowPriorityArr[indexPath.row];
                break;
            case 1:
                task= mediumPriorityArr[indexPath.row];
                break;
            case 2:
                task= highPriorityArr[indexPath.row];
                break;
            default:
                break;
        }
    }

        UILabel *titleLabel = [cell viewWithTag:1];
        UIView *priorityView = [cell viewWithTag:2];

  
        titleLabel.text = task.title;

    switch (task.priority) {
        case TaskPriorityHigh:
            priorityView.backgroundColor = [UIColor systemRedColor];
            break;
        case TaskPriorityMedium:
            priorityView.backgroundColor = [UIColor systemOrangeColor];
            break;
        case TaskPriorityLow:
            priorityView.backgroundColor = [UIColor systemGreenColor];
            break;
        default:
            priorityView.backgroundColor = [UIColor clearColor];
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        priorityView.layer.cornerRadius = priorityView.frame.size.width / 2;
        priorityView.clipsToBounds = YES;
   
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    User *userDetials = [User new];
//    switch (indexPath.section) {
//        case 0:
//            userDetials = self.data[indexPath.row];
//            break;
//        case 1:
//            userDetials =self.female[indexPath.row];
//            break;
//        default:
//            break;
//    }
//    
//
//    UserDetails *userDetailsView=
//        [self.storyboard instantiateViewControllerWithIdentifier:@"UserDetails"];
//        userDetailsView.user = userDetials;
//        [self.navigationController pushViewController:userDetailsView animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(filterNo != 0){
        switch (filterNo) {
            case 3:
                return @"Low";
            case 2:
                return @"Medium";
            case 1:
                return @"High";
            default:
                return @"";
        }
    }
    else{
        switch (section) {
            case 0:
                return @"Low";
            case 1:
                return @"Medium";
            case 2:
                return @"High";
            default:
                return @"";
        }}
}
- (IBAction)addBtn:(id)sender {
    AddTaskViewController *addTaskView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    [self.navigationController pushViewController:addTaskView animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Task *deleteTask = [Task new];
    switch (indexPath.section) {
        case 0:
     deleteTask= lowPriorityArr[indexPath.row];
            break;
        case 1:
            deleteTask= mediumPriorityArr[indexPath.row];
                   break;
        case 2:
            deleteTask= highPriorityArr[indexPath.row];
                   break;
            
        default:
            break;
      
         
    }
    
    [TaskStorage deleteTaskById:deleteTask.taskId];
    [self loadTasks];
}
@end
