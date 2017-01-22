//
//  DHAnvilAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/12/5.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHAnvilAnimation.h"
#import "DHAnvilDustEffect.h"

@interface DHAnvilAnimation ()
@property (nonatomic, strong) DHAnvilDustEffect *effect;
@end

@implementation DHAnvilAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectAnvilVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectAnvilFragment.glsl";
}

- (void) setupEffects
{
    DHAnvilDustEffect *effect = [[DHAnvilDustEffect alloc] initWithContext:self.context];
    effect.dustWidth = self.settings.targetView.frame.size.width;
    effect.mvpMatrix = self.mvpMatrix;
    effect.startTime = self.settings.duration * 0.3;

    effect.targetView = self.settings.targetView;
    effect.duration = self.settings.duration;
    effect.emissionRadius = self.settings.targetView.frame.size.width * 2;
    [effect generateParticleData];
    
    self.effect = effect;
}

- (void) drawFrame
{
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    [self.effect draw];
}

@end
