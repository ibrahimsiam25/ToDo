//
//  TaskDetialsViewController.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <UIKit/UIKit.h>
#import "../Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface TaskDetialsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *desTxtView;
@property (weak, nonatomic) IBOutlet UITextField *titleTxtField;
@property (nonatomic, strong) Task *task;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySeg;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSeg;

@end

NS_ASSUME_NONNULL_END
