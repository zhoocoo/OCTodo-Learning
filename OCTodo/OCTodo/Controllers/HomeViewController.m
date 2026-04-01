/**
 * HomeViewController.m — 首页控制器实现
 *
 * 第七课更新：加入 UIButton、UITextField 等真实 UI 元素
 * 演示 Target-Action 事件绑定、UIView 层级、控件创建
 */

#import "HomeViewController.h"
#import "TodoItem.h"
#import "TodoItem+Display.h"
#import "NSString+Validation.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSMutableArray<TodoItem *> *todoItems;
@property (nonatomic, strong) UITextField *inputField;    // 输入框
@property (nonatomic, strong) UILabel *countLabel;        // 计数标签
@property (nonatomic, strong) UILabel *listLabel;         // 列表展示（临时，后续用 TableView 替代）

@end

@implementation HomeViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"OCTodo";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupData];
    [self setupUI];
}

#pragma mark - 数据

- (void)setupData {
    self.todoItems = [[NSMutableArray alloc] init];

    [self.todoItems addObject:[TodoItem itemWithTitle:@"学习 OC 基础语法"]];
    [self.todoItems addObject:[TodoItem itemWithTitle:@"理解内存管理"]];
    [self.todoItems addObject:[TodoItem itemWithTitle:@"学习 Foundation 框架"]];

    // 标记第一个为已完成
    self.todoItems.firstObject.isCompleted = YES;
}

#pragma mark - UI 搭建

- (void)setupUI {
    // === 输入区域 ===
    // 输入框
    self.inputField = [[UITextField alloc] init];
    self.inputField.placeholder = @"输入新的待办事项...";
    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputField.font = [UIFont systemFontOfSize:16];
    self.inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inputField.returnKeyType = UIReturnKeyDone;
    self.inputField.translatesAutoresizingMaskIntoConstraints = NO;
    self.inputField.backgroundColor = [UIColor systemGray6Color];

    // 添加按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    addButton.backgroundColor = [UIColor systemBlueColor];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.layer.cornerRadius = 6;
    addButton.translatesAutoresizingMaskIntoConstraints = NO;

    // 绑定点击事件（Target-Action 模式）
    [addButton addTarget:self
                  action:@selector(addButtonTapped)
        forControlEvents:UIControlEventTouchUpInside];

    // === 信息区域 ===
    // 计数标签
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor grayColor];
    self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // 列表标签（临时方案，第12课会换成 UITableView）
    self.listLabel = [[UILabel alloc] init];
    self.listLabel.font = [UIFont systemFontOfSize:16];
    self.listLabel.textColor = [UIColor darkGrayColor];
    self.listLabel.numberOfLines = 0;  // 多行显示
    self.listLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // 添加到视图层级
    [self.view addSubview:self.inputField];
    [self.view addSubview:addButton];
    [self.view addSubview:self.countLabel];
    [self.view addSubview:self.listLabel];

    // AutoLayout 约束
    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        // 输入框：顶部安全区 + 16，左右边距 16
        [self.inputField.topAnchor constraintEqualToAnchor:safe.topAnchor constant:16],
        [self.inputField.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [self.inputField.heightAnchor constraintEqualToConstant:44],

        // 添加按钮：紧挨输入框右侧
        [addButton.topAnchor constraintEqualToAnchor:self.inputField.topAnchor],
        [addButton.leadingAnchor constraintEqualToAnchor:self.inputField.trailingAnchor constant:8],
        [addButton.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
        [addButton.widthAnchor constraintEqualToConstant:64],
        [addButton.heightAnchor constraintEqualToConstant:44],

        // 计数标签：输入框下方
        [self.countLabel.topAnchor constraintEqualToAnchor:self.inputField.bottomAnchor constant:16],
        [self.countLabel.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [self.countLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],

        // 列表标签：计数下方
        [self.listLabel.topAnchor constraintEqualToAnchor:self.countLabel.bottomAnchor constant:12],
        [self.listLabel.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [self.listLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
    ]];

    // 初始刷新
    [self refreshUI];
}

#pragma mark - 事件处理

/// 添加按钮点击事件
- (void)addButtonTapped {
    NSString *title = self.inputField.text;

    // 使用 NSString+Validation Category 验证输入
    if ([title oct_isBlank]) {
        NSLog(@"⚠️ 标题为空，不添加");
        return;
    }

    if ([title oct_exceedsMaxLength:50]) {
        NSLog(@"⚠️ 标题太长，最多50个字符");
        return;
    }

    // 创建新 TodoItem 并添加
    TodoItem *newItem = [TodoItem itemWithTitle:title];
    [self.todoItems addObject:newItem];

    // 清空输入框并收起键盘
    self.inputField.text = @"";
    [self.inputField resignFirstResponder];

    // 刷新界面
    [self refreshUI];

    NSLog(@"✅ 添加了: %@", [newItem displayText]);
}

/// 点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UI 刷新

- (void)refreshUI {
    // 更新计数
    NSUInteger total = self.todoItems.count;
    NSUInteger done = 0;
    for (TodoItem *item in self.todoItems) {
        if (item.isCompleted) done++;
    }
    self.countLabel.text = [NSString stringWithFormat:@"共 %lu 项，已完成 %lu 项",
                            (unsigned long)total, (unsigned long)done];

    // 更新列表文本
    NSMutableString *listText = [NSMutableString string];
    for (TodoItem *item in self.todoItems) {
        [listText appendFormat:@"%@\n", [item displayText]];
    }
    self.listLabel.text = listText;
}

- (void)dealloc {
    NSLog(@"♻️ HomeViewController 被释放了");
}

@end
