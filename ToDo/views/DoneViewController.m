//
//  DoneViewController.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "DoneViewController.h"
#import "../AppDelegate.h"
#import "AddTaskViewController.h"
#import "../TaskStorage.h"
#import "../TaskListManager.h"
#import "TaskDetialsViewController.h"

@interface DoneViewController ()
@property (nonatomic, strong) TaskListManager *listManager;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Fix layout overlapping with Navigation Bar and Tab Bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [ThemeHelper appBackgroundColor];
    [ThemeHelper styleTableView:self.tabelView];
   
    self.listManager = [[TaskListManager alloc] init];
    
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.searchBar.delegate = self;

    [ThemeHelper styleSearchBar:self.searchBar];
    [ThemeHelper styleSegmentedControlsInView:self.view];
    self.tabelView.rowHeight = 58.0;
    self.tabelView.sectionHeaderTopPadding = 0;
    
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loadTasks];
    NSLog(@"viewWillAppear");
}

- (void)loadTasks {
    NSArray<Task *> *tasks = [TaskStorage tasksDone];
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
    [ThemeHelper styleCardCell:cell];
    
    Task *task = [self.listManager taskAtIndexPath:indexPath];
    
    UILabel *titleLabel = [cell viewWithTag:1];
    UIView *priorityView = [cell viewWithTag:2];
    
    titleLabel.text = task.title;
    
 priorityView.backgroundColor = [TaskListManager getPriorityColor:task.priority];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     CGRect priorityFrame = priorityView.frame;
     CGFloat verticalInset = 6.0;
     priorityFrame.origin.y = verticalInset;
     priorityFrame.size.height = MAX(0.0, cell.contentView.bounds.size.height - (verticalInset * 2.0));
     priorityView.frame = priorityFrame;
     priorityView.layer.cornerRadius = 2.0;
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
