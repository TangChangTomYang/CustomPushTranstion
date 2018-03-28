//
//  ViewController.m
//  Present
//
//  Created by mango on 2018/3/28.
//  Copyright © 2018年 mango. All rights reserved.
//

#import "ViewController.h"
#import "YRPushViewController.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController pushViewController:[YRPushViewController new] animated:YES];

}

@end
