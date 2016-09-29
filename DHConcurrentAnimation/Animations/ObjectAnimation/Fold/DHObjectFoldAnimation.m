//
//  DHObjectFoldAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectFoldAnimation.h"
#import "DHObjectFoldSceneMesh.h"

@interface DHObjectFoldAnimation () {
    GLuint columnWidthLoc, headerHeightLoc, originLoc;
}

@end

@implementation DHObjectFoldAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectFoldVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectFoldFragment.glsl";
}

- (void) setupUniforms
{
    [super setupUniforms];
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    headerHeightLoc = glGetUniformLocation(program, "u_headerHeight");
    originLoc = glGetUniformLocation(program, "u_origin");
}

- (void) setupMeshes
{
    DHObjectFoldSceneMesh *mesh = [[DHObjectFoldSceneMesh alloc] initWithTargetSize:self.targetSize origin:self.targetOrigin columnCount:self.settings.columnCount rowCount:self.settings.rowCount columnMajored:YES rotate:NO];
    mesh.direction = self.settings.direction;
    mesh.headerHeight = self.headerLength;
    [mesh generateMeshesData];
    self.mesh = mesh;
}

- (void) drawFrame
{
    if (self.settings.event == DHAnimationEventBuiltIn) {
        glUniform1f(percentLoc, 1.f - self.percent);
    }
    glUniform1f(columnWidthLoc, [self columnWidth]);
    glUniform1f(headerHeightLoc, self.headerLength);
    glUniform2f(originLoc, [self originPosition].x, [self originPosition].y);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (GLKVector2)originPosition
{
    if (self.settings.direction == DHAnimationDirectionLeftToRight) {
        return GLKVector2Make(self.targetOrigin.x + self.targetSize.width, self.targetOrigin.y);
    } else if (self.settings.direction == DHAnimationDirectionRightToLeft) {
        return GLKVector2Make(self.targetOrigin.x, self.targetOrigin.y);
    } else if (self.settings.direction == DHAnimationDirectionTopToBottom) {
        return GLKVector2Make(self.targetOrigin.x, self.targetOrigin.y);
    } else {
        return GLKVector2Make(self.targetOrigin.x, self.targetOrigin.y + self.targetSize.height);
    }
}

- (GLfloat) columnWidth
{
    if (self.settings.direction == DHAnimationDirectionLeftToRight || self.settings.direction == DHAnimationDirectionRightToLeft) {
        return (self.targetSize.width - self.headerLength) / self.settings.columnCount;
    } else {
        return (self.targetSize.height - self.headerLength) / self.settings.rowCount;
    }
}

- (NSString *) description
{
    return @"Fold";
}
@end
