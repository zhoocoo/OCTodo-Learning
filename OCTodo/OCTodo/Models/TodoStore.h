/**
 * TodoStore.h — 待办数据管家（单例）
 *
 * 【第十一课实战】
 * MVC 的 Model 层：集中管理所有 TodoItem，提供增删改查接口
 * 通过 Notification 广播数据变化，让所有页面自动同步
 */

#import <Foundation/Foundation.h>
#import "TodoItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 数据变更通知（所有增删改操作后都会发送）
extern NSNotificationName const TodoStoreDidChangeNotification;

@interface TodoStore : NSObject

/// 单例入口
+ (instancetype)sharedStore;

/// 对外只读的待办列表（内部用 NSMutableArray，对外暴露为 NSArray 防止篡改）
@property (nonatomic, copy, readonly) NSArray<TodoItem *> *items;

#pragma mark - CRUD 接口

/// 添加一个待办
- (void)addItemWithTitle:(NSString *)title;

/// 删除指定索引的待办
- (void)removeItemAtIndex:(NSUInteger)index;

/// 切换指定索引待办的完成状态
- (void)toggleItemAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
