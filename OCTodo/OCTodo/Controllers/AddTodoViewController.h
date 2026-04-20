/**
 * AddTodoViewController.h — 添加待办页面
 *
 * 【第十课实战】
 * 演示：Protocol 定义、delegate 属性（weak）、页面间反向传值
 */

#import <UIKit/UIKit.h>

@class AddTodoViewController;

/// 定义协议：添加待办的回调
/// 【回顾第四课】Protocol 就是"能力清单"，定义回调方法
@protocol AddTodoDelegate <NSObject>

@required
/// 用户点击保存后回调，把标题传给上一个页面
- (void)addTodoViewController:(AddTodoViewController *)controller
              didAddWithTitle:(NSString *)title;

@optional
/// 用户取消添加（可选实现）
- (void)addTodoViewControllerDidCancel:(AddTodoViewController *)controller;

@end

@interface AddTodoViewController : UIViewController

/// delegate 必须用 weak，避免循环引用
/// 【回顾第二课】HomeVC strong→ AddTodoVC，如果 delegate 也 strong→ HomeVC 就循环了
@property (nonatomic, weak) id<AddTodoDelegate> delegate;

@end
