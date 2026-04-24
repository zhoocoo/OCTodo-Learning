/**
 * HomeViewController.m — 首页控制器
 *
 * 第十一课重构：数据层抽取到 TodoStore（MVC 的 Model 层）
 * VC 只负责协调：读 Store 的数据展示，把用户操作交给 Store 处理
 */

#import "HomeViewController.h"
#import "TodoStore.h"
#import "TodoItem+Display.h"
#import "AddTodoViewController.h"

@interface HomeViewController () <AddTodoDelegate>

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
    [self setupUI];

    // 监听 Store 数据变化，自动刷新 UI
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(storeDidChange:)
                                                 name:TodoStoreDidChangeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshUI];
}

- (void)dealloc {
    // ⚠️ 必须移除监听，否则通知发送时会崩溃
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 导航栏

- (void)setupNavigationBar {
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                     target:self
                                                     action:@selector(addButtonTapped)];
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
    // 不再自己维护数组，交给 Store
    [[TodoStore sharedStore] addItemWithTitle:title];
    // Store 会发通知，storeDidChange: 会被自动调用刷新 UI
}

#pragma mark - Store 变更通知

- (void)storeDidChange:(NSNotification *)note {
    [self refreshUI];
}

#pragma mark - UI 刷新

- (void)refreshUI {
    NSArray<TodoItem *> *items = [TodoStore sharedStore].items;

    NSUInteger total = items.count;
    NSUInteger done = 0;
    for (TodoItem *item in items) {
        if (item.isCompleted) done++;
    }
    self.countLabel.text = [NSString stringWithFormat:@"共 %lu 项，已完成 %lu 项",
                            (unsigned long)total, (unsigned long)done];

    NSMutableString *listText = [NSMutableString string];
    for (TodoItem *item in items) {
        [listText appendFormat:@"%@\n", [item displayText]];
    }
    self.listLabel.text = listText;
}

@end
