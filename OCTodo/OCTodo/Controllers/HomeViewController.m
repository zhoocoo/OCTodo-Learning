/**
 * HomeViewController.m — 首页控制器实现
 *
 * 这是我们 OCTodo App 的主页面
 * 后续会在这里展示 Todo 列表
 */

#import "HomeViewController.h"

@implementation HomeViewController

/// viewDidLoad: 视图加载完成后调用（只调用一次）
/// 【Web 类比】类似 React 的 componentDidMount / useEffect([], ...)
/// 这是设置 UI 和初始化数据的最佳时机
- (void)viewDidLoad {
    [super viewDidLoad]; // 必须调用父类方法

    // 设置页面标题（显示在导航栏上）
    self.title = @"OCTodo";

    // 设置背景色
    // 【OC 语法】[类名 方法名] 是 OC 调用方法的方式
    // 类似 JS 的 ClassName.methodName()
    self.view.backgroundColor = [UIColor whiteColor];

    // 添加一个欢迎标签，确认 App 能正常运行
    [self setupWelcomeLabel];
}

/// 设置欢迎标签
- (void)setupWelcomeLabel {
    // 创建标签（类似 HTML 的 <p> 或 <span>）
    UILabel *welcomeLabel = [[UILabel alloc] init];
    welcomeLabel.text = @"欢迎来到 OCTodo!";
    welcomeLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;

    // 关闭 autoresizing（使用 AutoLayout 必须设置这个）
    // 类似 CSS 里切换 position 模式
    welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    // 添加到视图上（类似 DOM 的 appendChild）
    [self.view addSubview:welcomeLabel];

    // AutoLayout 约束（类似 CSS 的 flexbox 居中）
    // 把标签放在页面正中间
    [NSLayoutConstraint activateConstraints:@[
        [welcomeLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [welcomeLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
}

@end
