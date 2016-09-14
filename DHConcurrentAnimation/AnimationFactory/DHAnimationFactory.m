//
//  DHAnimationFactory.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationFactory.h"

static NSArray *transitions;
static NSArray *builtInAnimations;
static NSArray *builtOutAnimations;
static NSArray *textAnimations;

@implementation DHAnimationFactory

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

@end
