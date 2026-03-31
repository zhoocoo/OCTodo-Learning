# 第四课：Block 与 Protocol — 回调与解耦的核心

> 这节课是从“会写 OC”走向“能组织 OC 代码”的关键一步。

---

## 1. 为什么这一课重要？

在 Web 里我们经常写回调、事件和接口约束：
- 回调函数：`fetch().then(...)`
- 事件处理：`onClick={() => ...}`
- 接口约束：TypeScript `interface`

在 OC 里，这三个角色分别由：
- **Block**（闭包回调）
- **Protocol**（协议约束）
- **Delegate**（协议的一种常见使用方式）

一句话：**Block 解决“做完后通知我”，Protocol 解决“你必须会这些能力”。**

## 2. Block 是什么？

Block 是 OC 的匿名函数，可以像变量一样传递和保存。

```objc
// 声明一个无参无返回值的 Block 变量
void (^simpleBlock)(void) = ^{
    NSLog(@"Hello Block");
};

// 调用 Block（和函数调用类似）
simpleBlock();
```

**Web 类比：**
```javascript
const simpleBlock = () => {
  console.log("Hello Block");
};
simpleBlock();
```

## 3. Block 语法速查

### 3.1 作为变量

```objc
NSInteger (^sumBlock)(NSInteger, NSInteger) = ^NSInteger(NSInteger a, NSInteger b) {
    return a + b;
};
NSLog(@"%ld", (long)sumBlock(3, 5)); // 8
```

### 3.2 作为方法参数（最常见）

```objc
- (void)loadTodosWithCompletion:(void (^)(NSArray *items))completion {
    NSArray *items = @[@"学习 Block", @"学习 Protocol"];
    if (completion) {
        completion(items);
    }
}
```

**Web 类比：**
```javascript
function loadTodos(completion) {
  const items = ["学习 Block", "学习 Protocol"];
  completion?.(items);
}
```

### 3.3 typedef 简化复杂声明（推荐）

```objc
typedef void (^TodoLoadCompletion)(NSArray *items);

- (void)loadTodosWithCompletion:(TodoLoadCompletion)completion;
```

这和 TypeScript 的类型别名几乎一样：
```typescript
type TodoLoadCompletion = (items: string[]) => void;
```

## 4. Block 的内存注意点（重点）

### 4.1 为什么 Block 属性通常用 `copy`？

```objc
@property (nonatomic, copy) void (^onComplete)(void);
```

历史上 Block 可能在栈上，`copy` 能确保它被拷贝到堆上长期持有。  
在 ARC 下多数场景会自动处理，但**属性声明仍然建议统一用 `copy`**。

### 4.2 Block 循环引用（高频坑）

```objc
// ❌ self 强持有 block，block 又捕获 self
self.onComplete = ^{
    self.title = @"完成";
};
```

```objc
// ✅ weak/strong dance
__weak typeof(self) weakSelf = self;
self.onComplete = ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (!strongSelf) return;
    strongSelf.title = @"完成";
};
```

## 5. Protocol 是什么？

Protocol 是“能力清单”，定义“你需要实现哪些方法”，不关心具体实现细节。

```objc
@protocol TodoEditorDelegate <NSObject>

@required
- (void)todoEditorDidSave:(NSString *)title;

@optional
- (void)todoEditorDidCancel;

@end
```

**Web 类比（TypeScript）：**
```typescript
interface TodoEditorDelegate {
  todoEditorDidSave(title: string): void;   // required
  todoEditorDidCancel?(): void;             // optional
}
```

## 6. Delegate 模式：Protocol 的经典落地

Delegate 常用于“子页面把结果回传给父页面”。

### 6.1 定义协议和代理属性

```objc
@protocol AddTodoViewControllerDelegate <NSObject>
- (void)addTodoViewControllerDidFinish:(NSString *)title;
@end

@interface AddTodoViewController : UIViewController
@property (nonatomic, weak) id<AddTodoViewControllerDelegate> delegate;
@end
```

为什么 `delegate` 用 `weak`？  
因为通常父页面 `strong` 持有子页面，子页面再 `strong` 持有父页面会循环引用。

### 6.2 回调给代理对象

```objc
- (void)saveAction {
    if ([self.delegate respondsToSelector:@selector(addTodoViewControllerDidFinish:)]) {
        [self.delegate addTodoViewControllerDidFinish:self.titleTextField.text];
    }
}
```

### 6.3 父页面遵守协议

```objc
@interface HomeViewController () <AddTodoViewControllerDelegate>
@end

@implementation HomeViewController

- (void)addTodoViewControllerDidFinish:(NSString *)title {
    NSLog(@"收到新待办: %@", title);
}

@end
```

## 7. Block vs Protocol：什么时候用哪个？

| 场景 | 推荐 | 原因 |
|------|------|------|
| 一次性结果回调（请求完成、弹窗确认） | Block | 简洁、就地定义 |
| 需要多个事件回调（开始/进行中/结束） | Protocol | 结构清晰，可扩展 |
| 组件长期通信（如表格代理） | Protocol + delegate | Apple 官方生态一致 |
| 简单页面间传值 | Block 或 Protocol | 两者都可，优先团队约定 |

简单判断：
- **单回调、短链路**：优先 Block
- **多回调、长生命周期**：优先 Protocol

## 8. 与当前 OCTodo 项目的连接点

你已经在项目里见过 Block 雏形：

```objc
// TodoItem.h
@property (nonatomic, copy) void (^onComplete)(void);
```

本课之后你需要有两个意识：
1. 这个 Block 属性必须防循环引用。  
2. 如果后面“新增待办页”需要回传多个事件，应该切换为 Protocol + delegate。

## 9. 练习

1. 把下面的方法改成 `typedef` 版本：
```objc
- (void)requestData:(void (^)(NSDictionary *result, NSError *error))completion;
```

2. 为什么 delegate 属性几乎总是 `weak`？

3. 下面代码有没有循环引用风险？如何改？
```objc
self.onComplete = ^{
    [self refreshUI];
};
```

4. 什么时候你会选 Block，什么时候会选 Protocol？

> **答案提示：**
> 1. 可定义 `typedef void (^RequestCompletion)(NSDictionary *result, NSError *error);`
> 2. 打破双向 strong 持有，避免对象无法释放
> 3. 有风险，使用 `weakSelf/strongSelf`
> 4. 单次回调用 Block；多事件/长期协作用 Protocol

---

**下一课预告：** 第五课 — Category / Extension（如何在不改原类源码的前提下扩展能力）
