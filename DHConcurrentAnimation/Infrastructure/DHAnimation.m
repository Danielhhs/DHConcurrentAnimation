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
#import "DHAnimationSimpleSceneMesh.h"

@interface DHAnimation ()
@property (nonatomic, readwrite) BOOL readyToAnimate;
@property (nonatomic) BOOL displayed;
@end

@implementation DHAnimation

- (void) setup
{
    self.context = self.settings.animationView.context;
    [self setUpTargetGeometry];
    [self setupGL];
    [self setupMeshes];
    self.readyToAnimate = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupTexture];
        [self.delegate animationDidFinishSettingUp:self];
    });
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
    self.mesh = [[DHAnimationSimpleSceneMesh alloc] initWithTargetSize:self.targetSize origin:self.targetOrigin columnCount:1 rowCount:1 columnMajored:YES rotate:NO];
    [self.mesh generateMeshesData];
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
    [self tearDown];
}

- (void) draw
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(durationLoc, self.settings.duration);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(directionLoc, self.settings.direction);
    glUniform1f(eventLoc, self.settings.event);
    glUniform1f(percentLoc, self.percent);
    [self drawFrame];
    if (self.displayed == NO) {
        if (self.settings.event == DHAnimationEventBuiltOut) {
            [self.settings.targetView removeFromSuperview];
        }
        self.displayed = YES;
    }
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

- (void) tearDown
{
    [EAGLContext setCurrentContext:self.context];
    [self tearDownMeshes];
    [self tearDownTextures];
    [self tearDownPrograms];
    [self tearDownExtraGLResource];
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
}

- (void) tearDownMeshes
{
    [self.mesh tearDown];
}

- (void) tearDownTextures
{
    if (texture) {
        glDeleteTextures(1, &texture);
        texture = 0;
    }
}

- (void) tearDownPrograms
{
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
}

- (void) tearDownExtraGLResource
{
    
}
@end
