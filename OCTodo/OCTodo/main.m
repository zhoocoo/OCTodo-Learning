/**
 * main.m — iOS 应用的入口文件
 *
 * 【Web 类比】就像 index.html 是网页的入口，main.m 是 iOS App 的入口
 *
 * 这个文件做了什么？
 * 1. 创建一个自动释放池（autorelease pool）— 管理内存的容器
 * 2. 调用 UIApplicationMain() 启动整个 App
 *    - 它会创建 UIApplication 单例
 *    - 加载 AppDelegate（你的 App 管家）
 *    - 启动主事件循环（Main Run Loop）— 类似 JS 的 Event Loop
 */

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        // UIApplicationMain 启动 App，这行之后 App 就"活"了
        // 第四个参数指定 AppDelegate 类名，它是 App 的"总管家"
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
