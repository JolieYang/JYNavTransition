//
//  ThirdViewController.h
//  JYNavTransition
//
//  Created by Jolie_Yang on 2017/4/27.
//  Copyright © 2017年 JolieYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ThirdViewController : UIViewController

@property (nonatomic, strong) FirstViewController *firstVC;
@property (nonatomic, strong) SecondViewController *secondVC;
@end
