/**
 * TodoItem.m — 待办事项模型实现
 *
 * 【新语法说明】
 * - _title: 属性 title 自动生成的实例变量（带下划线前缀）
 * - self = [super init]: OC 的标准初始化模式
 * - dealloc: 对象被销毁时调用，用来验证内存管理是否正确
 */

#import "TodoItem.h"

@implementation TodoItem

- (instancetype)initWithTitle:(NSString *)title {
    // OC 标准初始化模式（三步走）：
    // 1. 调用父类 init
    // 2. 检查是否成功
    // 3. 设置自己的属性
    self = [super init];
    if (self) {
        _title = [title copy];      // 用 _title 直接访问实例变量（跳过 setter）
        _isCompleted = NO;
        _createdAt = [NSDate date]; // [NSDate date] 获取当前时间
    }
    return self;
}

/// 对象销毁时调用 — 用来调试内存管理
/// 如果这个方法没被调用，说明对象没被释放（可能有循环引用）
- (void)dealloc {
    NSLog(@"♻️ TodoItem [%@] 被释放了", _title);
}

/// 重写 description 方法，方便 NSLog 打印
/// 类似 JS 的 toString()
- (NSString *)description {
    return [NSString stringWithFormat:@"TodoItem: %@ [%@]",
            self.title,
            self.isCompleted ? @"✅" : @"⬜️"];
}

@end
