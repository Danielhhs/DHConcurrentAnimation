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
#import "DHObjectFoldAnimation.h"
#import "DHObjectScaleAnimation.h"
#import "DHObjectScaleBigAnimation.h"
#import "DHObjectDropAnimation.h"
#import "DHObjectBlindsAnimation.h"
#import "DHObjectRotateAnimation.h"
#import "DHObjectConfettiAnimation.h"
#import "DHObjectShredderAnimation.h"
#import "DHObjectCompressAnimation.h"
#import "DHObjectShimmerAnimation.h"
#import "DHObjectSparkleAnimation.h"

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
    } else if ([animationName isEqualToString:@"Fold"]) {
        return DHObjectAnimationTypeFold;
    } else if ([animationName isEqualToString:@"Scale"]) {
        return DHObjectAnimationTypeScale;
    } else if ([animationName isEqualToString:@"Scale Big"]) {
        return DHObjectAnimationTypeScaleBig;
    } else if ([animationName isEqualToString:@"Drop"]) {
        return DHObjectAnimationTypeDrop;
    } else if ([animationName isEqualToString:@"Blinds"]) {
        return DHObjectAnimationTypeBlinds;
    } else if ([animationName isEqualToString:@"Rotate"]) {
        return DHObjectAnimationTypeRotate;
    } else if ([animationName isEqualToString:@"Confetti"]) {
        return DHObjectAnimationTypeConfetti;
    } else if ([animationName isEqualToString:@"Shredder"]) {
        return DHObjectAnimationTypeShredder;
    } else if ([animationName isEqualToString:@"Compress"]) {
        return DHObjectAnimationTypeCompress;
    } else if ([animationName isEqualToString:@"Shimmer"]) {
        return DHObjectAnimationTypeShimmer;
    } else if ([animationName isEqualToString:@"Sparkle"]) {
        return DHObjectAnimationTypeSparkle;
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
        builtInAnimations = @[@"ClothLine", @"Fold", @"Scale", @"Scale Big", @"Drop", @"Blinds", @"Rotate", @"Confetti", @"Shimmer", @"Sparkle"];
    }
    return builtInAnimations;
}

+ (NSArray *) builtOutAnimations
{
    if (!builtOutAnimations) {
        builtOutAnimations = @[@"ClothLine", @"Fold", @"Scale", @"Scale Big", @"Blinds", @"Rotate", @"Confetti", @"Shredder", @"Compress", @"Shimmer", @"Sparkle"];
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

+ (DHAnimation *) animationOfName:(NSString *)animationName event:(DHAnimationEvent)event
{
    DHObjectAnimationType animationType = [DHAnimationFactory animationTypeForName:animationName];
    return [DHAnimationFactory animationOfType:animationType event:event];
}

+ (DHAnimation *) animationOfType:(DHObjectAnimationType)type event:(DHAnimationEvent)event
{
    return [DHAnimationFactory animationOfType:type event:event forTarget:nil animationView:nil];
}

+ (DHAnimation *) animationOfType:(DHObjectAnimationType)animationType event:(DHAnimationEvent)event forTarget:(UIView *)target animationView:(GLKView *)animationView
{
    return [DHAnimationFactory animationOfType:animationType event:event forTarget:target animationView:animationView settings:nil];
}

+ (DHAnimation *) animationOfType:(DHObjectAnimationType)type event:(DHAnimationEvent)event forTarget:(UIView *)target animationView:(GLKView *)animationView settings:(DHAnimationSettings *)settings
{
    if (settings == nil) {
        settings = [DHAnimationSettings defaultSettingsForAnimationType:type event:event triggerEvent:DHAnimationTriggerEventByTap forTarget:target animationView:animationView];
    }
    DHAnimation *animation;
    
    
    switch (type) {
        case DHObjectAnimationTypeClothLine:
            animation = [[DHObjectClothLineAnimation alloc] init];
            break;
        case DHObjectAnimationTypeFold: {
            DHObjectFoldAnimation *fold = [[DHObjectFoldAnimation alloc] init];
            fold.headerLength = 64;
            animation = fold;
            break;
        }
        case DHObjectAnimationTypeScale: {
            animation = [[DHObjectScaleAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeScaleBig: {
            animation = [[DHObjectScaleBigAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeDrop: {
            animation = [[DHObjectDropAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeBlinds: {
            animation = [[DHObjectBlindsAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeRotate: {
            animation = [[DHObjectRotateAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeConfetti: {
            animation = [[DHObjectConfettiAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeShredder: {
            animation = [[DHObjectShredderAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeCompress: {
            animation = [[DHObjectCompressAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeShimmer: {
            animation = [[DHObjectShimmerAnimation alloc] init];
            break;
        }
        case DHObjectAnimationTypeSparkle: {
            animation = [[DHObjectSparkleAnimation alloc] init];
            break;
        }
        default:
            break;
    }
    animation.settings = settings;
    animation.animationType = type;
    return animation;
}
@end
