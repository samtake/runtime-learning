# runtime-learning
runtime 学习总结
在iOS动态运行时中，涉及到的有以下几个：
- 消息传递
- 方法缓存查找
- 消息转发
- 方法混淆(Method-Swizzling)
- 动态添加方法
- 动态方法解析
- 应用场景
- 学习链接



### 消息传递

![消息传递流程.png](https://upload-images.jianshu.io/upload_images/3850802-928547f28ebd7050.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

这个过程中涉及到的函数
```
id objc_msgSend ( id self, SEL op, ... );
void objc_msgSendSuper ( struct objec_super *super, SEL op, ... );
```
像：`[self class]、[super class]`无论他们最终被哪个对象调用，最后的接收者都是当前对象。


### 方法缓存查找
- 在search_method_list函数中，会去判断当前methodList是否有序，如果有序，会调用findMethodInSortedMethodList方法，这个方法里面的实现是一个二分搜索。如果非有序，就调用线性的傻瓜式遍历搜索。
- 如果父类找到NSObject还没有找到，那么就会开始尝试_class_resolveMethod方法。
- _class_resolveMethod这个函数首先判断是否是meta-class类，如果不是元类，就执行_class_resolveInstanceMethod，如果是元类，执行_class_resolveClassMethod。这里有一个lookUpImpOrNil的函数调用。
- 如果lookUpImpOrNil返回nil，就代表在父类中的缓存中找到，于是需要再调用一次_class_resolveInstanceMethod方法。保证给sel添加上了对应的IMP。
- 在lookUpImpOrForward方法中，如果也没有找到IMP的实现，那么method resolver也没用了，只能进入消息转发阶段。进入这个阶段之前，imp变成_objc_msgForward_impcache。最后再加入缓存中。

### 消息转发
```
2019-08-12 02:24:21.425776+0800 runtime-learning[46126:1176084] resolveInstanceMethod:
2019-08-12 02:24:21.425942+0800 runtime-learning[46126:1176084] forwardingTargetForSelector:
2019-08-12 02:24:21.426039+0800 runtime-learning[46126:1176084] methodSignatureForSelector:
2019-08-12 02:24:21.426164+0800 runtime-learning[46126:1176084] forwardInvocation:
```
### 方法混淆(Method-Swizzling)
```
+(void)load{
    Method test = class_getClassMethod(self, @selector(test));
    Method otherTest = class_getClassMethod(self, @selector(otherTest));
    
    method_exchangeImplementations(test, otherTest);
}
```
一般用于了解用户行为以及分析线上问题而进行的埋点：对页面进入次数、页面停留时间、点击事件的埋点。

### 动态添加方法
demo里没有`test`方法的实现，通过`class_addMethod`添加它的实现：
```
void testIMP (void){
    NSLog(@"testIMP invoke");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        
        NSLog(@"resolveInstanceMethod:");
        
        
        //动态添加test方法的实现
        class_addMethod(self, @selector(test), testIMP, "v@:");
        
        return NO;
    }
    return [super resolveInstanceMethod:sel];
}
```

```
2019-08-12 03:17:26.040536+0800 runtime-learning[46921:1198653] resolveInstanceMethod:
2019-08-12 03:17:26.040895+0800 runtime-learning[46921:1198653] testIMP invoke
```
 
### 动态方法解析
`@dynamic` 声明的属性，`get方法`、`set方法`都是在运行时添加，而不是在编译器声明具体的实现。

### 应用场景
 ```
主要学一下某些框架里的实际应用场景
```
### 学习链接

[文中的一些demo](https://github.com/samtake/runtime-learning)

runtime官方API [https://developer.apple.com/documentation/objectivec/objective-c_runtime?preferredLanguage=occ](https://developer.apple.com/documentation/objectivec/objective-c_runtime?preferredLanguage=occ)

GitHub上的[runtime 源码](https://github.com/0xxd0/objc4)

德志 (@halfrost 的三篇关于runtime的文章
[objc_runtime_isa_class](https://halfrost.com/objc_runtime_isa_class/)、[objc_runtime_objc_msgsend](https://halfrost.com/objc_runtime_objc_msgsend/)、[how_to_use_runtime](https://halfrost.com/how_to_use_runtime/)

