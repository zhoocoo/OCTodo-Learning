# 第七课：UIKit 入门 — UIView、UILabel、UIButton

> 开始真正"画界面"。UIKit 之于 iOS，就像 DOM 之于 Web。

---

## 1. UIKit 是什么？

UIKit 是 iOS 的 UI 框架，提供了所有界面元素：按钮、标签、输入框、列表……

```objc
#import <UIKit/UIKit.h>  // 一行导入所有 UI 组件
```

**Web 类比：**
- UIKit ≈ HTML + CSS + DOM API 的合体
- 但 iOS 没有标签语言（没有 HTML），所有 UI 都用代码或可视化工具（Storyboard）创建

## 2. UIView — 万物之父

### 2.1 是什么？

`UIView` 是所有可视元素的基类。UILabel、UIButton、UIImageView…… 全部继承自 UIView。

**Web 类比：** `UIView` ≈ `<div>`。它是最基础的容器，可以设置大小、颜色、圆角，也可以嵌套子视图。

```objc
UIView *box = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 200, 100)];
//                                           x    y    宽    高
box.backgroundColor = [UIColor systemBlueColor];
box.layer.cornerRadius = 10;  // 圆角（类似 CSS border-radius）
[self.view addSubview:box];   // 添加到页面上（类似 appendChild）
```

```css
/* 等价的 CSS */
.box {
    position: absolute;
    left: 20px; top: 100px;
    width: 200px; height: 100px;
    background-color: blue;
    border-radius: 10px;
}
```

### 2.2 CGRect 与坐标系

iOS 的坐标系：**左上角是原点 (0, 0)**，x 向右增大，y 向下增大。

```objc
// CGRectMake(x, y, width, height)
CGRect frame = CGRectMake(20, 100, 200, 50);

// 也可以分开设置
CGFloat x = frame.origin.x;       // 20
CGFloat y = frame.origin.y;       // 100
CGFloat width = frame.size.width;  // 200
CGFloat height = frame.size.height; // 50
```

**Web 类比：** 和 CSS 的 `position: absolute; left; top; width; height` 完全对应。但 iOS 默认就是绝对定位，没有文档流的概念。

### 2.3 frame vs bounds

| 属性 | 含义 | Web 类比 |
|------|------|---------|
| `frame` | 在**父视图**坐标系中的位置和大小 | `element.getBoundingClientRect()` |
| `bounds` | 在**自身**坐标系中的位置和大小（origin 通常是 0,0） | `{ x: 0, y: 0, width, height }` |

```objc
// 一个子视图
UIView *child = [[UIView alloc] initWithFrame:CGRectMake(20, 50, 100, 100)];
// child.frame  = {20, 50, 100, 100}  ← 相对父视图
// child.bounds = {0,  0,  100, 100}  ← 相对自身
```

简单记忆：**frame 问"我在哪"，bounds 问"我多大"。**

### 2.4 视图层级（View Hierarchy）

iOS 的视图是树状结构，和 DOM 树一样：

```objc
// 添加子视图
[parentView addSubview:childView];    // DOM: parent.appendChild(child)

// 移除自己
[childView removeFromSuperview];      // DOM: child.remove()

// 访问层级关系
childView.superview;                  // DOM: child.parentElement
parentView.subviews;                  // DOM: parent.children

// 层级顺序：后添加的在上面（类似 z-index 越大越靠前）
[parentView addSubview:view1];  // 底层
[parentView addSubview:view2];  // 上层（覆盖 view1）

// 调整层级
[parentView bringSubviewToFront:view1]; // 把 view1 提到最上面
[parentView sendSubviewToBack:view2];   // 把 view2 放到最下面
```

## 3. UILabel — 文本显示

```objc
UILabel *label = [[UILabel alloc] init];
label.text = @"Hello, OCTodo!";
label.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
label.textColor = [UIColor darkGrayColor];
label.textAlignment = NSTextAlignmentCenter;  // 文字居中
label.numberOfLines = 0;  // 0 = 不限行数（自动换行）
//                    1 = 单行（超出显示省略号）
```

**Web 类比：**

| UILabel 属性 | CSS/HTML 对应 |
|-------------|--------------|
| `text` | `textContent` / `innerHTML` |
| `font` | `font-size` + `font-weight` |
| `textColor` | `color` |
| `textAlignment` | `text-align` |
| `numberOfLines = 0` | 默认行为（自动换行） |
| `numberOfLines = 1` | `white-space: nowrap; overflow: hidden; text-overflow: ellipsis;` |

### UIFont 常用创建方式

```objc
// 系统字体 + 字号
[UIFont systemFontOfSize:16]

// 系统字体 + 字号 + 字重
[UIFont systemFontOfSize:16 weight:UIFontWeightBold]

// 系统粗体（快捷方式）
[UIFont boldSystemFontOfSize:16]

// 指定字体名称
[UIFont fontWithName:@"PingFangSC-Regular" size:16]
```

## 4. UIButton — 按钮

```objc
// 创建按钮
UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
[addButton setTitle:@"添加待办" forState:UIControlStateNormal];
addButton.titleLabel.font = [UIFont systemFontOfSize:16];

// 绑定点击事件 — 这是 iOS 事件处理的核心模式
[addButton addTarget:self
              action:@selector(addButtonTapped)
    forControlEvents:UIControlEventTouchUpInside];
```

**Web 类比：**
```html
<button onclick="addButtonTapped()">添加待办</button>
```
```javascript
button.addEventListener('click', this.addButtonTapped);
```

### 4.1 Target-Action 模式

```objc
[button addTarget:self                          // 谁来处理？self（当前控制器）
           action:@selector(addButtonTapped)    // 调用哪个方法？
 forControlEvents:UIControlEventTouchUpInside]; // 什么事件触发？手指抬起
```

| 参数 | 含义 | Web 类比 |
|------|------|---------|
| `target` | 事件处理者（通常是 self） | `this`（事件绑定的上下文） |
| `action` | 要调用的方法（用 `@selector` 包装） | 回调函数名 |
| `forControlEvents` | 触发条件 | 事件类型（click、change 等） |

### 4.2 @selector 是什么？

`@selector(methodName)` 把方法名转成一个 `SEL` 类型的值，让系统在运行时能找到这个方法。

```objc
// @selector 类似 JS 中用字符串指定方法名
@selector(addButtonTapped)
// 类似 JS: "addButtonTapped"（用于 object["addButtonTapped"]()）
```

### 4.3 事件处理方法

```objc
// 无参数版本
- (void)addButtonTapped {
    NSLog(@"按钮被点击了");
}

// 带 sender 参数版本（能拿到是哪个按钮触发的）
- (void)addButtonTapped:(UIButton *)sender {
    NSLog(@"按钮 %@ 被点击了", sender.titleLabel.text);
}
```

### 4.4 常用事件类型

| UIControlEvents | 含义 | Web 对应 |
|----------------|------|---------|
| `UIControlEventTouchUpInside` | 手指在按钮内抬起（最常用的"点击"） | `click` |
| `UIControlEventTouchDown` | 手指按下 | `mousedown` / `touchstart` |
| `UIControlEventValueChanged` | 值变化（用于 Switch、Slider） | `change` |
| `UIControlEventEditingChanged` | 文本变化（用于 UITextField） | `input` |

## 5. UITextField — 文本输入框

```objc
UITextField *inputField = [[UITextField alloc] init];
inputField.placeholder = @"请输入待办事项...";
inputField.borderStyle = UITextBorderStyleRoundedRect;
inputField.font = [UIFont systemFontOfSize:16];
inputField.clearButtonMode = UITextFieldViewModeWhileEditing; // 编辑时显示清除按钮
inputField.returnKeyType = UIReturnKeyDone;  // 键盘回车键显示"完成"
```

**Web 类比：**
```html
<input type="text" placeholder="请输入待办事项..." />
```

### 获取输入内容和监听事件

```objc
// 获取文本
NSString *text = inputField.text;

// 监听文本变化
[inputField addTarget:self
               action:@selector(textFieldDidChange:)
     forControlEvents:UIControlEventEditingChanged];

- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"输入了: %@", textField.text);
}

// 收起键盘
[inputField resignFirstResponder];  // 类似 input.blur()
```

## 6. UISwitch — 开关

```objc
UISwitch *toggle = [[UISwitch alloc] init];
toggle.on = NO;
[toggle addTarget:self
           action:@selector(toggleChanged:)
 forControlEvents:UIControlEventValueChanged];

- (void)toggleChanged:(UISwitch *)sender {
    NSLog(@"开关状态: %@", sender.isOn ? @"开" : @"关");
}
```

**Web 类比：** `<input type="checkbox" />`

## 7. UIColor — 颜色

```objc
// 系统预设色
[UIColor redColor]
[UIColor systemBlueColor]    // 自适应深色模式的蓝色

// RGB 自定义（0.0 ~ 1.0，不是 0~255）
[UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0]

// 十六进制（系统没有直接支持，通常用 Category 扩展）
// 这就是第五课 UIColor+Hex Category 的用武之地
```

**Web 类比：**
```css
color: red;
color: rgb(51, 153, 255);
color: #3399FF;
```

## 8. 实战：给 OCTodo 首页加上真正的 UI

现在我们把首页从"一个居中标签"升级为有标题、输入框、按钮的真实界面。

> 代码见项目中更新后的 HomeViewController.m

## 9. 练习

1. `UIView` 和 HTML 的 `<div>` 有什么相似之处？有什么不同？

2. `frame` 和 `bounds` 的区别是什么？什么时候用 frame，什么时候用 bounds？

3. 按钮点击事件中，`@selector(addButtonTapped:)` 最后的冒号是什么意思？去掉会怎样？

4. 为什么 iOS 按钮用 `UIControlEventTouchUpInside` 而不是 `TouchDown` 作为"点击"事件？

> **答案提示：**
> 1. 相似：都是基础容器，可以嵌套、设样式。不同：UIView 默认绝对定位，没有文档流；UIView 用代码创建，不是标签
> 2. frame 是相对父视图的坐标，用于定位子视图；bounds 是相对自身的坐标，用于绘制自身内容和布局子内容
> 3. 冒号表示方法有一个参数（sender），去掉冒号表示方法无参数。两种都可以，但方法签名必须匹配
> 4. TouchUpInside 允许用户"按下后滑出按钮取消操作"，这是更好的交互体验。Web 的 click 其实也是 mouseup 时触发

---

**下一课预告：** 第八课 — UIViewController 生命周期与职责拆分

理解页面从创建到销毁的完整过程，以及如何合理组织页面代码。
