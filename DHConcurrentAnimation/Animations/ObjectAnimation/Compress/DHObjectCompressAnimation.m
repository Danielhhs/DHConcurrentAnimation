//
//  DHCompressAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/24.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectCompressAnimation.h"

@interface DHObjectCompressAnimation () {
    GLuint showRangeLoc;
}

@end

@implementation DHObjectCompressAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectCompressVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectCompressFragment.glsl";
}

- (void) setupExtraUniforms
{
    showRangeLoc = glGetUniformLocation(program, "u_showRange");
}

- (void) drawFrame
{
    
    GLfloat center = self.settings.animationView.frame.size.height - CGRectGetMidY(self.settings.targetView.frame);
    GLfloat lowerBounds = (center - (1.f - self.percent) * self.settings.targetView.frame.size.height / 2 * 2) * 2;
    GLfloat upperBounds = (center + (1.f - self.percent) * self.settings.targetView.frame.size.height / 2 * 2) * 2;
    glUniform2f(showRangeLoc, lowerBounds, upperBounds);
    
    [self.mesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}
@end
