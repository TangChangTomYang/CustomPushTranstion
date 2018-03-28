//
//  YRPopViewController.m
//  Present
//
//  Created by mango on 2018/3/28.
//  Copyright © 2018年 mango. All rights reserved.
//

#import "YRPopViewController.h"
#import "YRPopTranstionAnimation.h"

@interface YRPopViewController ()<UINavigationControllerDelegate>

@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@property(nonatomic, strong)UIImageView *imageView;

@end

@implementation YRPopViewController

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"1"];
        [self.view addSubview:_imageView];
    }
    return _imageView;
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
    [self imageView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.view addGestureRecognizer:panGesture];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
    
}

-(void)panGestureAction:(UIPanGestureRecognizer *)panGesture{
    
    NSLog(@"-----------------------------");
    
    CGFloat transLationX = [panGesture translationInView:self.view].x;
    UIGestureRecognizerState state = panGesture.state ;
    
    if (transLationX > 0) {
        
        CGFloat percent = transLationX / self.view.bounds.size.width;
        percent = MIN(1.0,(MAX(0.0, percent)));
        
        if (state == UIGestureRecognizerStateBegan) {
            
            self.percentDrivenTransition = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if (state == UIGestureRecognizerStateChanged){
            
            if(transLationX ==0){
                
                [self.percentDrivenTransition updateInteractiveTransition:0.01];
                
            }else{
                
                [self.percentDrivenTransition updateInteractiveTransition:percent];
            }
            
        }
        else if (state == UIGestureRecognizerStateEnded ||
                   state == UIGestureRecognizerStateCancelled){
            
            if(transLationX == 0){
                
                [self.percentDrivenTransition cancelInteractiveTransition];
                self.percentDrivenTransition = nil;
                
            }else if (percent > 0.5) {
                
                [ self.percentDrivenTransition finishInteractiveTransition];
                
            }else{
                
                [ self.percentDrivenTransition cancelInteractiveTransition];
            }
            self.percentDrivenTransition = nil;
        }
        
        
    }
    else{
        
        
        if (state == UIGestureRecognizerStateChanged){
            
            [self.percentDrivenTransition updateInteractiveTransition:0.01];
            [self.percentDrivenTransition cancelInteractiveTransition];
            
        } else if ((state == UIGestureRecognizerStateEnded ||
                    state == UIGestureRecognizerStateCancelled)){
            
            self.percentDrivenTransition = nil;
        }
        
        
    }
    
}


#pragma mark -- UINavigationControllerDelegate --
//为这个动画添加用户交互
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.percentDrivenTransition;
}



- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if (operation == UINavigationControllerOperationPop) {
        return [YRPopTranstionAnimation new];
    }
    else{
        return nil;
    }
}




















@end
