//
//  DHObjectClothLineAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectClothLineAnimation.h"
#import "DHObjectClothLineSceneMesh.h"
#import "DHAnimationSettings.h"

@interface DHObjectClothLineAnimation () {
    GLuint offsetLoc;
}
@property (nonatomic) CGPoint offset;
@end

@implementation DHObjectClothLineAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectClothLineVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectClothLineFragment.glsl";
}

- (void) setupUniforms
{
    [super setupUniforms];
    offsetLoc = glGetUniformLocation(program, "u_offset");
}

- (void) setUpTargetGeometry
{
    [super setUpTargetGeometry];
    if (self.settings.direction == DHAnimationDirectionLeftToRight) {
        self.offset = CGPointMake(-self.targetOrigin.x - self.targetSize.width * 1.5, 0);
    } else {
        self.offset = CGPointMake(self.settings.animationView.bounds.size.width - self.targetOrigin.x - self.targetSize.width, 0);
    }
}

- (void) setupMeshes
{
    self.mesh = [[DHObjectClothLineSceneMesh alloc] initWithTargetSize:self.targetSize origin:self.targetOrigin columnCount:1 rowCount:1 columnMajored:YES rotate:YES];
    [self.mesh generateMeshesData];
    [self.mesh printGeometryData];
    [self.mesh printIndices];
}

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval
{
    [super updateWithTimeInterval:timeInterval];
    self.offset = CGPointMake(self.offset.x * (1 - self.percent), self.offset.y * (1 - self.percent));
    NSLog(@"offset= (%g, %g)", self.offset.x, self.offset.y);
}

- (void) drawFrame
{
    glUniform2f(offsetLoc, self.offset.x, self.offset.y);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

@end
