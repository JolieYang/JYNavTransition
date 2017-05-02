//
//  JYNavInteractiveTransition.m
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import "JYNavInteractiveTransition.h"
#import "JYNavigationController.h"

@interface JYNavInteractiveTransition ()<UIViewControllerInteractiveTransitioning>
@property (nonatomic, strong) JYNavigationController *navigationController;
@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, assign) CGFloat percentComplete;

@property (nonatomic, strong) UIImageView *toImageView;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation JYNavInteractiveTransition

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"startInteractiveTransition");
}

- (void)pushToViewController:(UIViewController *)vc {
    self.navigationController = (JYNavigationController *)vc.navigationController;
    [self addGestureRecognizerInView:vc.view];
}

- (void)addGestureRecognizerInView:(UIView *)view {
    self.fullScreenGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.fullScreenGesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:self.fullScreenGesture];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            [self dragBegin:gestureRecognizer];
            
            break;
        case UIGestureRecognizerStateChanged: {
            [self dragging:gestureRecognizer];
            
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [self dragEnd:gestureRecognizer];
            
            break;
        }
        default:
            break;
    }
}

- (void)dragBegin:(UIPanGestureRecognizer *)gestrueRecognizer {
    self.interacting = YES;
    
    if (self.navigationController.popCount > 0) {
        [self.navigationController clearCurrentScreenShot];
    }
    
    if (!self.toImageView) {
        self.toImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.navigationController.view.window insertSubview:self.toImageView atIndex:0];
    }
    if (!self.maskView) {
        self.maskView = [[UIView alloc] initWithFrame:self.toImageView.frame];
        self.maskView.backgroundColor = [UIColor blackColor];
        [self.navigationController.view.window insertSubview:self.maskView aboveSubview:self.toImageView];
    }
    
    self.toImageView.image = self.navigationController.screenShots.lastObject;
}

- (void)dragging:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat percentComplete = translation.x / kAppWidth;// translation.x代表向右滑动，translation.y代表向下滑动
    percentComplete = fminf(fmaxf(percentComplete, 0.0), 1.0);
    self.shouldComplete = (percentComplete > 0.5);
    if (percentComplete > 0) {
        [self updateInteractiveTransition:percentComplete];
    }
}

- (void)dragEnd:(UIPanGestureRecognizer *)gestureRecognizer {
    self.interacting = NO;
    if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self cancelInterfactiveTransition];
    } else {
        [self finishInteractiveTransition];
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    self.navigationController.view.transform = CGAffineTransformMakeTranslation(percentComplete * kAppWidth, 0);
    self.toImageView.transform = CGAffineTransformMakeTranslation((percentComplete - 1) * kAppWidth, 0);
    double alpha = kMaskViewDefaultAlpha * (1 - percentComplete);
    self.maskView.alpha = alpha;
}

- (void)cancelInterfactiveTransition {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.transform = CGAffineTransformIdentity;
        self.toImageView.transform = CGAffineTransformMakeTranslation(-kAppWidth, 0);
        self.maskView.alpha = kMaskViewDefaultAlpha;
    } completion:^(BOOL finished) {
    }];
}

- (void)finishInteractiveTransition {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(kAppWidth, 0);
        self.toImageView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.toImageView removeFromSuperview];
        self.toImageView = nil;
        [self.maskView removeFromSuperview];
        self.maskView = nil;
        self.navigationController.view.transform = CGAffineTransformIdentity;
        [self.navigationController popViewControllerAnimated:NO];
    }];
}
@end
