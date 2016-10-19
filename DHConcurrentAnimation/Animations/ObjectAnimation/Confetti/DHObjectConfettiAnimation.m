//
//  DHObjectConfettiAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/17.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectConfettiAnimation.h"
#import "DHObjectConfettiSceneMesh.h"
#import "DHTextureLoader.h"

@interface DHObjectConfettiAnimation () {
    GLuint columnWidthLoc, columnHeightLoc;
}
@property (nonatomic) CGFloat columnWidth;
@property (nonatomic) CGFloat columnHeight;
@end

@implementation DHObjectConfettiAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectConfettiVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectConfettiFragment.glsl";
}

- (void) setupExtraUniforms
{
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    columnHeightLoc = glGetUniformLocation(program, "u_columnHeight");
    self.columnWidth = self.settings.targetView.bounds.size.width / self.settings.columnCount;
    self.columnHeight = self.settings.targetView.bounds.size.height / self.settings.rowCount;
}

- (void) setupMeshes
{
    self.mesh = [[DHObjectConfettiSceneMesh alloc] initWithTarget:self.settings.targetView size:self.targetSize origin:self.targetOrigin columnCount:self.settings.columnCount rowCount:self.settings.rowCount columnMajored:YES rotate:NO];
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    glUniform1f(columnWidthLoc, self.columnWidth);
    glUniform1f(columnHeightLoc, self.columnHeight);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
