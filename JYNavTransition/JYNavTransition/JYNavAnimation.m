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
@end

@implementation JYNavAnimation

#pragma mark -- UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.4f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    self.navigationController = (JYNavigationController *)toViewController.navigationController;
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    if (self.navigationControllerOperation == UINavigationControllerOperationPush) {
        fromImageView.image = self.navigationController.screenShots.lastObject;
        [self.navigationController.view.window addSubview:fromImageView];
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(kAppWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            fromImageView.center = CGPointMake(-kAppWidth/2, kAppHeight/2);
        } completion:^(BOOL finished) {
            [fromImageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    } else if (self.navigationControllerOperation == UINavigationControllerOperationPop) {
        UIImageView *toImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kAppWidth, 0, kAppWidth, kAppHeight)];
        toImageView.image = self.navigationController.screenShots.lastObject;
        [self.navigationController.view.window addSubview:toImageView];
        fromImageView.image = [self.navigationController screenShot];
        [self.navigationController.view addSubview:fromImageView];
        
        toViewController.view.frame = CGRectMake(-kAppWidth, 0, kAppWidth, kAppHeight);
        fromViewController.view.backgroundColor = [UIColor grayColor];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromImageView.center = CGPointMake(kAppWidth * 3 / 2, kAppHeight/2);
            toImageView.center = CGPointMake(kAppWidth/2, kAppHeight/2);
            toViewController.view.frame = CGRectMake(0, 0, kAppWidth, kAppHeight);
        } completion:^(BOOL finished) {
            [fromImageView removeFromSuperview];
            [toImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

@end
