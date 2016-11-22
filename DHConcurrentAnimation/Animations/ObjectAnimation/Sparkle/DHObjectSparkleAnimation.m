//
//  DHObjectSparkleAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/11/17.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectSparkleAnimation.h"
#import "DHSparkleEffect.h"

#define SPARKLE_LIFE_TIME_RATIO 0.2
@interface DHObjectSparkleAnimation () {
    GLuint xRangeLoc;
}
@property (nonatomic, strong) DHSparkleEffect *sparkleEffect;
@end

@implementation DHObjectSparkleAnimation

- (void) setupExtraUniforms
{
    xRangeLoc = glGetUniformLocation(program, "u_targetXPositionRange");
}

- (NSString *) vertexShaderName
{
    return @"ObjectSparkleVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectSparkleFragment.glsl";
}

- (void) setupEffects
{
    self.sparkleEffect = [[DHSparkleEffect alloc] initWithContext:self.context];
    self.sparkleEffect.targetView = self.settings.targetView;
    self.sparkleEffect.containerView = self.settings.animationView;
    self.sparkleEffect.rowCount = self.settings.rowCount;
    self.sparkleEffect.columnCount = self.settings.columnCount;
    self.sparkleEffect.mvpMatrix = self.mvpMatrix;
    self.sparkleEffect.rowCount = 7;
    self.sparkleEffect.duration = self.settings.duration;
    self.sparkleEffect.direction = self.settings.direction;
    [self.sparkleEffect generateParticleData];
}

- (void) drawFrame
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform2f(xRangeLoc, self.settings.targetView.frame.origin.x * [UIScreen mainScreen].scale, CGRectGetMaxX(self.settings.targetView.frame) * [UIScreen mainScreen].scale);
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(percentLoc, self.percent / (1 - SPARKLE_LIFE_TIME_RATIO / 2));
    glUniform1i(samplerLoc, 0);
    glUniform1f(directionLoc, self.settings.direction);
    glUniform1f(eventLoc, self.settings.event);
    [self.mesh drawEntireMesh];
    
    [self.sparkleEffect prepareToDraw];
    [self.sparkleEffect draw];
}

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval
{
    self.elapsedTime += timeInterval;
    self.percent = self.settings.timingFunction(self.elapsedTime * 1000.f, 0.f, 1.f, self.settings.duration * 1000.f);
    [self updateAdditionalComponents];
    if (self.elapsedTime - self.settings.startTime > self.settings.duration) {
        self.percent = 1.f;
        if (self.settings.completion) {
            self.settings.completion(YES);
        }
        [self stop];
    }
}

- (void) updateAdditionalComponents
{
    [self.sparkleEffect updateWithElapsedTime:self.elapsedTime percent:self.percent];
}
@end
