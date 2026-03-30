/**
 * AppDelegate.h — App 代理的头文件（声明）
 *
 * 【Web 类比】
 * .h 文件 ≈ TypeScript 的 .d.ts 类型声明文件
 * 它只声明"这个类有什么"，不写具体实现
 *
 * 【OC 语法要点】
 * - #import: 类似 JS 的 import，但会自动防止重复导入
 * - @interface: 声明一个类，类似 TS 的 interface + class 声明
 * - <UIApplicationDelegate>: 遵守的协议，类似 TS 的 implements 接口
 * - @property: 声明属性，类似 JS class 的字段
 */

#import <UIKit/UIKit.h>

// @interface 类名 : 父类 <遵守的协议>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

// 属性声明：window 是 App 的主窗口，所有 UI 都在这个窗口上
// strong: 强引用，表示"我拥有这个对象，别人不能销毁它"
// nonatomic: 非原子性，不加线程锁，性能更好（大部分属性都用这个）
@property (strong, nonatomic) UIWindow *window;

@end
