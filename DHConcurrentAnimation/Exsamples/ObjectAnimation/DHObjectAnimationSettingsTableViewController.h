//
//  DHObjectAnimationSettingsTableViewController.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/20/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHAnimationEnums.h"
@interface DHObjectAnimationSettingsTableViewController : UITableViewController
@property (nonatomic) DHObjectAnimationType type;
@property (nonatomic) DHAnimationEvent event;
@end
