//
//  DHObjectRotateAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/13.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectRotateAnimation.h"

@interface DHObjectRotateAnimation () {
    GLuint targetCenterLoc, rotationRadiusLoc, targetWidthLoc;
}
@property (nonatomic) GLKVector2 targetCenter;
@end

@implementation DHObjectRotateAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectRotateVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectRotateFragment.glsl";
}

- (void) setupExtraUniforms
{
    targetCenterLoc = glGetUniformLocation(program, "u_targetCenter");
    targetWidthLoc = glGetUniformLocation(program, "u_targetWidth");
    rotationRadiusLoc = glGetUniformLocation(program, "u_rotationRadius");
    self.targetCenter = GLKVector2Make(self.targetOrigin.x + self.targetSize.width / 2, self.targetOrigin.y + self.targetSize.height / 2);
}

- (void) drawFrame
{
    glUniform2f(targetCenterLoc, self.targetCenter.x, self.targetCenter.y);
    glUniform1f(targetWidthLoc, self.settings.targetView.frame.size.width);
    glUniform1f(rotationRadiusLoc, 2 * self.settings.targetView.frame.size.width);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
