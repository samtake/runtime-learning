//
//  ViewController.m
//  runtime-learning
//
//  Created by 黄龙山 on 2019/8/12.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "msgForwarding.h"

#import "ViewController.h"
#import <objc/runtime.h>


#import "methodSwizzling.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    msgForwarding *msgfw = [[msgForwarding alloc] init];
    [msgfw test];
    
    
//    methodSwizzling *ms = [[methodSwizzling alloc]init];
//    [ms otherTest];
    
    
}




@end
