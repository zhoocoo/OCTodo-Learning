/**
 * TodoItem+Display.m — 展示方法实现
 */

#import "TodoItem+Display.h"

@implementation TodoItem (Display)

- (NSString *)statusIcon {
    return self.isCompleted ? @"✅" : @"⬜️";
}

- (NSString *)displayText {
    return [NSString stringWithFormat:@"%@ %@ (%@)",
            [self statusIcon],
            self.title,
            [self createdAtString]];
}

@end
