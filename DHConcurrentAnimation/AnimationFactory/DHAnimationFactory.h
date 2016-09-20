//
//  DHAnimationFactory.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DHAnimation.h"
#import "DHAnimationEnums.h"

@interface DHAnimationFactory : NSObject

+ (NSArray *) transitions;
+ (NSArray *) builtInAnimations;
+ (NSArray *) builtOutAnimations;
+ (NSArray *) textAnimations;

+ (DHAnimation *)animationOfType:(DHObjectAnimationType)type
                           event:(DHAnimationEvent)event
                       forTarget:(UIView *)target
                   animationView:(GLKView *)animationView;


+ (DHObjectAnimationType) animationTypeForName:(NSString *)animationName;
@end
