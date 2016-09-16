//
//  DHAnimationFactory.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationFactory.h"
#import "DHAnimationSettings.h"
#import "DHObjectClothLineAnimation.h"

static NSArray *transitions;
static NSArray *builtInAnimations;
static NSArray *builtOutAnimations;
static NSArray *textAnimations;

@implementation DHAnimationFactory

#pragma mark - Get AnimationType from name
+ (DHObjectAnimationType) animationTypeForName:(NSString *)animationName
{
    if ([animationName isEqualToString:@"ClothLine"]) {
        return DHObjectAnimationTypeClothLine;
    }
    return DHObjectAnimationTypeNone;
}

#pragma mark - Animations
+ (NSArray *) transitions
{
    if (!transitions) {
        transitions = @[@""];
    }
    return transitions;
}

+ (NSArray *) builtInAnimations
{
    if (!builtInAnimations) {
        builtInAnimations = @[@"ClothLine"];
    }
    return builtInAnimations;
}

+ (NSArray *) builtOutAnimations
{
    if (!builtOutAnimations) {
        builtOutAnimations = @[@"ClothLine"];
    }
    return builtOutAnimations;
}

+ (NSArray *) textAnimations
{
    if (!textAnimations) {
        textAnimations = @[];
    }
    return textAnimations;
}

+ (DHAnimation *) animationOfType:(DHObjectAnimationType)animationType event:(DHAnimationEvent)event forTarget:(UIView *)target animationView:(GLKView *)animationView
{
    DHAnimation *animation;
    
    DHAnimationSettings *settings = [DHAnimationSettings defaultSettingsForAnimationType:animationType event:event triggerEvent:DHAnimationTriggerEventByTap forTarget:target animationView:animationView];
    
    switch (animationType) {
        case DHObjectAnimationTypeClothLine:
            animation = [[DHObjectClothLineAnimation alloc] init];
            [animation setupWithSettings:settings];
            break;
            
        default:
            break;
    }
    
    return animation;
}
@end
