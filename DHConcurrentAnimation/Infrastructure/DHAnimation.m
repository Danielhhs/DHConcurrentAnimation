//
//  DHAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimation.h"

@interface DHAnimation () {
    GLuint program;
    GLuint texture;
    GLuint mvpLoc, samplerLoc, timeLoc, durationLoc, directionLoc, eventLoc;
}

@end

@implementation DHAnimation

- (void) setupWithSettings:(DHAnimationSettings *)settings
{
    self.settings = settings;
    [self setupGL];
    [self setupMeshes];
    [self setupTexture];
}

- (void) setupGL
{
    
}

- (void) setupMeshes
{
    
}

- (void) setupTexture
{
    
}

- (void) start {
    
}

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval
{
    
}

@end
