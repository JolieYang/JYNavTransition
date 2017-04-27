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
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, assign) BOOL shouldComplete;

@property (nonatomic, strong) UIImageView *screenShotImageView;
@property (nonatomic, strong) UIImageView *toImageView;
@property (nonatomic, strong) NSMutableArray *screenShots;

@property (nonatomic, assign) CGFloat percentComplete;

@property (nonatomic, assign) BOOL haveScreenshot;// 是否已截取过当前的截图
@end

@implementation JYNavInteractiveTransition

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"startInteractiveTransition");
}

- (NSMutableArray *)screenShots {
    if (!_screenShots) {
        _screenShots = [[NSMutableArray alloc] init];
    }
    return _screenShots;
}

- (void)pushToViewController:(UIViewController *)vc {
    self.pushToVC = vc;
    self.navigationController = self.pushToVC.navigationController;
    [self addGestureRecognizerInView:vc.view];
}

- (void)addGestureRecognizerInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:gesture];
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
    JYNavigationController *navController = (JYNavigationController *)self.navigationController;
    self.screenShots = navController.screenShots;
    
    self.interacting = YES;
    
    if (!self.haveScreenshot) {
        [self.screenShots addObject: [navController screenShotInNavigationController:self.navigationController]];
        self.haveScreenshot = YES;
    }
    
    self.screenShotImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.toImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-kAppWidth, 0, kAppWidth, kAppWidth)];
    self.screenShotImageView.image = self.screenShots[self.screenShots.count - 2];
    
    [self.navigationController.view.window insertSubview:self.screenShotImageView atIndex:0];
}

- (void)dragging:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    CGFloat fraction = translation.x / 400.0;// 设置向右滑动400像素及以上代表100%，translation.x代表向右，translation.y代表向下滑动
    fraction = fminf(fmaxf(fraction, 0.0), 1.0);
    self.shouldComplete = (fraction > 0.5);
    if (fraction > 0) {
        [self updateInteractiveTransition:fraction];
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
    self.screenShotImageView.transform = CGAffineTransformMakeTranslation(percentComplete*kAppWidth - kAppWidth, 0);
}

- (void)cancelInterfactiveTransition {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.transform = CGAffineTransformIdentity;
        self.screenShotImageView.transform = CGAffineTransformMakeTranslation(-kAppWidth, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)finishInteractiveTransition {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.view.transform = CGAffineTransformMakeTranslation(kAppWidth, 0);
        self.screenShotImageView.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [self.screenShotImageView removeFromSuperview];
        self.navigationController.view.transform = CGAffineTransformIdentity;
        [self.navigationController popViewControllerAnimated:NO];
        [self.screenShots removeLastObject];
        [self.screenShots removeLastObject];
        self.haveScreenshot = NO;
    }];
}

@end
