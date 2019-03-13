//
//  SystemCodeZipper.m
//  onlyu
//
//  Created by ervinchen on 2019/1/22.
//  Copyright © 2019年 ccnyou. All rights reserved.
//

#import "SystemCodeZipper.h"
#import <AudioToolbox/AudioToolbox.h>

AppDelegate *GetAppDelegate(void) {
    UIApplication *app = [UIApplication sharedApplication];
    id delegate = app.delegate;
    return delegate;
}

CGFloat GetScreenWidth(void) {
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat GetScreenHeight(void) {
    return [UIScreen mainScreen].bounds.size.height;
}

UITableView *NewPlainTableView(id<UITableViewDataSource, UITableViewDelegate> delegate) {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.tableFooterView = [[UIView alloc] init]; // 隐藏多余的行
    return tableView;
}

UITableView *NewGroupedTableView(id<UITableViewDataSource, UITableViewDelegate> delegate) {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = delegate;
    tableView.dataSource = delegate;
    tableView.tableFooterView = [[UIView alloc] init]; // 隐藏多余的行
    return tableView;
}

void ApplicationOpenUrl(NSString *urlString) {
    NSURL *url = [NSURL URLWithString:urlString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

void DispatchAfter(NSTimeInterval second, void (^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

BOOL IsIPhoneXSeries(void) {
    BOOL result = NO;
    UIDevice *currentDevice = [UIDevice currentDevice];
    if (currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return result;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [GetAppDelegate() window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            result = YES;
        }
    }
    
    return result;
}

CGFloat GetSafeAreaTop(void) {
    CGFloat result = 20;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [GetAppDelegate() window];
        result = mainWindow.safeAreaInsets.top;
    }
    
    // iOS 11.x 适配
    result = MAX(result, 20);
    
    return result;
}

CGFloat GetSafeAreaBottom(void) {
    CGFloat result = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [GetAppDelegate() window];
        result = mainWindow.safeAreaInsets.bottom;
    }
    
    return result;
}

NSString *GetLocalizableString(NSString *key) {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *result = [mainBundle localizedStringForKey:key value:nil table:nil];
    if (result.length <= 0) {
        // 免去中文重复写的麻烦
        result = key;
    }
    return result;
}

void PushViewController(UIViewController *currentController, UIViewController *pushedController) {
    pushedController.hidesBottomBarWhenPushed = YES;
    [currentController.navigationController pushViewController:pushedController animated:YES];
}

NSInteger GetTimestamp(void) {
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSInteger result = (NSInteger)(timeInterval * 1000);
    return result;
}

void PostNotificaton(NSString *notification) {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification
                                                        object:nil];
}

void AddNotificationObserver(id target, SEL sel, NSString *name) {
    [[NSNotificationCenter defaultCenter] addObserver:target
                                             selector:sel
                                                 name:name
                                               object:nil];
}

CGFloat GetTextHeight(NSString *text, UIFont *font, CGFloat maxWidth) {
    CGSize size = CGSizeMake(maxWidth, CGFLOAT_MAX);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGFloat result = CGRectGetHeight(rect);
    return result;
}

CGFloat GetTextWidth(NSString *text, UIFont *font, CGFloat maxHeight) {
    CGSize size = CGSizeMake(CGFLOAT_MAX, maxHeight);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    CGFloat result = CGRectGetWidth(rect);
    return result;
}

void DispatchMainSync(void (^block)(void)) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

NSString *GetDocumentsPath(void) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}

void CreateDirectory(NSString *path) {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

CGFloat GetPixelPoint(CGFloat pixel) {
    CGFloat point = pixel / [UIScreen mainScreen].scale;
    return point;
}

NSString *GetNotNilString(NSString *src) {
    if (src) {
        return src;
    }
    return @"";
}

void PlaySound(NSString *name, NSString *type) {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:name ofType:type];
    SystemSoundID soundID;
    NSURL *url = [NSURL fileURLWithPath:soundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound (soundID);
}
