//
//  DHSkidAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/11/29.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectSkidAnimation.h"
#import "DHDustEffect.h"

@interface DHObjectSkidAnimation (){
    GLuint offsetLoc, centerLoc, resolutionLoc, slidingTimeLoc;
}
@property (nonatomic, strong) DHDustEffect *effect;
@property (nonatomic) GLfloat offset;

@end

#define SLIDING_TIME_RATIO 0.3

@implementation DHObjectSkidAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectSkidVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectSkidFragment.glsl";
}

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    centerLoc = glGetUniformLocation(program, "u_center");
    resolutionLoc = glGetUniformLocation(program, "u_resolution");
    slidingTimeLoc = glGetUniformLocation(program, "u_slidingTime");
    if (self.settings.direction == DHAnimationDirectionLeftToRight) {
        self.offset = CGRectGetMaxX(self.settings.targetView.frame);
    } else {
        self.offset = self.settings.animationView.frame.size.width - CGRectGetMinX(self.settings.targetView.frame);
    }
}

- (void) setupEffects
{
    self.effect = [[DHDustEffect alloc] initWithContext:self.context];
    if (self.settings.direction == DHAnimationDirectionLeftToRight) {
        self.effect.direction = DHDustEffectDirectionLeftToRight;
        self.effect.emitPosition = GLKVector3Make(CGRectGetMaxX(self.settings.targetView.frame), self.settings.animationView.frame.size.height - CGRectGetMaxY(self.settings.targetView.frame), self.settings.targetView.frame.size.height / 2);
    } else {
        self.effect.direction = DHDustEffectDirectionRightToLeft;
        self.effect.emitPosition = GLKVector3Make(CGRectGetMinX(self.settings.targetView.frame), self.settings.animationView.frame.size.height - CGRectGetMaxY(self.settings.targetView.frame), self.settings.targetView.frame.size.height / 2);
    }
    self.effect.dustWidth = self.settings.targetView.frame.size.width;
    self.effect.mvpMatrix = self.mvpMatrix;
    if (self.settings.event == DHAnimationEventBuiltIn) {
        self.effect.startTime = self.settings.duration * SLIDING_TIME_RATIO;
    } else {
        self.effect.startTime = 0.f;
    }
    self.effect.targetView = self.settings.targetView;
    self.effect.duration = self.settings.duration;
    self.effect.emissionRadius = self.settings.targetView.frame.size.width * 2;
    [self.effect generateParticleData];
}

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval
{
    [super updateWithTimeInterval:timeInterval];
    [self.effect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glUniform2f(centerLoc, CGRectGetMidX(self.settings.targetView.frame), self.settings.animationView.frame.size.height - CGRectGetMidY(self.settings.targetView.frame));
    glUniform2f(resolutionLoc, self.settings.targetView.frame.size.width, self.settings.targetView.frame.size.height);
    glUniform1f(slidingTimeLoc, SLIDING_TIME_RATIO);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    [self.effect draw];
}
@end
