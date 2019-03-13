//
//  SystemCodeZipper.h
//  onlyu
//
//  Created by ervinchen on 2019/1/22.
//  Copyright © 2019年 ccnyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

AppDelegate *GetAppDelegate(void);

CGFloat GetScreenWidth(void);

CGFloat GetScreenHeight(void);

UITableView *NewPlainTableView(id<UITableViewDataSource, UITableViewDelegate> delegate);

UITableView *NewGroupedTableView(id<UITableViewDataSource, UITableViewDelegate> delegate);

void ApplicationOpenUrl(NSString *url);

CGFloat GetSafeAreaTop(void);

CGFloat GetSafeAreaBottom(void);

void DispatchAfter(NSTimeInterval second, void (^block)(void));

BOOL IsIPhoneXSeries(void);

void PushViewController(UIViewController *currentController, UIViewController *pushedController);

NSInteger GetTimestamp(void);

#define _T(x) GetLocalizableStringC(x)
#define GetLocalizableStringC(x) GetLocalizableString(@(x))
NSString *GetLocalizableString(NSString *key);

void PostNotificaton(NSString *notification);

void AddNotificationObserver(id target, SEL sel, NSString *name);

CGFloat GetTextHeight(NSString *text, UIFont *font, CGFloat maxWidth);

CGFloat GetTextWidth(NSString *text, UIFont *font, CGFloat maxHeight);

void DispatchMainSync(void (^block)(void));

NSString *GetDocumentsPath(void);

void CreateDirectory(NSString *path);

CGFloat GetPixelPoint(CGFloat pixel);

NSString *GetNotNilString(NSString *src);

void PlaySound(NSString *name, NSString *type);
