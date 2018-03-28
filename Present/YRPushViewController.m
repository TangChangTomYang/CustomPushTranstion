//
//  YRPushViewController.m
//  Present
//
//  Created by mango on 2018/3/28.
//  Copyright © 2018年 mango. All rights reserved.
//

#import "YRPushViewController.h"
#import "YRPushTranstionAnimation.h"
#import "YRPopViewController.h"


@interface YRPushViewController ()<UINavigationControllerDelegate>

@property(strong,nonatomic)NSMutableArray <UIButton*> *buttonArr;

@property(strong,nonatomic)UIButton *btnA;
@property(strong,nonatomic)UIButton *btnB;
@property(strong,nonatomic)UIButton *btnC;
@property(strong,nonatomic)UIButton *btnD;

@end

@implementation YRPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self addButton];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)addButton{
    
    self.buttonArr = [NSMutableArray array];
    
    CGFloat margin=50;
    CGFloat width=(self.view.frame.size.width-margin*3)/2;
    CGFloat height = width;
    CGFloat x = 0;
    CGFloat y = 0;
    //列
    NSInteger col = 2;
    for (NSInteger i = 0; i < 4; i ++) {
        
        x = margin + (i%col)*(margin+width);
        y = margin + (i/col)*(margin+height) + 150;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, width, height);
        button.layer.cornerRadius = width * 0.5;
        [button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
        button.tag = i+1;
        [self.view addSubview:button];
        [self.buttonArr addObject:button];
    }
    
}




- (void)setupButtonAnimation{
    
    [self.buttonArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //沿着中心左移5上移5
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.calculationMode = kCAAnimationPaced;
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.repeatCount = MAXFLOAT;
        positionAnimation.autoreverses = YES;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.duration = (idx == self.buttonArr.count - 1) ? 4 : 5+idx;
        
        UIBezierPath *positionPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, button.frame.size.width/2-5, button.frame.size.height/2-5)];
        positionAnimation.path = positionPath.CGPath;
        [button.layer addAnimation:positionAnimation forKey:nil];
        
        // scaleXAniamtion
        CAKeyframeAnimation *scaleXAniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
        scaleXAniamtion.values = @[@1.0,@1.1,@1.0];
        scaleXAniamtion.keyTimes = @[@0.0,@0.5,@1.0];
        scaleXAniamtion.repeatCount = MAXFLOAT;
        scaleXAniamtion.autoreverses = YES;
        scaleXAniamtion.duration = 4+idx;
        [button.layer addAnimation:scaleXAniamtion forKey:nil];
        
        // scaleYAniamtion
        CAKeyframeAnimation *scaleYAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        scaleYAnimation.values = @[@1,@1.1,@1.0];
        scaleYAnimation.keyTimes = @[@0.0,@0.5,@1.0];
        scaleYAnimation.autoreverses = YES;
        scaleYAnimation.repeatCount = YES;
        scaleYAnimation.duration = 4+idx;
        [button.layer addAnimation:scaleYAnimation forKey:nil];
        
    }];
}

-(void)btnclick:(UIButton *)btn{
    self.button=btn;
    YRPopViewController *pushVC = [YRPopViewController new];
    [self.navigationController pushViewController:pushVC animated:YES];
}

#pragma mark -- UINavigationControllerDelegate --

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPush) {
        return [YRPushTranstionAnimation new];
    }
    else{
        return nil;
    }
}


@end
