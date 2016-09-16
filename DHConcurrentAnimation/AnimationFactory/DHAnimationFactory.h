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

typedef NS_ENUM(NSInteger, DHTransitionType) {
    DHTransitionTypeNone,
};

typedef NS_ENUM(NSInteger, DHObjectAnimationType) {
    DHObjectAnimationTypeNone,
    DHObjectAnimationTypeClothLine,
};

typedef NS_ENUM(NSInteger, DHTextAnimationType) {
    DHTextAnimationTypeNone,
};

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
