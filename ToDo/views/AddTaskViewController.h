//
//  AddTaskViewController.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <UIKit/UIKit.h>
#import "../Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddTaskViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *desTxtView;
@property (weak, nonatomic) IBOutlet UITextField *titleTxtField;
@property Task *task;
@end

NS_ASSUME_NONNULL_END
