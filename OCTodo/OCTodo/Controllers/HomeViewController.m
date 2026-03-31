/**
 * HomeViewController.m — 首页控制器实现
 *
 * 第五课更新：使用 Category 方法（TodoItem+Display、NSString+Validation）
 */

#import "HomeViewController.h"
#import "TodoItem.h"
#import "TodoItem+Display.h"          // 第五课：导入 Category
#import "NSString+Validation.h"       // 第五课：导入 Category

@interface HomeViewController ()       // Extension：声明私有属性

@property (nonatomic, strong) NSMutableArray<TodoItem *> *todoItems;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"OCTodo";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.todoItems = [[NSMutableArray alloc] init];

    TodoItem *item1 = [TodoItem itemWithTitle:@"学习 OC 基础语法"];
    item1.isCompleted = YES;

    TodoItem *item2 = [TodoItem itemWithTitle:@"理解内存管理"];
    TodoItem *item3 = [TodoItem itemWithTitle:@"学习 Foundation 框架"];

    [self.todoItems addObject:item1];
    [self.todoItems addObject:item2];
    [self.todoItems addObject:item3];

    // 第五课：使用 TodoItem+Display 的 Category 方法
    for (TodoItem *item in self.todoItems) {
        NSLog(@"%@", [item displayText]);
    }
}

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"共 %lu 个待办事项",
                       (unsigned long)self.todoItems.count];
    titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel *subtitleLabel = [[UILabel alloc] init];
    TodoItem *firstUndone = nil;
    for (TodoItem *item in self.todoItems) {
        if (!item.isCompleted) {
            firstUndone = item;
            break;
        }
    }
    // 第五课：使用 Category 的 displayText 方法
    subtitleLabel.text = firstUndone
        ? [NSString stringWithFormat:@"下一个: %@", [firstUndone displayText]]
        : @"全部完成!";
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor grayColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // 第五课：演示 NSString+Validation
    NSString *emptyTitle = @"   ";
    if ([emptyTitle oct_isBlank]) {
        NSLog(@"验证生效：空白标题被拦截");
    }

    [self.view addSubview:titleLabel];
    [self.view addSubview:subtitleLabel];

    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor
                                                  constant:-20],
        [subtitleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [subtitleLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor
                                                constant:12],
    ]];
}

- (void)dealloc {
    NSLog(@"♻️ HomeViewController 被释放了");
}

@end
