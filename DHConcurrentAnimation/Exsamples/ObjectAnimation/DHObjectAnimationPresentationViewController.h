//
//  DHObjectAnimationPresentationViewController.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHAnimationFactory.h"
#import "DHAnimationEnums.h"

@interface DHObjectAnimationPresentationViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic) DHAnimationEvent event;

@end
