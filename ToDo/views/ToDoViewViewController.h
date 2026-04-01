//
//  ToDoViewViewController.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToDoViewViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;


@end

NS_ASSUME_NONNULL_END
