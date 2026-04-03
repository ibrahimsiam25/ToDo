//
//  AppDelegate.h
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>


@end


@interface ThemeHelper : NSObject
+ (UIColor *)appBackgroundColor;
+ (UIColor *)cardBackgroundColor;
+ (UIColor *)accentPurpleColor;
+ (UIColor *)textPrimaryColor;
+ (UIColor *)textSecondaryColor;
+ (void)applyGlobalTheme;
+ (void)styleCardCell:(UITableViewCell *)cell;
+ (void)styleTableView:(UITableView *)tableView;
+ (void)styleTextField:(UITextField *)textField;
+ (void)styleTextView:(UITextView *)textView;
+ (void)stylePrimaryButton:(UIButton *)button;
@end
