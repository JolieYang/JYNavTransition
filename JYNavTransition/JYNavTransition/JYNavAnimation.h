//
//  JYAnimation.h
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/26.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAppWidth [[UIScreen mainScreen] bounds].size.width
#define kAppHeight [[UIScreen mainScreen] bounds].size.height

@interface JYNavAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) UINavigationControllerOperation navigationControllerOperation;

@end
