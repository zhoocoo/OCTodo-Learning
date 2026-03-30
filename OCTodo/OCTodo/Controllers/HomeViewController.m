/**
 * HomeViewController.m — 首页控制器实现
 *
 * 这是我们 OCTodo App 的主页面
 * 第二课新增：使用 TodoItem 模型，演示内存管理
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

    // 初始化数据
    [self setupData];

    // 设置 UI
    [self setupWelcomeLabel];
}

/// 初始化示例数据 — 演示 TodoItem 的创建和内存管理
- (void)setupData {
    self.todoItems = [[NSMutableArray alloc] init];

    // 创建几个示例 TodoItem
    TodoItem *item1 = [[TodoItem alloc] initWithTitle:@"学习 OC 基础语法"];
    item1.isCompleted = YES;

    TodoItem *item2 = [[TodoItem alloc] initWithTitle:@"理解内存管理"];

    TodoItem *item3 = [[TodoItem alloc] initWithTitle:@"学习 Foundation 框架"];

    [self.todoItems addObject:item1];
    [self.todoItems addObject:item2];
    [self.todoItems addObject:item3];

    // 演示 NSLog 打印（会调用 TodoItem 的 description 方法）
    for (TodoItem *item in self.todoItems) {
        NSLog(@"%@", item);
    }

    // 演示 Block + weakSelf 避免循环引用
    __weak typeof(self) weakSelf = self;
    item2.onComplete = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        NSLog(@"✅ 完成了: %@", strongSelf.todoItems[1].title);
    };
}

/// 设置欢迎标签
- (void)setupWelcomeLabel {
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = [NSString stringWithFormat:@"共 %lu 个待办事项",
                         (unsigned long)self.todoItems.count];
    welcomeLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:welcomeLabel];

    [NSLayoutConstraint activateConstraints:@[
        [welcomeLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [welcomeLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

- (void)dealloc {
    NSLog(@"♻️ HomeViewController 被释放了");
}

@end
