//
//  AppDelegate.m
//  QuickLogin-Demo
//
//  Created by bindx on 2021/7/22.
//

#import "AppDelegate.h"
#import <QuickLogin/WKQuickLogin.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 初始化SDK
    [[WKQuickLogin getInstance] initWithKey:@"c08eabb172cd4f61be07b7d361cf9fc7" complete:^(NSDictionary * _Nonnull resultDic) {
        Class config1 = NSClassFromString(@"BitlibLoginMultConfig");
        SEL setAppinfo1 = NSSelectorFromString(@"appInfo");
        NSDictionary *dictt = [config1 performSelector:setAppinfo1];
        NSLog(@"%@",dictt);
        NSLog(@"%@",resultDic);
    }];
    return YES;
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
