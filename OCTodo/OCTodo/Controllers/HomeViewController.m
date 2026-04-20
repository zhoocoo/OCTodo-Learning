/**
 * HomeViewController.m — 首页控制器
 *
 * 第十课：导航栏"+"按钮跳转到 AddTodoVC，通过 delegate 接收新待办
 */

#import "HomeViewController.h"
#import "TodoItem.h"
#import "TodoItem+Display.h"
#import "AddTodoViewController.h"

@interface HomeViewController () <AddTodoDelegate>

@property (nonatomic, strong) NSMutableArray<TodoItem *> *todoItems;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *listLabel;

@end

@implementation HomeViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"OCTodo";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupNavigationBar];
    [self setupData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}

#pragma mark - 导航栏

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                     target:self
                                                     action:@selector(addButtonTapped)];
}

#pragma mark - 数据

- (void)setupData {
    self.todoItems = [[NSMutableArray alloc] init];

    [self.todoItems addObject:[TodoItem itemWithTitle:@"学习 OC 基础语法"]];
    [self.todoItems addObject:[TodoItem itemWithTitle:@"理解内存管理"]];
    [self.todoItems addObject:[TodoItem itemWithTitle:@"学习 Foundation 框架"]];

    self.todoItems.firstObject.isCompleted = YES;
}

#pragma mark - UI 搭建

- (void)setupUI {
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.textColor = [UIColor grayColor];
    self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.listLabel = [[UILabel alloc] init];
    self.listLabel.font = [UIFont systemFontOfSize:16];
    self.listLabel.textColor = [UIColor darkGrayColor];
    self.listLabel.numberOfLines = 0;
    self.listLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.countLabel];
    [self.view addSubview:self.listLabel];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [self.countLabel.topAnchor constraintEqualToAnchor:safe.topAnchor constant:16],
        [self.countLabel.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [self.countLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],

        [self.listLabel.topAnchor constraintEqualToAnchor:self.countLabel.bottomAnchor constant:12],
        [self.listLabel.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [self.listLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
    ]];
}

#pragma mark - 事件处理

- (void)addButtonTapped {
    AddTodoViewController *addVC = [[AddTodoViewController alloc] init];
    addVC.delegate = self;
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - AddTodoDelegate

- (void)addTodoViewController:(AddTodoViewController *)controller
              didAddWithTitle:(NSString *)title {
    TodoItem *newItem = [TodoItem itemWithTitle:title];
    [self.todoItems addObject:newItem];
    // viewWillAppear 会自动调用 refreshUI
}

#pragma mark - UI 刷新

- (void)refreshUI {
    NSUInteger total = self.todoItems.count;
    NSUInteger done = 0;
    for (TodoItem *item in self.todoItems) {
        if (item.isCompleted) done++;
    }
    self.countLabel.text = [NSString stringWithFormat:@"共 %lu 项，已完成 %lu 项",
                            (unsigned long)total, (unsigned long)done];

    NSMutableString *listText = [NSMutableString string];
    for (TodoItem *item in self.todoItems) {
        [listText appendFormat:@"%@\n", [item displayText]];
    }
    self.listLabel.text = listText;
}

@end
