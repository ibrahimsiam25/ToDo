//
//  ToDoViewViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "ToDoViewViewController.h"
#import "AddTaskViewController.h"
#import "../TaskStorage.h"
#import "../TaskListManager.h"

@interface ToDoViewViewController ()

@property (nonatomic, strong) TaskListManager *listManager;

@end

@implementation ToDoViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listManager = [[TaskListManager alloc] init];
    
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self loadTasks];
}

- (IBAction)filterSeg:(id)sender {
    UISegmentedControl *seg  = (UISegmentedControl *) sender;
    NSInteger index  = seg.selectedSegmentIndex;
    [self.listManager updateFilterNo:(int)index];
    [self loadTasks];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadTasks];
    NSLog(@"viewWillAppear");
}

- (void)loadTasks {
    NSArray<Task *> *tasks = [TaskStorage tasksTodo];
    [self.listManager loadTasks:tasks];
    [self.tabelView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listManager numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listManager numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    Task *task = [self.listManager taskAtIndexPath:indexPath];
    
    UILabel *titleLabel = [cell viewWithTag:1];
    UIView *priorityView = [cell viewWithTag:2];
    
    titleLabel.text = task.title;
    
    priorityView.backgroundColor = [TaskListManager getPriorityColor:task.priority];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    priorityView.layer.cornerRadius = priorityView.frame.size.width / 2;
    priorityView.clipsToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.listManager titleForHeaderInSection:section];
}

- (IBAction)addBtn:(id)sender {
    AddTaskViewController *addTaskView = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTaskViewController"];
    [self.navigationController pushViewController:addTaskView animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Task *deleteTask = [self.listManager taskAtIndexPath:indexPath];
        if (deleteTask) {
            [TaskStorage deleteTaskById:deleteTask.taskId];
            [self loadTasks];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    if (text == nil || [text isEqualToString:@""]) {
        [self.listManager updateSearchQuery:nil];
    } else {
        [self.listManager updateSearchQuery:[text copy]];
    }
    [self loadTasks];
}

@end
