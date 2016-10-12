//
//  DHObjectScaleBigAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/12.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectScaleBigAnimation.h"
@interface DHObjectScaleBigAnimation () {
    GLuint centerLoc;
}
@property (nonatomic) CGPoint center;
@end

@implementation DHObjectScaleBigAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectScaleBigVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectScaleBigFragment.glsl";
}

- (void) setupUniforms
{
    [super setupUniforms];
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
