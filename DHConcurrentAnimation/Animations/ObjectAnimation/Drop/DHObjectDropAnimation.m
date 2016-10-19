//
//  DHObjectDropAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/12.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectDropAnimation.h"
@interface DHObjectDropAnimation() {
    GLuint offsetLoc;
}
@property (nonatomic) GLfloat offset;
@end

@implementation DHObjectDropAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectDropVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectDropFragment.glsl";
}

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    self.offset = self.settings.animationView.frame.size.height - self.targetOrigin.y;
}

- (void) drawFrame
{
    glUniform1f(offsetLoc, self.offset);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
