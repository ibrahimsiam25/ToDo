//
//  AppDelegate.m
//  ToDo
//
//  Created by siam on 01/04/2026.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;

    [ThemeHelper applyGlobalTheme];
    return YES;
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    if (@available(iOS 14.0, *)) {
        completionHandler(UNNotificationPresentationOptionBanner |
                          UNNotificationPresentationOptionList |
                          UNNotificationPresentationOptionSound |
                          UNNotificationPresentationOptionBadge);
    } else {
        completionHandler(UNNotificationPresentationOptionAlert |
                          UNNotificationPresentationOptionSound |
                          UNNotificationPresentationOptionBadge);
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

@implementation ThemeHelper
+ (UIColor *)appBackgroundColor { return [UIColor colorWithRed:22.0/255.0 green:22.0/255.0 blue:24.0/255.0 alpha:1.0]; }
+ (UIColor *)cardBackgroundColor { return [UIColor colorWithRed:31.0/255.0 green:31.0/255.0 blue:34.0/255.0 alpha:1.0]; }
+ (UIColor *)accentPurpleColor { return [UIColor colorWithRed:127.0/255.0 green:90.0/255.0 blue:240.0/255.0 alpha:1.0]; }
+ (UIColor *)textPrimaryColor { return [UIColor whiteColor]; }
+ (UIColor *)textSecondaryColor { return [UIColor lightGrayColor]; }
+ (void)applyGlobalTheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[UITabBar appearance] setTintColor:[self accentPurpleColor]];
        [[UITabBar appearance] setBarTintColor:[self appBackgroundColor]];
        [[UITabBar appearance] setUnselectedItemTintColor:[self textSecondaryColor]];
        
        [[UINavigationBar appearance] setTintColor:[self accentPurpleColor]];
        [[UINavigationBar appearance] setBarTintColor:[self appBackgroundColor]];
        
        [[UISegmentedControl appearance] setSelectedSegmentTintColor:[self accentPurpleColor]];
    });
}
+ (void)styleCardCell:(UITableViewCell *)cell {
    cell.backgroundColor = [UIColor clearColor];
    if (cell.backgroundView == nil) {
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    }
    cell.backgroundView.backgroundColor = [UIColor clearColor];

    UIView *container = [cell.backgroundView viewWithTag:9001];
    if (container == nil) {
        container = [[UIView alloc] initWithFrame:CGRectInset(cell.bounds, 12, 4)];
        container.tag = 9001;
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.backgroundView addSubview:container];
    }

    container.frame = CGRectInset(cell.bounds, 12, 4);
    container.backgroundColor = [self cardBackgroundColor];
    container.layer.cornerRadius = 12;
    container.layer.masksToBounds = YES;

    if (cell.selectedBackgroundView == nil) {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    }
    cell.selectedBackgroundView.backgroundColor = [[self accentPurpleColor] colorWithAlphaComponent:0.12];

    cell.textLabel.textColor = [self textPrimaryColor];
    cell.detailTextLabel.textColor = [self textSecondaryColor];
}
+ (void)styleTableView:(UITableView *)tableView {
    tableView.backgroundColor = [self appBackgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
+ (void)styleTextField:(UITextField *)textField {
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [self cardBackgroundColor];
    textField.textColor = [self textPrimaryColor];
    textField.layer.cornerRadius = 14;
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [[self accentPurpleColor] colorWithAlphaComponent:0.25].CGColor;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}
+ (void)styleTextView:(UITextView *)textView {
    textView.backgroundColor = [self cardBackgroundColor];
    textView.textColor = [self textPrimaryColor];
    textView.layer.cornerRadius = 14;
    textView.layer.borderWidth = 1.0;
    textView.layer.borderColor = [[self accentPurpleColor] colorWithAlphaComponent:0.25].CGColor;
    textView.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
}
+ (void)stylePrimaryButton:(UIButton *)button {
    NSString *currentTitle = [button titleForState:UIControlStateNormal];
    UIImage *currentImage = [button imageForState:UIControlStateNormal];

    if (currentTitle.length == 0) {
        currentTitle = button.currentTitle;
    }

    if (currentImage == nil) {
        currentImage = button.currentImage;
    }

    if (@available(iOS 15.0, *)) {
        if (currentTitle.length == 0 && button.configuration.title.length > 0) {
            currentTitle = button.configuration.title;
        }
        if (currentImage == nil && button.configuration.image != nil) {
            currentImage = button.configuration.image;
        }
    }

    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration filledButtonConfiguration];
        config.baseBackgroundColor = [self accentPurpleColor];
        config.baseForegroundColor = [UIColor whiteColor];
        config.cornerStyle = UIButtonConfigurationCornerStyleCapsule;
        config.contentInsets = NSDirectionalEdgeInsetsMake(10, 16, 10, 16);
        config.title = currentTitle;
        config.image = currentImage;
        if (currentTitle.length > 0 && currentImage != nil) {
            config.imagePadding = 8;
        }
        button.configuration = config;
    }

    button.backgroundColor = [self accentPurpleColor];
    if (currentTitle.length > 0) {
        [button setTitle:currentTitle forState:UIControlStateNormal];
    }
    if (currentImage != nil) {
        [button setImage:currentImage forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    button.layer.cornerRadius = button.frame.size.height > 0 ? button.frame.size.height / 2.0 : 20.0;
    button.clipsToBounds = YES;
}
@end
