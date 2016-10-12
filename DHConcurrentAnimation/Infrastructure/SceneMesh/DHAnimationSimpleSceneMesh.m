//
//  DHAnimationSimpleSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/12.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHAnimationSimpleSceneMesh.h"

@implementation DHAnimationSimpleSceneMesh

- (void) generateMeshesData
{
    [self generateGeometryAttributes];
    [self generateIndicesData];
    self.vertexData = [NSData dataWithBytesNoCopy:geometryAttribtues length:sizeof(DHSceneGeometryAttribtues) * self.vertexCount freeWhenDone:YES];
    self.indexData = [NSData dataWithBytesNoCopy:indices length:sizeof(GLuint) * self.indexCount freeWhenDone:YES];
    [self prepareToDraw];
}

- (GLsizei) attributesStride
{
    return sizeof(DHSceneGeometryAttribtues);
}

@end
