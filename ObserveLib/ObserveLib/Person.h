//
//  Person.h
//  ObserveLib
//
//  Created by xiongzenghui on 14/11/11.
//  Copyright (c) 2014年 observe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, assign) int age;
@property (nonatomic, assign) BOOL sex;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * address;

@end
