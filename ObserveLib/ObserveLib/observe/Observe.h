//
//  Observe.h
//  ObserveLib
//
//  Created by xiongzenghui on 14/11/11.
//  Copyright (c) 2014年 observe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ObserveCompletBlock)(NSString * keyPath , id observedOBJ , id newValue , id oldValue);

@interface Observe : NSObject

@property (nonatomic, weak)id observedOBJ;                      //保存 被观察者
@property (nonatomic, strong)NSArray * keyPaths;                //保存 被观察者的所有属性名
@property (nonatomic, weak)id targetOBJ;
@property (nonatomic, assign)SEL targetSEL;
@property (nonatomic, copy)ObserveCompletBlock block;

/**
 *  建立 观察者、Obsere对象、被观察者 三者的关系
 *
 *  @param observedObj 被观察对象
 *  @param keyPaths    被观察对象的属性列表
 *  @param targetObj   观察对象
 *  @param sel         观察对象的回调方法
 */
- initWithObservedOBJ:(id)observedObj
              KeyPaths:(NSArray *)keyPaths
             OnTarget:(id)targetObj
            TargetSEL:(SEL)sel;

/**
 *  建立 观察者、Obsere对象、被观察者 三者的关系
 *
 *  @param observedObj 被观察者对象
 *  @param keyPaths    被观察对象的属性列表
 *  @param block       属性变化后的回调代码块Block
 */
- (id)initWithObservedOBJ:(id)observedObj
                  KeyPaths:(NSArray *)keyPaths
                  Complet:(ObserveCompletBlock)block;


- (void)removeObserverAtKeyPath:(NSString *)keyPath;
- (void)removeObserverAtKeyPaths:(NSArray *)keyPaths;
- (void)removeObserverAllKeyPaths;

@end
