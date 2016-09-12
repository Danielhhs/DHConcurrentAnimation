//
//  DHAnimation.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimationSettings.h"

@interface DHAnimation : NSObject

@property (nonatomic, strong) DHAnimationSettings *settings;

- (void) setupWithSettings:(DHAnimationSettings *)settings;
- (void) start;

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval;

@end
