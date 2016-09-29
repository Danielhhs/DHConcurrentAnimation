//
//  DHAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimation.h"
#import "DHProgramLoader.h"
#import "DHTextureLoader.h"
#import "DHAnimationSettings.h"

@interface DHAnimation ()
@property (nonatomic, readwrite) BOOL readyToAnimate;
@end

@implementation DHAnimation

- (void) setup
{
    self.context = self.settings.animationView.context;
    [self setUpTargetGeometry];
    [self setupGL];
    [self setupMeshes];
    [self setupTexture];
    self.readyToAnimate = YES;
    [self.delegate animationDidFinishSettingUp:self];
}

- (void) setUpTargetGeometry
{
    self.targetOrigin = CGPointMake(self.settings.targetView.frame.origin.x, self.settings.animationView.bounds.size.height - CGRectGetMaxY(self.settings.targetView.frame));
    if (self.settings.rotateTexture == YES) {
        self.targetSize = self.settings.targetView.bounds.size;
    } else {
        self.targetSize = self.settings.targetView.frame.size;
    }
}

- (void) setupGL
{
    [EAGLContext setCurrentContext:self.context];
    program = [DHProgramLoader loadProgramWithVertexShader:[self vertexShaderName] fragmentShader:[self fragmentShaderName]];
    [self setupUniforms];
}

- (void) setupUniforms
{
    glUseProgram(program);
    mvpLoc = glGetUniformLocation(program, "u_mvpMatrix");
    samplerLoc = glGetUniformLocation(program, "s_tex");
    durationLoc = glGetUniformLocation(program, "u_duration");
    timeLoc = glGetUniformLocation(program, "u_time");
    directionLoc = glGetUniformLocation(program, "u_direction");
    eventLoc = glGetUniformLocation(program, "u_event");
    percentLoc = glGetUniformLocation(program, "u_percent");
}

- (void) setupMeshes
{
    
}

- (void) setupTexture
{
    texture = [DHTextureLoader loadTextureWithView:self.settings.targetView];
}

- (void) start {
    self.elapsedTime = 0.f;
    self.percent = 0.f;
}

- (void) stop
{
    [self.delegate animationDidStop:self];
}

- (void) draw
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(durationLoc, self.settings.duration);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1i(directionLoc, self.settings.direction);
    glUniform1i(eventLoc, self.settings.event);
    glUniform1f(percentLoc, self.percent);
    [self drawFrame];
}

- (NSString *) vertexShaderName
{
    return nil;
}

- (NSString *) fragmentShaderName
{
    return nil;
}

- (void) drawFrame
{
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval
{
    self.elapsedTime += timeInterval;
    self.percent = self.settings.timingFunction(self.elapsedTime * 1000.f, 0.f, 1.f, self.settings.duration * 1000.f);
    if (self.elapsedTime - self.settings.startTime > self.settings.duration) {
        self.percent = 1.f;
        if (self.settings.completion) {
            self.settings.completion(YES);
        }
        [self stop];
    }
}
@end
