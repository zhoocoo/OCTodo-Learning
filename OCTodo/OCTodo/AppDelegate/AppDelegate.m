/**
 * AppDelegate.m — App 代理的实现文件
 *
 * 【Web 类比】
 * .m 文件 ≈ .js/.ts 的实现文件
 * OC 把"声明"和"实现"分开：.h 说"我有什么"，.m 说"我怎么做"
 *
 * 【AppDelegate 的角色】
 * AppDelegate 就像 App 的"总管家"，负责处理 App 级别的事件：
 * - App 启动完成 → didFinishLaunchingWithOptions
 * - App 进入后台 → applicationDidEnterBackground
 * - App 回到前台 → applicationWillEnterForeground
 *
 * 【Web 类比】类似于：
 * - window.onload（启动完成）
 * - document.visibilitychange（前后台切换）
 */

#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

/// App 启动完成后调用（最重要的生命周期方法）
/// 类似 Web 的 DOMContentLoaded / window.onload
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 1. 创建主窗口（相当于浏览器的 window 对象）
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    // 2. 创建首页控制器
    HomeViewController *homeVC = [[HomeViewController alloc] init];

    // 3. 用导航控制器包装（提供顶部导航栏 + 页面跳转能力）
    //    类似 Web 里给页面加上 <nav> 和路由功能
    UINavigationController *navController =
        [[UINavigationController alloc] initWithRootViewController:homeVC];

    // 4. 设置根控制器并显示窗口
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    return YES;
}

/// App 即将进入非活跃状态（比如来电话了、下拉通知栏）
- (void)applicationWillResignActive:(UIApplication *)application {
    // 类似 Web 的 document.hidden = true
    NSLog(@"App 即将失去焦点");
}

/// App 已进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 可以在这里保存数据，释放共享资源
    NSLog(@"App 进入后台");
}

/// App 即将回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"App 即将回到前台");
}

/// App 已经变为活跃状态
- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"App 已激活");
}

@end
