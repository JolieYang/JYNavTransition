//
//  JYAnimation.m
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "JYNavAnimation.h"
#import "JYNavigationController.h"

@interface JYNavAnimation ()
@property (nonatomic, strong) JYNavigationController *navigationController;
@property (nonatomic, strong) NSMutableArray *screenShots;
@end

@implementation JYNavAnimation

- (NSMutableArray *)screenShots {
    if (!_screenShots) {
        _screenShots = [[NSMutableArray alloc] init];
    }
    return _screenShots;
}

#pragma mark -- UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.navigationController = (JYNavigationController *)toViewController.navigationController;
    
    self.screenShots = self.navigationController.screenShots;
    
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (self.navigationControllerOperation == UINavigationControllerOperationPush) {
        UIImageView *preImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        preImageView.image = self.screenShots.lastObject;
        [self.navigationController.view.window addSubview:preImageView];
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(kAppWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            preImageView.center = CGPointMake(-kAppWidth/2, kAppHeight/2);
        } completion:^(BOOL finished) {
            [preImageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    } else if (self.navigationControllerOperation == UINavigationControllerOperationPop) {
        //自定义Pop动画效果
        UIImageView *preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kAppWidth, 0, kAppWidth, kAppHeight)];
        preImageView.image = self.screenShots.lastObject;
        [self.navigationController.view.window addSubview:preImageView];
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        currentImageView.image = [self.navigationController screenShotInNavigationController:self.navigationController];
        [self.navigationController.view addSubview:currentImageView];
        
        toViewController.view.frame = CGRectMake(-kAppWidth, 0, kAppWidth, kAppHeight);
        fromViewController.view.backgroundColor = [UIColor grayColor];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            currentImageView.center = CGPointMake(kAppWidth * 3 / 2, kAppHeight/2);
            preImageView.center = CGPointMake(kAppWidth/2, kAppHeight/2);
            toViewController.view.frame = CGRectMake(0, 0, kAppWidth, kAppHeight);
        } completion:^(BOOL finished) {
            [self.screenShots removeLastObject];
            [currentImageView removeFromSuperview];
            [preImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}

@end
