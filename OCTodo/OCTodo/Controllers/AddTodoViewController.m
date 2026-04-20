/**
 * AddTodoViewController.m — 添加待办页面
 *
 * 通过 delegate 把新标题回传给 HomeVC
 */

#import "AddTodoViewController.h"
#import "NSString+Validation.h"

@interface AddTodoViewController ()

@property (nonatomic, strong) UITextField *titleField;

@end

@implementation AddTodoViewController

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"添加待办";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupNavigationBar];
    [self setupUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 页面显示后自动弹出键盘
    [self.titleField becomeFirstResponder];
}

#pragma mark - UI 搭建

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                        style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(cancelTapped)];

    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                        style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(saveTapped)];
}

- (void)setupUI {
    UILabel *hintLabel = [[UILabel alloc] init];
    hintLabel.text = @"请输入待办事项标题：";
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor grayColor];
    hintLabel.translatesAutoresizingMaskIntoConstraints = NO;

    self.titleField = [[UITextField alloc] init];
    self.titleField.placeholder = @"例如：学习 AutoLayout";
    self.titleField.borderStyle = UITextBorderStyleRoundedRect;
    self.titleField.font = [UIFont systemFontOfSize:16];
    self.titleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.titleField.returnKeyType = UIReturnKeyDone;
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;

    // 按回车也触发保存
    [self.titleField addTarget:self
                        action:@selector(saveTapped)
              forControlEvents:UIControlEventEditingDidEndOnExit];

    [self.view addSubview:hintLabel];
    [self.view addSubview:self.titleField];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [hintLabel.topAnchor constraintEqualToAnchor:safe.topAnchor constant:24],
        [hintLabel.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [hintLabel.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],

        [self.titleField.topAnchor constraintEqualToAnchor:hintLabel.bottomAnchor constant:8],
        [self.titleField.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
        [self.titleField.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
        [self.titleField.heightAnchor constraintEqualToConstant:44],
    ]];
}

#pragma mark - 事件处理

- (void)cancelTapped {
    if ([self.delegate respondsToSelector:@selector(addTodoViewControllerDidCancel:)]) {
        [self.delegate addTodoViewControllerDidCancel:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveTapped {
    NSString *title = self.titleField.text;

    if ([title oct_isBlank]) {
        [self shakeField];
        return;
    }

    if ([self.delegate respondsToSelector:@selector(addTodoViewController:didAddWithTitle:)]) {
        [self.delegate addTodoViewController:self didAddWithTitle:title];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

/// 输入为空时的抖动动画提示
- (void)shakeField {
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.values = @[@(-8), @(8), @(-6), @(6), @(-3), @(3), @(0)];
    shake.duration = 0.4;
    [self.titleField.layer addAnimation:shake forKey:@"shake"];
}

@end
