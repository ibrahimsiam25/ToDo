//
//  InProgressViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "InProgressViewController.h"
#import "AddTaskViewController.h"
#import "../TaskStorage.h"
#import "../TaskListManager.h"
#import "TaskDetialsViewController.h"
@interface InProgressViewController ()
@property (nonatomic, strong) TaskListManager *listManager;
@end

@implementation InProgressViewController

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
}

- (void)loadTasks {
    NSArray<Task *> *tasks = [TaskStorage tasksInProgress];
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
    Task *selected = [self.listManager taskAtIndexPath:indexPath];
    if (!selected) return;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    TaskDetialsViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"TaskDetialsViewController"];
    details.task = selected;
    [self.navigationController pushViewController:details animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.listManager titleForHeaderInSection:section];
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
