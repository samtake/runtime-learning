//
//  methodSwizzling.m
//  runtime-learning
//
//  Created by 黄龙山 on 2019/8/12.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "methodSwizzling.h"
#import <objc/runtime.h>

@implementation methodSwizzling

+(void)load{
    Method test = class_getInstanceMethod(self, @selector(test));
    Method otherTest = class_getInstanceMethod(self, @selector(otherTest));
    
    method_exchangeImplementations(test, otherTest);
}


-(void)test{
    NSLog(@"test");
}

-(void)otherTest{
    [self otherTest];
    NSLog(@"otherTest");
}

@end
