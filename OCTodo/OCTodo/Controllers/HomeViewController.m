/**
 * HomeViewController.m — 首页控制器实现
 *
 * 这是我们 OCTodo App 的主页面
 * 第三课更新：使用工厂方法创建 TodoItem，展示 Foundation 框架用法
 */

#import "HomeViewController.h"
#import "TodoItem.h"

@interface HomeViewController ()

/// 用 strong 持有数组，数组 strong 持有每个 TodoItem
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

/// 初始化示例数据
- (void)setupData {
    self.todoItems = [[NSMutableArray alloc] init];

    // 第三课：使用类工厂方法创建（更简洁）
    TodoItem *item1 = [TodoItem itemWithTitle:@"学习 OC 基础语法"];
    item1.isCompleted = YES;

    TodoItem *item2 = [TodoItem itemWithTitle:@"理解内存管理"];
    TodoItem *item3 = [TodoItem itemWithTitle:@"学习 Foundation 框架"];

    // NSMutableArray 的 addObject 方法
    [self.todoItems addObject:item1];
    [self.todoItems addObject:item2];
    [self.todoItems addObject:item3];

    // 快速枚举遍历 + description 打印
    for (TodoItem *item in self.todoItems) {
        NSLog(@"%@", item);
    }

    // 演示字符串拼接
    NSArray *titles = @[item1.title, item2.title, item3.title];
    NSString *joined = [titles componentsJoinedByString:@"、"];
    NSLog(@"所有待办: %@", joined);
}

/// 设置界面
- (void)setupUI {
    // 标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"共 %lu 个待办事项",
                       (unsigned long)self.todoItems.count];
    titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // 副标题：展示第一个未完成的待办
    UILabel *subtitleLabel = [[UILabel alloc] init];
    // 使用 NSArray 过滤找到第一个未完成项
    TodoItem *firstUndone = nil;
    for (TodoItem *item in self.todoItems) {
        if (!item.isCompleted) {
            firstUndone = item;
            break;
        }
    }
    subtitleLabel.text = firstUndone
        ? [NSString stringWithFormat:@"下一个: %@", firstUndone.title]
        : @"全部完成!";
    subtitleLabel.font = [UIFont systemFontOfSize:16];
    subtitleLabel.textColor = [UIColor grayColor];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;

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
