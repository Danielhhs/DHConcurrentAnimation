//
//  DHAnimationSettings.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationSettings.h"


@implementation DHAnimationSettings

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
    settings.direction = DHAnimationDirectionRightToLeft;
    [DHAnimationSettings updateColumnCountRowCountForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateTimingFunctionForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateDurationForSettings:settings forAnimationType:type];
    [DHAnimationSettings updateStartTimeForSettings:settings];
    return settings;
}

+ (void) updateColumnCountRowCountForSettings:(DHAnimationSettings *)settings
                             forAnimationType:(DHObjectAnimationType)type
{
    switch (type) {
            
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
            default:
                settings.timingFunction = NSBKeyframeAnimationFunctionLinear;
                break;
        }
    } else {
        switch (type) {
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
        case DHObjectAnimationTypeClothLine:
            settings.duration = 2.f;
            break;
            
        default:
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
@end
