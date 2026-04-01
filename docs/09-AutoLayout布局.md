# 第九课：AutoLayout 实战布局

> 告别硬编码坐标，用约束系统实现自适应布局。

---

## 1. 为什么需要 AutoLayout？

iPhone 屏幕尺寸越来越多（SE、普通、Plus、Pro Max），用固定坐标（`CGRectMake(20, 100, 200, 50)`）会导致：
- 小屏幕放不下
- 大屏幕留白太多
- 横屏直接炸

**Web 类比：**
- 固定坐标 = `position: absolute; left: 20px; top: 100px;`（不响应式）
- AutoLayout = `Flexbox / Grid`（自适应）

## 2. AutoLayout 核心概念

AutoLayout 通过**约束（Constraint）**描述视图之间的关系，系统自动计算位置和大小。

一条约束的公式：

```
view1.attribute = view2.attribute × multiplier + constant
```

举例：
```
label.leading = superview.leading × 1 + 16
// label 的左边 = 父视图的左边 + 16pt（即左边距 16）
```

**Web 类比：**
```css
/* 约束思维 vs CSS 思维 */
/* AutoLayout: "我的左边距离父容器左边 16pt" */
/* CSS: margin-left: 16px; 或 padding-left: 16px; */
```

## 3. 三种写法

### 3.1 NSLayoutConstraint（原生 API）

```objc
// 最原始的写法，冗长但完整
NSLayoutConstraint *constraint = [NSLayoutConstraint
    constraintWithItem:label                    // view1
             attribute:NSLayoutAttributeLeading  // view1 的属性
             relatedBy:NSLayoutRelationEqual     // 关系（=、>=、<=）
                toItem:self.view                 // view2
             attribute:NSLayoutAttributeLeading  // view2 的属性
            multiplier:1.0                       // 倍数
              constant:16];                      // 常量
constraint.active = YES;
```

**几乎没人这样写，太啰嗦了。** 了解即可。

### 3.2 Anchor API（推荐！项目中一直在用）

```objc
// 简洁、可读性好，我们项目中用的就是这种
label.translatesAutoresizingMaskIntoConstraints = NO; // 必须！

[NSLayoutConstraint activateConstraints:@[
    [label.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
    [label.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100],
    [label.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
    // 注意：右边和底部的 constant 是负数
]];
```

### 3.3 VFL（Visual Format Language）

```objc
// 用字符串描述布局，像画 ASCII 图
// H: 水平方向，V: 垂直方向
// | 表示父视图边缘，- 表示间距
NSDictionary *views = @{@"label": label};
[NSLayoutConstraint activateConstraints:
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[label]-16-|"
                                           options:0
                                           metrics:nil
                                             views:views]];
// 含义：水平方向，父视图左边距 16，然后是 label，再 16，到父视图右边
```

**了解即可，Anchor API 是主流。**

## 4. Anchor API 详解

### 4.1 可用的 Anchor 属性

| Anchor | 含义 | CSS 类比 |
|--------|------|---------|
| `topAnchor` | 顶部 | `top` |
| `bottomAnchor` | 底部 | `bottom` |
| `leadingAnchor` | 前缘（LTR 下是左边） | `left` / `margin-left` |
| `trailingAnchor` | 后缘（LTR 下是右边） | `right` / `margin-right` |
| `centerXAnchor` | 水平居中 | `margin: 0 auto` |
| `centerYAnchor` | 垂直居中 | `align-self: center` |
| `widthAnchor` | 宽度 | `width` |
| `heightAnchor` | 高度 | `height` |

**leading/trailing vs left/right：**
- `leading/trailing` 会自动适配 RTL 语言（阿拉伯语、希伯来语）
- 推荐始终用 `leading/trailing`

### 4.2 三种约束关系

```objc
// 等于
[view.widthAnchor constraintEqualToConstant:100]

// 大于等于
[view.widthAnchor constraintGreaterThanOrEqualToConstant:50]

// 小于等于
[view.widthAnchor constraintLessThanOrEqualToConstant:300]
```

### 4.3 constant 的正负号规则

```objc
// 记忆口诀：往右往下为正，往左往上为负

// 左边距 16（向右偏移，正数）
[view.leadingAnchor constraintEqualToAnchor:superview.leadingAnchor constant:16]

// 右边距 16（向左偏移，负数）
[view.trailingAnchor constraintEqualToAnchor:superview.trailingAnchor constant:-16]

// 上边距 20（向下偏移，正数）
[view.topAnchor constraintEqualToAnchor:superview.topAnchor constant:20]

// 下边距 20（向上偏移，负数）
[view.bottomAnchor constraintEqualToAnchor:superview.bottomAnchor constant:-20]
```

## 5. Safe Area — 安全区域

iPhone X 之后有刘海和底部横条，内容不能被遮挡：

```objc
// ❌ 不用 safe area — 内容可能被刘海遮挡
[view.topAnchor constraintEqualToAnchor:self.view.topAnchor]

// ✅ 用 safe area — 自动避开刘海和底部
UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
[view.topAnchor constraintEqualToAnchor:safe.topAnchor]
```

**Web 类比：**
```css
/* iOS safe area 类似 CSS 的 env() */
padding-top: env(safe-area-inset-top);
padding-bottom: env(safe-area-inset-bottom);
```

我们项目中已经在用了：
```objc
UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
[self.inputField.topAnchor constraintEqualToAnchor:safe.topAnchor constant:16],
```

## 6. translatesAutoresizingMaskIntoConstraints

每次用代码创建 AutoLayout 约束前，都必须设置这个：

```objc
view.translatesAutoresizingMaskIntoConstraints = NO;
```

**为什么？**
- iOS 有一套旧的布局系统叫 autoresizing mask（类似百分比布局）
- 默认为 YES，系统会自动把 frame 转成约束，和你手动加的约束冲突
- 设为 NO 告诉系统"我要自己管约束"

**简单记忆：** 代码创建的视图，加约束前先设 `translatesAutoresizingMaskIntoConstraints = NO`。Storyboard 创建的不用管（自动设好了）。

## 7. 常见布局模式

### 7.1 固定大小居中

```objc
// 一个 200×200 的方块居中
UIView *box = [[UIView alloc] init];
box.translatesAutoresizingMaskIntoConstraints = NO;
[self.view addSubview:box];

[NSLayoutConstraint activateConstraints:@[
    [box.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [box.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    [box.widthAnchor constraintEqualToConstant:200],
    [box.heightAnchor constraintEqualToConstant:200],
]];
```

```css
/* 等价 CSS */
.box { width: 200px; height: 200px; margin: auto; /* flexbox 居中 */ }
```

### 7.2 填满父视图（带边距）

```objc
[NSLayoutConstraint activateConstraints:@[
    [view.topAnchor constraintEqualToAnchor:safe.topAnchor constant:16],
    [view.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],
    [view.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
    [view.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-16],
]];
```

```css
/* 等价 CSS */
.view { position: absolute; inset: 16px; }
```

### 7.3 水平排列（输入框 + 按钮）

我们项目中已经有了这个布局：

```objc
// 输入框：左对齐，右边留出按钮的空间
[inputField.leadingAnchor constraintEqualToAnchor:safe.leadingAnchor constant:16],

// 按钮：紧挨输入框右侧，右对齐
[button.leadingAnchor constraintEqualToAnchor:inputField.trailingAnchor constant:8],
[button.trailingAnchor constraintEqualToAnchor:safe.trailingAnchor constant:-16],
[button.widthAnchor constraintEqualToConstant:64],
```

```css
/* 等价 CSS flexbox */
.row { display: flex; gap: 8px; padding: 0 16px; }
.input { flex: 1; }
.button { width: 64px; }
```

### 7.4 垂直列表（从上往下排）

```objc
// A 在最上面
[viewA.topAnchor constraintEqualToAnchor:safe.topAnchor constant:16],

// B 在 A 下面
[viewB.topAnchor constraintEqualToAnchor:viewA.bottomAnchor constant:12],

// C 在 B 下面
[viewC.topAnchor constraintEqualToAnchor:viewB.bottomAnchor constant:12],
```

```css
/* 等价 CSS */
.container { display: flex; flex-direction: column; gap: 12px; padding-top: 16px; }
```

## 8. Intrinsic Content Size（固有内容大小）

有些控件**不需要设宽高**，因为它们知道自己多大：

| 控件 | 固有大小 |
|------|---------|
| `UILabel` | 根据文本和字体自动计算 |
| `UIButton` | 根据标题和内边距自动计算 |
| `UIImageView` | 根据图片尺寸 |
| `UIView` | ❌ 没有，必须手动指定 |

```objc
// UILabel 只需要指定位置，不需要指定宽高
UILabel *label = [[UILabel alloc] init];
label.text = @"Hello";
label.translatesAutoresizingMaskIntoConstraints = NO;
[self.view addSubview:label];

[NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
    // 不需要 widthAnchor / heightAnchor，label 自己知道多大
]];
```

**Web 类比：** 就像 HTML 的 `<span>` 天然是由内容撑开的，不需要指定宽高。

## 9. 约束冲突调试

当约束有冲突时，控制台会打印紫色警告。常见原因：

| 问题 | 原因 | 解决 |
|------|------|------|
| `Unable to simultaneously satisfy constraints` | 约束矛盾（比如同时设了宽度=100 和 左右边距=16） | 检查是否多加了约束 |
| `has ambiguous layout` | 约束不够（缺少宽度或位置信息） | 补充缺少的约束 |
| 视图位置不对 | 忘记设 `translatesAutoresizingMaskIntoConstraints = NO` | 加上这行 |

**调试技巧：** 在 Xcode 运行时点击底部 Debug 栏的 **View Hierarchy** 按钮（方块叠方块图标），可以 3D 查看所有视图层级和约束。

## 10. 练习

1. 为什么 `trailingAnchor` 和 `bottomAnchor` 的 constant 通常是负数？

2. 下面的代码有什么问题？
```objc
UILabel *label = [[UILabel alloc] init];
[self.view addSubview:label];
[label.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
[label.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
```

3. `UILabel` 不需要设宽高约束也能显示，但 `UIView` 不行，为什么？

4. `leading/trailing` 和 `left/right` 有什么区别？应该用哪个？

> **答案提示：**
> 1. 因为坐标系以左上角为原点，trailing 和 bottom 方向的偏移是"往里缩"，需要负值
> 2. 忘记设 `label.translatesAutoresizingMaskIntoConstraints = NO`，会导致自动生成的约束和手动约束冲突
> 3. UILabel 有 intrinsic content size（由文本和字体决定），系统能自动计算大小；UIView 没有内容，系统不知道它应该多大
> 4. leading/trailing 自动适配 RTL 语言（右到左），left/right 不会。推荐用 leading/trailing

---

**下一课预告：** 第十课 — UINavigationController、页面跳转与数据回传

实现多页面交互：从首页跳转到"添加待办"页面，添加完成后回传数据。
