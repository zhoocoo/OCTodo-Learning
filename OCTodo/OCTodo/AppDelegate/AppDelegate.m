/**
 * AppDelegate.m — App 总管家
 *
 * 负责 App 级别的生命周期管理：创建窗口、设置根控制器
 */

#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1. 创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 2. 创建首页控制器，用导航控制器包装
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *navController =
        [[UINavigationController alloc] initWithRootViewController:homeVC];

    // 3. 设置根控制器并显示窗口
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
