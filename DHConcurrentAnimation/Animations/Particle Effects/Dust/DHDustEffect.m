//
//  DHDustEffect.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/11/22.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHDustEffect.h"
#import <OpenGLES/ES3/glext.h>
#import "NSBKeyframeAnimationFunctions.h"


#define PARTICLE_COUNT 200
#define MAX_PARTICLE_SIZE 1000

@interface DHDustEffect ()
@property (nonatomic) GLfloat maxHeight;
@property (nonatomic) GLKVector3 emissionDirection;
@property (nonatomic) NSInteger numberOfParticles;
@end

@implementation DHDustEffect

- (NSString *) vertexShaderName
{
    return @"ParticleDustVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ParticleDustFragment.glsl";
}

- (NSString *) particleImageName
{
    return @"dust.png";
}

#pragma mark - Generate Particle Data
- (void) generateParticleData
{
    self.particleData = [NSMutableData data];
    self.maxHeight = self.targetView.frame.size.height;
    [self generateParticleDataForSingleDirection];
    [self prepareToDraw];
}

- (void) generateParticleDataForSingleDirection
{
    self.numberOfParticles = PARTICLE_COUNT;
    if (self.direction == DHDustEffectDirectionRightToLeft) {
        self.emissionDirection = GLKVector3Make(-1, 0, 0);
    } else if (self.direction == DHDustEffectDirectionLeftToRight) {
        self.emissionDirection = GLKVector3Make(1, 0, 0);
    }
    for (int i = 0; i < self.numberOfParticles; i++) {
        DHDustEffectAttributes dust;
        dust.startPosition = self.emitPosition;
        dust.startPointSize = 5.f;
        dust.targetPosition = [self randomTargetPositionForSingleDirectionForEmissionPosition:self.emitPosition];
        dust.targetPointSize = [self targetPointSizeForYPosition:dust.targetPosition.y - self.emitPosition.y originalSize:dust.startPointSize];
        dust.rotation = [self randomPercent] * M_PI * 4;
        [self.particleData appendBytes:&dust length:sizeof(dust)];
    }

}

- (GLKVector3) randomTargetPositionForSingleDirectionForEmissionPosition:(GLKVector3)emissionPosition
{
    GLKVector3 position;
    GLfloat xDirection = self.emissionDirection.x > 0 ? 1 : -1;
    position.x = emissionPosition.x + [self randomPercent] * self.dustWidth * xDirection;
    position.y = emissionPosition.y + [self randomPercent] * [self maxYForX:position.x - emissionPosition.x];
    position.z = emissionPosition.z + [self randomPercent] * self.emissionRadius * self.emissionDirection.z;
    return position;
}

- (GLfloat) maxYForX:(GLfloat)x
{
    float y = sqrt(self.emissionRadius * self.emissionRadius - x * x);
    y = self.emissionRadius - y;
    return y;
}

- (GLfloat) maxZForX:(GLfloat)x y:(GLfloat)y
{
    float z;
    if (x * x + y * y > self.emissionRadius * self.emissionRadius) {
        z =  0;
    } else {
        z = sqrt(self.emissionRadius * self.emissionRadius - x * x - y * y);
    }
    return z;
}

- (GLfloat) targetPointSizeForYPosition:(GLfloat)yPosition originalSize:(GLfloat)originalSize
{
    GLfloat maxYPosition = sqrt(self.emissionRadius * self.emissionRadius - self.dustWidth * self.dustWidth);
    return yPosition / maxYPosition * MAX_PARTICLE_SIZE + originalSize;
}

- (GLfloat) randomPercent
{
    return arc4random() % 100 / 100.f;
}

#pragma mark - Drawing
- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.particleData length] != 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.particleData length], [self.particleData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
        glBindVertexArray(vertexArray);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, startPosition));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, targetPosition));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, startPointSize));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, targetPointSize));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, rotation));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_FLOAT, GL_FALSE, sizeof(DHDustEffectAttributes), NULL + offsetof(DHDustEffectAttributes, aLifeTime));
    
    glBindVertexArray(0);
    
}

- (void) draw
{
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(percentLoc, self.percent);
    glUniform1f(elapsedTimeLoc, self.elapsedTime);
    
    glBindVertexArray(vertexArray);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    glDrawArrays(GL_POINTS, 0, (GLint)[self numberOfParticles]);
    
    glBindVertexArray(0);
}

- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent
{
    self.elapsedTime = elapsedTime - self.startTime;
    if (self.elapsedTime <= 0) {
        self.percent = 0.f;
    } else {
        self.percent = NSBKeyframeAnimationFunctionEaseOutExpo(self.elapsedTime * 1000, 0, 1, (self.duration - self.startTime) * 1000);
    }
}

@end
