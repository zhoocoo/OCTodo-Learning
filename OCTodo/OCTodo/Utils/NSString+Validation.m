/**
 * NSString+Validation.m — 验证方法实现
 *
 * 【注意】
 * 方法加了 oct_ 前缀，避免和系统或第三方库的方法名冲突
 * 这是给系统类写 Category 的最佳实践
 */

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)oct_isBlank {
    // self 就是调用此方法的 NSString 实例
    NSString *trimmed = [self stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed.length == 0;
}

- (BOOL)oct_exceedsMaxLength:(NSUInteger)maxLength {
    return self.length > maxLength;
}

@end
