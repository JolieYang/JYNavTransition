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
    
//    self.screenShots = self.navigationController.screenShots;
//    UIImage *screenImage = self.screenShots.lastObject;
    UIImage *screenImage = [JYNavAnimation screenShotInNavigationController:self.navigationController];
    [self.screenShots addObject:screenImage];
    
    UIImageView *screenImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    screenImageView.image = screenImage;
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    if (self.navigationControllerOperation == UINavigationControllerOperationPush) {
        [self.navigationController.view.window addSubview:screenImageView];
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(kAppWidth, 0);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.navigationController.view.transform = CGAffineTransformMakeTranslation(0, 0);
            screenImageView.center = CGPointMake(-kAppWidth/2, kAppHeight/2);
        } completion:^(BOOL finished) {
            [screenImageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    } else if (self.navigationControllerOperation == UINavigationControllerOperationPop) {
        //自定义Pop动画效果
        UIImageView *preImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kAppWidth, 0, kAppWidth, kAppHeight)];
        preImageView.image = self.screenShots[self.screenShots.count - 2];
        [self.navigationController.view.window addSubview:preImageView];
        [self.navigationController.view addSubview:screenImageView];
        
        toViewController.view.frame = CGRectMake(-kAppWidth, 0, kAppWidth, kAppHeight);
        fromViewController.view.backgroundColor = [UIColor grayColor];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            screenImageView.center = CGPointMake(kAppWidth * 3 / 2, kAppHeight/2);
            preImageView.center = CGPointMake(kAppWidth/2, kAppHeight/2);
            toViewController.view.frame = CGRectMake(0, 0, kAppWidth, kAppHeight);
        } completion:^(BOOL finished) {
            [screenImageView removeFromSuperview];
            [preImageView removeFromSuperview];
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    
}

#pragma mark -- Tool
+ (UIImage *)screenShotInNavigationController:(UINavigationController *)navigationController {
    UIViewController *beyondVC = navigationController.view.window.rootViewController;
    CGSize size = beyondVC.view.frame.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGRect rect = CGRectMake(0, 0, kAppWidth, kAppHeight);
    if (navigationController.tabBarController == beyondVC) {
        [beyondVC.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    } else {
        [navigationController.view drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    }
    
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenShot;
}
@end
