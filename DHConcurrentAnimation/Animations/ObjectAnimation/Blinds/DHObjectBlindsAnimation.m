//
//  DHObjectBlindsAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/13.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectBlindsAnimation.h"
#import "DHAnimationSimpleSceneMesh.h"
@interface DHObjectBlindsAnimation() {
    GLuint columnWidthLoc, columnHeightLoc;
}
@property (nonatomic) GLfloat columnWidth;
@property (nonatomic) GLfloat columnHeight;
@end

@implementation DHObjectBlindsAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectBlindsVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectBlindsFragment.glsl";
}

- (void) setupExtraUniforms
{
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    columnHeightLoc = glGetUniformLocation(program, "u_columnHeight");
    self.columnWidth = self.settings.targetView.frame.size.width / self.settings.columnCount;
    self.columnHeight = self.settings.targetView.frame.size.height / self.settings.rowCount;
}

- (void) setupMeshes
{
    BOOL columnMajored = YES;
    NSInteger columnCount = self.settings.columnCount;
    NSInteger rowCount = self.settings.rowCount;
    if (self.settings.direction == DHAnimationDirectionBottomToTop || self.settings.direction == DHAnimationDirectionTopToBottom) {
        columnMajored = NO;
        columnCount = 1;
    } else {
        rowCount = 1;
    }
    self.mesh = [[DHAnimationSimpleSceneMesh alloc] initWithTarget:self.settings.targetView size:self.targetSize origin:self.targetOrigin columnCount:columnCount rowCount:rowCount columnMajored:columnMajored rotate:NO];
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
