/**
 * TodoItem.h — 待办事项数据模型
 *
 * 【内存管理实战】
 * 这个文件是第二课的实战代码，注意每个 @property 的内存关键字：
 * - copy: NSString、Block（防篡改）
 * - assign: BOOL、NSInteger（基本类型）
 * - strong: NSDate 等对象（持有它）
 */

#import <Foundation/Foundation.h>

@interface TodoItem : NSObject

/// 标题 — 用 copy 防止外部 NSMutableString 篡改
@property (nonatomic, copy) NSString *title;

/// 是否完成 — assign 因为 BOOL 是基本类型，不涉及引用计数
@property (nonatomic, assign) BOOL isCompleted;

/// 创建时间 — strong 持有这个日期对象
@property (nonatomic, strong) NSDate *createdAt;

/// 完成回调 — Block 用 copy（从栈拷贝到堆）
/// ⚠️ 使用时注意 weakSelf 避免循环引用
@property (nonatomic, copy) void (^onComplete)(void);

/// 自定义初始化方法
- (TodoItem *)initWithTitle:(NSString *)title;

/// 【第三课新增】返回创建时间的格式化字符串（如 "03-30 16:30"）
- (NSString *)createdAtString;

/// 【第三课新增】类工厂方法：快捷创建
+ (instancetype)itemWithTitle:(NSString *)title;

@end
