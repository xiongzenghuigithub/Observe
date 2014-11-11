//
//  ViewController.m
//  ObserveLib
//
//  Created by xiongzenghui on 14/11/11.
//  Copyright (c) 2014年 observe. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#include "Observe.h"

@interface ViewController () {
    
    Observe * observe;
    Person * p;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    p = [[Person alloc] init];
    p.name = @"1111";
    p.address = @"2222";
    p.age = 19;
    p.sex = YES;
//    observe = [[Observe alloc] initWithObservedOBJ:p KeyPaths:@[@"name" , @"address"] OnTarget:self TargetSEL:@selector(dataChange:)];
    
    observe = [[Observe alloc] initWithObservedOBJ:p KeyPaths:@[@"name" , @"address", @"age" , @"sex"] Complet:^(NSString *keyPath, id observedOBJ, id newValue, id oldValue) {
        
        NSLog(@"%@ - %@ - %@ - %@" , keyPath, observedOBJ , newValue, oldValue);
    }];
    
    
    
    [p setValue:@"3333" forKey:@"name"];
    [p setValue:@"4444" forKey:@"address"];
    [p setValue:@20 forKey:@"age"];
    [p setValue:@NO forKey:@"sex"];
    
    observe = nil;
    p = nil;
}


- (void)dataChange:(NSDictionary * )dict  {
    
    NSString * keyPath = dict[@"keyPath"];
    
    //Person类属性
    if ([dict[@"object"] isKindOfClass:[Person class]]) {
        
        if ([keyPath isEqualToString:@"name"]) {
            NSLog(@"name新值 = %@\n" , dict[@"new"]);
            NSLog(@"name旧值 = %@\n" , dict[@"old"]);
        }
        else if ([keyPath isEqualToString:@"address"]) {
            NSLog(@"address新值 = %@\n" , dict[@"new"]);
            NSLog(@"address旧值 = %@\n" , dict[@"old"]);

        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
