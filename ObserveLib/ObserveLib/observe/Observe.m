/**
 *  结构1:   B监听A的属性
 *
 *  结构2:
 *          1) C监听B的属性
 *          2) C的回调函数中，获得B的发生改变的属性名、属性值
 *          3) C调用B的函数/Block，将发生改变的数据传到B
 *
 *          总结:  在A与B之间，建立一个中间者C , 代替B 监听A
 */

#import "Observe.h"


@implementation Observe


- (void)dealloc {
    
    /** 移除监听对象的属性 */
    [self removeObserverAllKeyPaths];
    
    /** release对象 */
    self.observedOBJ = nil;
    self.targetOBJ = nil;
    self.block = nil;
    
    NSLog(@"Observe对象: %@ 已经释放\n", self);
}

- (id)initWithObservedOBJ:(id)observedObj KeyPaths:(NSArray *)keyPaths OnTarget:(id)targetObj TargetSEL:(SEL)sel
{
    self = [super init];
    if (self != nil) {
        
        if (observedObj && targetObj) {
            
            //1. 保存变量
            self.observedOBJ = observedObj;
            self.targetOBJ = targetObj;
            self.targetSEL = sel;
            self.keyPaths = [keyPaths copy];
            
            //2. 建立 传入的被观察者 与 当前Obersve对象的 关系
            for (NSString * keyPath in self.keyPaths) {
                [self.observedOBJ addObserver:self
                                   forKeyPath:keyPath
                                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                      context:(__bridge void *)(self)];//context必须指定为中间者
            }
            
            return self;
        }
        NSLog(@"观察对象和被观察对象2个都不能为空!\n");
        return nil;
    }
    return nil;
}

- (id)initWithObservedOBJ:(id)observedObj KeyPaths:(NSArray *)keyPaths Complet:(ObserveCompletBlock)block {
    
    self = [super init];
    if (self) {
        
        if (observedObj) {
            
            //1. 保存变量
            self.observedOBJ = observedObj;
            self.keyPaths = [keyPaths copy];
            self.block = block;
            
            //2. 建立 传入的被观察者 与 当前Obersve对象的 关系
            for (NSString * keyPath in keyPaths) {
                [self.observedOBJ addObserver:self
                                   forKeyPath:keyPath
                                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                      context:(__bridge void *)(self)];//context必须指定为中间者
            }
        }
        
        return self;
    }
    return nil;
}

- (void)removeObserverAllKeyPaths {
    [self removeObserverAtKeyPaths:self.keyPaths];
}

- (void)removeObserverAtKeyPaths:(NSArray *)keyPaths {
    for (NSString * keyPath in keyPaths) {
        [self removeObserverAtKeyPath:keyPath];
    }
}

- (void)removeObserverAtKeyPath:(NSString *)keyPath {
    if (self.observedOBJ) {
        [self.observedOBJ removeObserver:self forKeyPath:keyPath];
    }
}

#pragma mark - 属性改变回调函数
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    //context == 当前Observe对象
    if (context == (__bridge void*)self) {
        
        if ([self.targetOBJ respondsToSelector:self.targetSEL]) {
            
            //使用字典封装接收到的回调数据
            NSDictionary * dict = @{
                                    @"keyPath":keyPath,                             //改变的属性
                                    @"object":object,                               //属性所属对象
                                    @"new":change[@"new"],                          //新值
                                    @"old":change[@"old"]                           //旧值
                                    };
            
            //指定观察者的方法
            [self.targetOBJ performSelector:self.targetSEL withObject:dict];
        }
        else {
            
            //指定观察者传入的Block代码块
            if (self.block != nil) {
                self.block(keyPath, object, change[@"new"], change[@"old"]);
            }
        }
    }
    
}

@end
