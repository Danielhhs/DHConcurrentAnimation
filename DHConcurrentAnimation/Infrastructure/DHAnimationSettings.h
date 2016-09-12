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

@property (nonatomic, weak) GLKView *animationView;

@property (nonatomic, strong) void(^completion)(BOOL);
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic) DHAnimationDirection direction;
@property (nonatomic) DHAnimationEvent event;

@end
