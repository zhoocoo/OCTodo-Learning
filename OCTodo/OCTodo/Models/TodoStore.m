/**
 * TodoStore.m — 数据管家实现
 */

#import "TodoStore.h"

NSNotificationName const TodoStoreDidChangeNotification = @"TodoStoreDidChangeNotification";

@interface TodoStore ()

/// 内部可变数组（外部通过 items 只读访问）
@property (nonatomic, strong) NSMutableArray<TodoItem *> *mutableItems;

@end

@implementation TodoStore

#pragma mark - 单例

+ (instancetype)sharedStore {
    static TodoStore *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableItems = [NSMutableArray array];
        [self seedInitialData];
    }
    return self;
}

/// 初始化示例数据（后续接入持久化后移除）
- (void)seedInitialData {
    [_mutableItems addObject:[TodoItem itemWithTitle:@"学习 OC 基础语法"]];
    [_mutableItems addObject:[TodoItem itemWithTitle:@"理解内存管理"]];
    [_mutableItems addObject:[TodoItem itemWithTitle:@"学习 Foundation 框架"]];
    _mutableItems.firstObject.isCompleted = YES;
}

#pragma mark - 公开属性

/// 返回不可变副本，防止外部直接修改
- (NSArray<TodoItem *> *)items {
    return [self.mutableItems copy];
}

#pragma mark - CRUD

- (void)addItemWithTitle:(NSString *)title {
    [self.mutableItems addObject:[TodoItem itemWithTitle:title]];
    [self notifyChange];
}

- (void)removeItemAtIndex:(NSUInteger)index {
    if (index >= self.mutableItems.count) return;
    [self.mutableItems removeObjectAtIndex:index];
    [self notifyChange];
}

- (void)toggleItemAtIndex:(NSUInteger)index {
    if (index >= self.mutableItems.count) return;
    TodoItem *item = self.mutableItems[index];
    item.isCompleted = !item.isCompleted;
    [self notifyChange];
}

#pragma mark - 通知

- (void)notifyChange {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:TodoStoreDidChangeNotification
                      object:self];
}

@end
