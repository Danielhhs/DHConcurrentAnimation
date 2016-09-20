//
//  DHAnimationSettings.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "NSBKeyframeAnimationFunctions.h"
#import "DHAnimationEnums.h"

@interface DHAnimationSettings : NSObject

@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) GLKView *animationView;

@property (nonatomic, strong) void(^completion)(BOOL);
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;
//Setting this property to YES will not rotate the position of the vertex, while the textureCoords will be rotated;
//Setting thie property to NO will rotate the position of the vertex, while the textureCoords is a normal texture;
@property (nonatomic) BOOL rotateTexture;
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHAnimationTriggerEvent triggerEvent;

+ (DHAnimationSettings *) defaultSettingsForAnimationType:(DHObjectAnimationType)type
                                                    event:(DHAnimationEvent)event
                                             triggerEvent:(DHAnimationTriggerEvent)triggerEvent
                                                forTarget:(UIView *)target
                                            animationView:(GLKView *)animationView;
@end
