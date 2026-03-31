/**
 * TodoItem+Display.h — TodoItem 的展示相关方法（Category）
 *
 * 【第五课实战】
 * 把展示逻辑从 TodoItem 主体中拆出来
 * 主体只负责数据，Display 分类负责"怎么展示"
 */

#import "TodoItem.h"

@interface TodoItem (Display)

/// 状态图标：✅ 或 ⬜️
- (NSString *)statusIcon;

/// 格式化的展示文本，如 "⬜️ 学习OC (03-30 16:30)"
- (NSString *)displayText;

@end
