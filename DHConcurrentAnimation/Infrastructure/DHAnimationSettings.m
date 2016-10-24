//
//  DHAnimationSettings.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationSettings.h"


@implementation DHAnimationSettings

+ (DHAnimationSettings *) defaultSettingsForAnimationType:(DHObjectAnimationType)type event:(DHAnimationEvent)event
{
    return [DHAnimationSettings defaultSettingsForAnimationType:type event:event triggerEvent:DHAnimationTriggerEventByTap forTarget:nil animationView:nil];
}

+ (DHAnimationSettings *) defaultSettingsForAnimationType:(DHObjectAnimationType)type
                                                    event:(DHAnimationEvent)event
                                             triggerEvent:(DHAnimationTriggerEvent)triggerEvent
                                                forTarget:(UIView *)target
                                            animationView:(GLKView *)animationView
{
    DHAnimationSettings *settings = [[DHAnimationSettings alloc] init];
    settings.event = event;
    settings.targetView = target;
    settings.animationView = animationView;
    settings.triggerEvent = triggerEvent;
    settings.direction = DHAnimationDirectionLeftToRight;
    settings.triggerTime = 2.f;
    [DHAnimationSettings updateRotateTextureForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateColumnCountRowCountForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateTimingFunctionForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateDurationForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateStartTimeForSettings:settings];
    if (event == DHAnimationEventBuiltIn) {
        __weak DHAnimationSettings *weakSettings = settings;
        settings.completion = ^(BOOL finished){
            [weakSettings.animationView addSubview:weakSettings.targetView];
        };
    }
    return settings;
}

+ (void) updateColumnCountRowCountForSettings:(DHAnimationSettings *)settings
                             forAnimationType:(DHObjectAnimationType)type
{
    switch (type) {
        case DHObjectAnimationTypeFold:
        case DHObjectAnimationTypeBlinds:{
            settings.columnCount = 3;
            settings.rowCount = 3;
            break;
        }
        case DHObjectAnimationTypeConfetti: {
            settings.columnCount = 25;
            settings.rowCount = 25;
            break;
        }
        case DHObjectAnimationTypeShredder: {
            settings.columnCount = 10;
            settings.duration = 3.5;
            break;
        }
        default: {
            settings.columnCount = 1;
            settings.rowCount =1 ;
        }
            break;
    }
}

+ (void) updateTimingFunctionForSettings:(DHAnimationSettings *)settings
                        forAnimationType:(DHObjectAnimationType)type
{
    if (settings.event == DHAnimationEventBuiltIn) {
        switch (type) {
            case DHObjectAnimationTypeScale:
            case DHObjectAnimationTypeScaleBig:
            case DHObjectAnimationTypeRotate:
                settings.timingFunction = NSBKeyframeAnimationFunctionEaseOutBack;
                break;
            case DHObjectAnimationTypeDrop:
                settings.timingFunction = NSBKeyframeAnimationFunctionEaseOutBounce;
                break;
            case DHObjectAnimationTypeBlinds:
                settings.timingFunction = NSBKeyframeAnimationFunctionEaseOutBack;
                break;
            default:
                settings.timingFunction = NSBKeyframeAnimationFunctionLinear;
                break;
        }
    } else {
        switch (type) {
            case DHObjectAnimationTypeScale:
            case DHObjectAnimationTypeScaleBig:
            case DHObjectAnimationTypeRotate:
                settings.timingFunction = NSBKeyframeAnimationFunctionEaseInCubic;
                break;
            case DHObjectAnimationTypeBlinds:
                settings.timingFunction = NSBKeyframeAnimationFunctionEaseInBack;
                break;
            case DHObjectAnimationTypeCompress:
                settings.timingFunction = NSBKeyframeAnimationFunctionEaseOutCubic;
                break;
            default:
                settings.timingFunction = NSBKeyframeAnimationFunctionLinear;
                break;
        }
    }
}

+ (void) updateDurationForSettings:(DHAnimationSettings *)settings
                  forAnimationType:(DHObjectAnimationType)type
{
    switch (type) {
        default:
            settings.duration = 2.f;
            break;
    }
}

+ (void) updateStartTimeForSettings:(DHAnimationSettings *)settings
{
    switch (settings.triggerEvent) {
        case DHAnimationTriggerEventStartSimutanously:
        case DHAnimationTriggerEventByTap:
            settings.startTime = 0.f;
            break;
        case DHAnimationTriggerEventByTime:
            settings.startTime = 2.f;
        default:
            break;
    }
}

+ (void) updateRotateTextureForSettings:(DHAnimationSettings *)settings forAnimationType:(DHObjectAnimationType) animationType
{
    switch (animationType) {
        case DHObjectAnimationTypeConfetti:
            settings.rotateTexture = NO;
            break;
            
        default:
            settings.rotateTexture = YES;
            break;
    }
}
@end
