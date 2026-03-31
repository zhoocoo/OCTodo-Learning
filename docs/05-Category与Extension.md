# 第五课：Category 与 Extension — 不改源码也能扩展类

> 在 Web 里我们用 mixin、prototype 扩展、工具函数来增强现有对象。OC 用 Category 和 Extension。

---

## 1. 问题场景

假设你想给 `NSString` 加一个方法：判断字符串是否为空或者只有空格。

在 JS 里你可能会：
```javascript
// 方案1：原型扩展（不推荐但很常见）
String.prototype.isBlank = function() {
    return this.trim().length === 0;
};

// 方案2：工具函数
function isBlank(str) {
    return str.trim().length === 0;
}
```

OC 里你不能修改 `NSString` 的源码（它是系统类），但你可以用 **Category** 给它加方法。

## 2. Category（分类）

### 2.1 是什么？

Category 能在**不修改原类源码**的前提下，给现有类添加方法。

### 2.2 语法

Category 也有 `.h` + `.m` 两个文件，命名规则：`原类名+分类名`。

```objc
// ====== NSString+Validation.h ======
#import <Foundation/Foundation.h>

// @interface 原类名 (分类名)
@interface NSString (Validation)

/// 是否为空或只有空白字符
- (BOOL)isBlank;

/// 是否是合法的邮箱格式
- (BOOL)isValidEmail;

@end
```

```objc
// ====== NSString+Validation.m ======
#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isBlank {
    // self 就是调用这个方法的字符串本身
    NSString *trimmed = [self stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmed.length == 0;
}

- (BOOL)isValidEmail {
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

@end
```

```objc
// 使用：就像 NSString 本来就有这些方法一样
#import "NSString+Validation.h"

NSString *title = @"  ";
if ([title isBlank]) {
    NSLog(@"标题不能为空");
}

NSString *email = @"test@example.com";
if ([email isValidEmail]) {
    NSLog(@"邮箱格式正确");
}
```

**Web 类比：**
```javascript
// 效果等价于给 String.prototype 加方法
// 但 Category 更安全：有独立文件、有命名空间（分类名）
"  ".isBlank()          // true
"test@example.com".isValidEmail()  // true
```

### 2.3 Category 能做什么，不能做什么？

| 能做 | 不能做 |
|------|--------|
| 添加**实例方法** | ❌ 添加实例变量（属性的存储） |
| 添加**类方法** | ❌ 覆盖原类方法（能写但强烈不推荐，行为不确定） |
| 拆分大类的代码到多个文件 | |

**不能加属性的原因：** Category 在运行时动态附加方法，但不能修改类的内存布局（实例变量在编译时就确定了）。

> 技术上可以通过 runtime 的 `objc_setAssociatedObject` 间接实现，但这属于进阶用法，后面 Runtime 课再讲。

### 2.4 Category 的实际用途

**用途1：给系统类添加便捷方法**
```objc
// UIColor+Hex.h — 给 UIColor 加一个十六进制颜色方法
@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(NSString *)hex;
@end
```

**用途2：拆分大文件**
```objc
// 当一个类太大时，按功能拆成多个 Category 文件
// HomeViewController+TableView.h  — 表格相关代码
// HomeViewController+Network.h    — 网络请求相关代码
// HomeViewController+UI.h         — 界面搭建相关代码
```

## 3. Extension（类扩展 / 匿名分类）

### 3.1 是什么？

Extension 写在 `.m` 文件内部，用于声明**私有**属性和方法。

```objc
// HomeViewController.m

// 这就是 Extension，写在 @implementation 之前
@interface HomeViewController ()

// 私有属性：只有这个 .m 文件内部能访问
@property (nonatomic, strong) NSMutableArray<TodoItem *> *todoItems;
@property (nonatomic, assign) BOOL isLoading;

// 私有方法声明（可选，OC 中不声明也能用，但声明了更清晰）
- (void)setupData;
- (void)setupUI;

@end

@implementation HomeViewController
// ...
@end
```

**你已经在用它了！** 回顾 HomeViewController.m 开头的 `@interface HomeViewController ()`，那就是 Extension。

### 3.2 Web 类比

```typescript
// Extension 类似 TypeScript/JS 中的"私有成员"
class HomeViewController {
    // public（.h 文件里声明的）
    public title: string;

    // private（Extension 里声明的）
    private todoItems: TodoItem[];
    private isLoading: boolean;
    
    private setupData(): void { ... }
    private setupUI(): void { ... }
}
```

### 3.3 Extension 能做什么？

| 能做 | 说明 |
|------|------|
| 添加**私有属性**（带存储） | 和 .h 里的属性一样，可以有实例变量 |
| 声明**私有方法** | 让代码意图更清晰 |
| 遵守**私有协议** | 不暴露给外部 |

## 4. Category vs Extension 对比

| | Category | Extension |
|--|----------|-----------|
| **写在哪里** | 独立的 `.h` + `.m` 文件 | 写在 `.m` 文件内部 |
| **能加属性吗** | ❌ 不能（无存储） | ✅ 能 |
| **能加方法吗** | ✅ 能 | ✅ 能 |
| **可见性** | 公开（谁 import 谁能用） | 私有（只有本 .m 文件可见） |
| **能给系统类用吗** | ✅ 能（你没有系统类的 .m） | ❌ 不能（必须有源码） |
| **典型用途** | 扩展系统类、拆分大文件 | 声明私有属性和方法 |
| **JS 类比** | `String.prototype.xxx = ...` | `class { #privateField }` |

**简单记忆：**
- 想给**别人的类**加方法 → **Category**
- 想给**自己的类**加私有成员 → **Extension**

## 5. 实战：在 OCTodo 项目中使用

### 5.1 给 NSString 添加验证方法（Category）

创建 `NSString+Validation`，后续添加待办事项时用来验证标题是否为空。

### 5.2 给 TodoItem 添加便捷方法（Category）

创建 `TodoItem+Display`，把展示相关的方法从模型主体中拆出来。

### 5.3 使用 Extension 声明私有属性

你在 HomeViewController.m 中已经这样做了，这是 OC 项目中的标准模式。

## 6. 命名规范

| 文件 | 命名规则 | 示例 |
|------|---------|------|
| Category `.h` | `原类名+分类名.h` | `NSString+Validation.h` |
| Category `.m` | `原类名+分类名.m` | `NSString+Validation.m` |
| 方法前缀 | 给系统类加方法时建议加前缀，避免和系统/三方库冲突 | `oct_isBlank` 而不是 `isBlank` |

方法前缀的原因：如果 Apple 未来给 NSString 也加了 `isBlank` 方法，你的 Category 方法可能会被覆盖，行为不可预测。加个项目前缀（如 `oct_`）就安全了。

## 7. 练习

1. Category 和 Extension 最核心的区别是什么？一句话概括。

2. 你想给 `UIView` 加一个快捷方法 `- (void)roundCorners:(CGFloat)radius;`，应该用 Category 还是 Extension？为什么？

3. 下面的代码能编译通过吗？为什么？
```objc
// NSString+Extra.h
@interface NSString (Extra)
@property (nonatomic, strong) NSString *tag;  // 给 Category 加属性
@end
```

4. 为什么给系统类的 Category 方法建议加前缀？

> **答案提示：**
> 1. Category 加公开方法（独立文件），Extension 加私有成员（.m 内部）
> 2. Category。因为 UIView 是系统类，你没有它的 .m 文件，不能用 Extension
> 3. 编译能过（编译器生成 getter/setter 声明），但运行时会崩溃，因为 Category 不能生成实例变量来存储值
> 4. 避免和 Apple 未来新增的方法或第三方库的方法命名冲突

---

**下一课预告：** 第六课 — Xcode 工程结构与 iOS App 生命周期

从语法阶段进入 iOS 开发实战阶段，理解一个 App 从启动到关闭经历了什么。
