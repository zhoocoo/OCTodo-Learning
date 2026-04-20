/**
 * TodoItem.m — 待办事项模型
 */

#import "TodoItem.h"

@implementation TodoItem

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = [title copy];
        _isCompleted = NO;
        _createdAt = [NSDate date];
    }
    return self;
}

+ (instancetype)itemWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (NSString *)createdAtString {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd HH:mm";
    return [fmt stringFromDate:self.createdAt];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TodoItem: %@ [%@] 创建于 %@",
            self.title,
            self.isCompleted ? @"✅" : @"⬜️",
            [self createdAtString]];
}

@end
