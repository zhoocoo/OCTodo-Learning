/**
 * NSString+Validation.h — 给 NSString 添加验证方法（Category）
 *
 * 【第五课实战】
 * 这是一个 Category 文件，给系统类 NSString 扩展了验证能力
 * 后续新增待办时用来校验用户输入
 */

#import <Foundation/Foundation.h>

@interface NSString (Validation)

/// 是否为空字符串或只包含空白字符
/// 用法：[@"  " oct_isBlank] → YES
- (BOOL)oct_isBlank;

/// 是否超过指定长度
- (BOOL)oct_exceedsMaxLength:(NSUInteger)maxLength;

@end
