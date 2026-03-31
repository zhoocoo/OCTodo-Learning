# 第三课：Foundation 框架 — OC 的标准库

> Foundation 之于 OC，就像 JS 内置对象（String/Array/Object）之于 JavaScript

---

## 1. Foundation 是什么？

Foundation 是 Apple 提供的基础框架，包含了 OC 开发中最常用的数据类型和工具类。

```objc
#import <Foundation/Foundation.h>  // 一行导入所有基础类型
```

**Web 类比：** 不需要 `npm install`，Foundation 就是 OC 的"内置标准库"，类似 JS 自带的 `String`、`Array`、`Date`、`JSON` 等。

## 2. NSString — 字符串

### 2.1 创建字符串

```objc
// 字面量（最常用）
NSString *str = @"Hello";
// JS: const str = "Hello";

// 格式化创建（类似模板字符串）
NSString *greeting = [NSString stringWithFormat:@"你好 %@，你有 %ld 个待办", name, count];
// JS: const greeting = `你好 ${name}，你有 ${count} 个待办`;

// 从其他字符串创建
NSString *copy = [NSString stringWithString:@"Hello"];
```

### 2.2 常用操作对照

| 操作 | JavaScript | Objective-C |
|------|-----------|-------------|
| 长度 | `str.length` | `str.length` |
| 拼接 | `str1 + str2` | `[str1 stringByAppendingString:str2]` |
| 是否包含 | `str.includes("abc")` | `[str containsString:@"abc"]` |
| 查找位置 | `str.indexOf("abc")` | `[str rangeOfString:@"abc"].location` |
| 截取 | `str.substring(1, 3)` | `[str substringWithRange:NSMakeRange(1, 2)]` |
| 替换 | `str.replace("a", "b")` | `[str stringByReplacingOccurrencesOfString:@"a" withString:@"b"]` |
| 大写 | `str.toUpperCase()` | `[str uppercaseString]` |
| 去空格 | `str.trim()` | `[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]` |
| 分割 | `str.split(",")` | `[str componentsSeparatedByString:@","]` |
| 相等比较 | `str1 === str2` | `[str1 isEqualToString:str2]` |

**⚠️ 重要区别：OC 中 `==` 比较的是指针地址，不是内容！**

```objc
NSString *a = @"Hello";
NSString *b = @"Hello";
if (a == b) { }              // 比较地址（碰巧相等，因为编译器优化）
if ([a isEqualToString:b]) { } // 比较内容 ✅ 永远用这个
```

### 2.3 NSString vs NSMutableString

```objc
// NSString — 不可变（类似 JS 的 string，本来就不可变）
NSString *str = @"Hello";
// str 没有 append 方法，不能修改

// NSMutableString — 可变（类似 JS 数组的 push）
NSMutableString *mStr = [NSMutableString stringWithString:@"Hello"];
[mStr appendString:@" World"];  // mStr 变成 "Hello World"
[mStr insertString:@"Say " atIndex:0]; // "Say Hello World"
```

**这就是为什么 NSString 属性要用 `copy`** — 防止别人传入 NSMutableString 后在外部修改它。

## 3. NSArray — 数组

### 3.1 创建数组

```objc
// 字面量（最常用）
NSArray *fruits = @[@"苹果", @"香蕉", @"橙子"];
// JS: const fruits = ["苹果", "香蕉", "橙子"];

// 空数组
NSArray *empty = @[];
// JS: const empty = [];
```

### 3.2 常用操作对照

| 操作 | JavaScript | Objective-C |
|------|-----------|-------------|
| 长度 | `arr.length` | `arr.count` |
| 取元素 | `arr[0]` | `arr[0]` 或 `[arr objectAtIndex:0]` |
| 是否包含 | `arr.includes(x)` | `[arr containsObject:x]` |
| 查找位置 | `arr.indexOf(x)` | `[arr indexOfObject:x]` |
| 遍历 | `arr.forEach(fn)` | `for (id obj in arr)` 或 `[arr enumerateObjectsUsingBlock:]` |
| 拼接为字符串 | `arr.join(",")` | `[arr componentsJoinedByString:@","]` |
| 第一个/最后一个 | `arr[0]` / `arr.at(-1)` | `arr.firstObject` / `arr.lastObject` |

### 3.3 遍历方式

```objc
NSArray *items = @[@"学习OC", @"写代码", @"看文档"];

// 方式1：快速枚举（最常用，类似 JS 的 for...of）
for (NSString *item in items) {
    NSLog(@"%@", item);
}

// 方式2：带索引的遍历（类似 JS 的 forEach）
[items enumerateObjectsUsingBlock:^(NSString *item, NSUInteger idx, BOOL *stop) {
    NSLog(@"%lu: %@", (unsigned long)idx, item);
    // *stop = YES;  // 设置 stop 可以中断遍历，类似 JS 里 break
}];

// 方式3：经典 for 循环
for (NSUInteger i = 0; i < items.count; i++) {
    NSLog(@"%lu: %@", (unsigned long)i, items[i]);
}
```

### 3.4 NSArray vs NSMutableArray

```objc
// NSArray — 不可变（创建后不能增删）
NSArray *arr = @[@1, @2, @3];
// 没有 add/remove 方法

// NSMutableArray — 可变（类似 JS 数组，能增删改）
NSMutableArray *mArr = [NSMutableArray arrayWithArray:@[@1, @2, @3]];
[mArr addObject:@4];           // push  → [1,2,3,4]
[mArr insertObject:@0 atIndex:0]; // unshift → [0,1,2,3,4]
[mArr removeObjectAtIndex:2];  // splice(2,1) → [0,1,3,4]
[mArr removeLastObject];       // pop → [0,1,3]
[mArr removeAllObjects];       // arr.length = 0
```

**⚠️ OC 数组只能放对象，不能放基本类型：**
```objc
NSArray *nums = @[@1, @2, @3];     // ✅ @1 是 NSNumber 对象
// NSArray *nums = @[1, 2, 3];     // ❌ 1 是 int 基本类型，不能放入数组
// @1 就是 [NSNumber numberWithInt:1] 的简写
```

## 4. NSDictionary — 字典（对应 JS 的 Object/Map）

### 4.1 创建字典

```objc
// 字面量
NSDictionary *person = @{
    @"name": @"小明",
    @"age": @25,
    @"isStudent": @YES
};
// JS: const person = { name: "小明", age: 25, isStudent: true };

// 空字典
NSDictionary *empty = @{};
```

### 4.2 常用操作对照

| 操作 | JavaScript | Objective-C |
|------|-----------|-------------|
| 取值 | `obj.name` 或 `obj["name"]` | `dict[@"name"]` 或 `[dict objectForKey:@"name"]` |
| 所有 key | `Object.keys(obj)` | `[dict allKeys]` |
| 所有 value | `Object.values(obj)` | `[dict allValues]` |
| 键值对数量 | `Object.keys(obj).length` | `dict.count` |
| 是否有某个 key | `"name" in obj` | `dict[@"name"] != nil` |

### 4.3 NSMutableDictionary — 可变字典

```objc
NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

// 添加/修改
mDict[@"name"] = @"小明";           // JS: obj.name = "小明"
mDict[@"age"] = @25;                // JS: obj.age = 25

// 删除
[mDict removeObjectForKey:@"age"];  // JS: delete obj.age

// 遍历
[mDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
    NSLog(@"%@: %@", key, value);
}];
// JS: Object.entries(obj).forEach(([key, value]) => console.log(key, value))
```

## 5. NSNumber — 数字的对象包装

OC 的数组和字典只能放对象，基本类型（int、float、BOOL）需要包装成 NSNumber：

```objc
// 字面量语法（@符号）
NSNumber *intNum = @42;          // int → NSNumber
NSNumber *floatNum = @3.14;      // float → NSNumber
NSNumber *boolNum = @YES;        // BOOL → NSNumber

// 取回基本类型
int a = [intNum intValue];           // NSNumber → int
float b = [floatNum floatValue];     // NSNumber → float
BOOL c = [boolNum boolValue];       // NSNumber → BOOL

// 放入数组/字典
NSArray *nums = @[@1, @2, @3];              // 都是 NSNumber
NSDictionary *d = @{@"count": @10};        // value 是 NSNumber
```

**Web 类比：** JS 中 number 就是 number，不需要包装。OC 区分了"基本类型"和"对象类型"，基本类型要放进集合时必须包一层 NSNumber。类似 Java 的 `int` vs `Integer`。

## 6. 可变 vs 不可变 — OC 的核心设计哲学

这是 OC 和 JS 最大的设计差异之一：

| 不可变（Immutable） | 可变（Mutable） |
|---------------------|----------------|
| `NSString` | `NSMutableString` |
| `NSArray` | `NSMutableArray` |
| `NSDictionary` | `NSMutableDictionary` |
| `NSSet` | `NSMutableSet` |

**为什么要分可变和不可变？**

1. **线程安全**：不可变对象天然线程安全，多线程读不会出问题
2. **性能**：不可变对象可以被编译器优化（共享内存）
3. **防御性编程**：传出去的数据不会被外部修改

**JS 中的对应：**
```javascript
// JS 本身没有强制不可变，但有类似概念：
const arr = [1, 2, 3];          // const 防止重新赋值，但内容能改
Object.freeze(arr);              // freeze 让内容也不能改 ← 类似 NSArray
// 或者
const arr2 = [...arr, 4];       // 不修改原数组，创建新数组 ← OC 的不可变思路
```

**实际使用规则：**
- `@property` 声明优先用**不可变**类型（NSArray、NSDictionary）
- 方法内部需要增删改时用**可变**类型（NSMutableArray）
- 对外暴露时转回不可变：`[mutableArray copy]`

```objc
// 常见模式：内部可变，对外不可变
@interface TodoManager : NSObject
@property (nonatomic, copy) NSArray *items;  // 对外暴露不可变数组
@end

@implementation TodoManager
- (void)loadItems {
    NSMutableArray *temp = [NSMutableArray array];  // 内部用可变数组构建
    [temp addObject:[[TodoItem alloc] initWithTitle:@"任务1"]];
    [temp addObject:[[TodoItem alloc] initWithTitle:@"任务2"]];
    self.items = temp;  // copy 属性会自动转成不可变的 NSArray
}
@end
```

## 7. 其他常用 Foundation 类

### 7.1 NSDate — 日期

```objc
NSDate *now = [NSDate date];                    // JS: new Date()
NSDate *tomorrow = [now dateByAddingTimeInterval:86400]; // 加一天（秒数）

// 格式化
NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
fmt.dateFormat = @"yyyy-MM-dd HH:mm";
NSString *str = [fmt stringFromDate:now];       // "2026-03-30 16:30"
// JS: new Intl.DateTimeFormat(...).format(date)
```

### 7.2 NSURL — URL

```objc
NSURL *url = [NSURL URLWithString:@"https://api.example.com/todos"];
// JS: new URL("https://api.example.com/todos")
```

### 7.3 NSNull — 集合中的空值

```objc
// OC 的数组/字典不能放 nil，但可以放 NSNull
NSArray *arr = @[@"a", [NSNull null], @"c"];
// 判断是否是 null
if (arr[1] == [NSNull null]) {
    NSLog(@"这是个空值");
}
// JS 中 null 可以直接放进数组：["a", null, "c"]
```

## 8. 实战：给 TodoItem 添加更多功能

```objc
// 在 TodoItem.m 中添加一些实用方法

/// 返回创建时间的格式化字符串
- (NSString *)createdAtString {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM-dd HH:mm";
    return [fmt stringFromDate:self.createdAt];
}

/// 返回标题的字数统计
- (NSUInteger)titleLength {
    return self.title.length;
}
```

## 9. 练习

1. `NSString *a = @"Hello"; NSString *b = @"Hello"; a == b` 的结果是什么？为什么？用什么方法比较内容？

2. 如何把 `@[@"苹果", @"香蕉", @"橙子"]` 拼成字符串 `"苹果,香蕉,橙子"`？

3. `NSArray *arr = @[1, 2, 3];` 这行代码有什么问题？怎么修复？

4. 为什么 `@property` 声明数组时建议用 `NSArray` 而不是 `NSMutableArray`？

5. 下面的代码输出什么？
```objc
NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"a", @"b", @"c", nil];
NSArray *copy = [arr copy];
[arr addObject:@"d"];
NSLog(@"arr: %lu, copy: %lu", arr.count, copy.count);
```

> **答案提示：**
> 1. 结果可能是 YES（编译器对相同字面量做了优化，指向同一地址），但**不要依赖这个行为**。用 `[a isEqualToString:b]` 比较内容
> 2. `[@[@"苹果", @"香蕉", @"橙子"] componentsJoinedByString:@","]`
> 3. 基本类型 `1, 2, 3` 不能放进数组，需要包装成 NSNumber：`@[@1, @2, @3]`
> 4. 不可变类型更安全，防止外部拿到数组后随意增删；配合 copy 属性，即使内部用 NSMutableArray 赋值也会变成不可变的
> 5. 输出 `arr: 4, copy: 3`。copy 是不可变的深拷贝，arr 后续的修改不影响 copy

---

**下一课预告：** 第四课 — Block 与 Protocol 深入（Block 作为参数传递、协议的 required/optional、多协议遵守）
