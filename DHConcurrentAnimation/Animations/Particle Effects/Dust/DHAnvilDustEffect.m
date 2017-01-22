//
//  DHAnvilDustEffect.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/12/5.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHAnvilDustEffect.h"

@implementation DHAnvilDustEffect

- (NSString *) vertexShaderName
{
    return @"ParticleAnvilDustVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ParticleAnvilDustFragment.glsl";
}

- (void) generateParticleData
{
    self.particleData = [NSMutableData data];
    GLfloat v = 1.f / self.targetView.frame.size.width;
    GLfloat vAngle = v * M_PI - M_PI / 2;
    for (int i = 0; i < self.targetView.frame.size.width; i++) {
        GLfloat x = sin(vAngle);
        GLfloat z = cos(vAngle);
        for (int j = 0; j < 30; j++) {
            GLfloat percent = j / 30.f;
            GLfloat radius = percent * self.emissionRadius;
            DHDustEffectAttributes particle;
            particle.startPosition = self.emitPosition;
            GLfloat y = percent * self.targetView.frame.size.height / 2 + arc4random() % (int)(self.targetView.frame.size.height / 3);
            particle.targetPosition = GLKVector3Make(x * radius, y, z * radius);
            particle.startPointSize = 5.f;
            particle.targetPointSize = percent * 20 + arc4random() % 10;
            particle.aLifeTime = self.duration - self.startTime;
            particle.rotation = percent * M_PI * 2;
            [self.particleData appendBytes:&particle length:sizeof(particle)];
        }
    }
}

@end
