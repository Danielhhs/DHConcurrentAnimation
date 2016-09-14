//
//  DHObjectClothLineAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectClothLineAnimation.h"
#import "DHObjectClothLineSceneMesh.h"

@interface DHObjectClothLineAnimation () {
    GLuint offsetLoc;
}

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

- (void) setupMeshes
{
    self.mesh = [[DHObjectClothLineSceneMesh alloc] initWithTargetSize:self.targetSize origin:self.targetOrigin columnCount:1 rowCount:1 columnMajored:YES rotate:YES];
    [self.mesh generateMeshesData];
}

@end
