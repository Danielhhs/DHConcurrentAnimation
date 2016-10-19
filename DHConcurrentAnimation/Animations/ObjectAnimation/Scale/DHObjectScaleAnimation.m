//
//  DHObjectScaleAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/11.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectScaleAnimation.h"

@interface DHObjectScaleAnimation () {
    GLuint centerLoc;
}
@property (nonatomic) CGPoint center;
@end

@implementation DHObjectScaleAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectScaleVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectScaleFragment.glsl";
}

- (void) setupExtraUniforms
{
    centerLoc = glGetUniformLocation(program, "u_center");
    self.center = CGPointMake(self.targetOrigin.x + self.targetSize.width / 2, self.targetOrigin.y + self.targetSize.height / 2);
}

- (void) drawFrame
{
    GLfloat percent = self.percent;
    if (self.settings.event == DHAnimationEventBuiltOut) {
        percent = 1.f - percent;
    }
    glUniform1f(percentLoc, percent);
    glUniform2f(centerLoc, self.center.x, self.center.y);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}
@end
