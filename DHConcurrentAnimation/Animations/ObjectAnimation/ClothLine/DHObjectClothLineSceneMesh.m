//
//  DHObjectClothLineSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectClothLineSceneMesh.h"

@implementation DHObjectClothLineSceneMesh

- (void) generateMeshesData
{
    [self generateGeometryAttributes];
    [self generateIndicesData];
    self.vertexData = [NSData dataWithBytesNoCopy:geometryAttribtues length:sizeof(DHSceneGeometryAttribtues) * self.vertexCount freeWhenDone:YES];
    self.indexData = [NSData dataWithBytesNoCopy:indices length:sizeof(GLuint) * self.vertexCount freeWhenDone:YES];
    [self prepareToDraw];
}

- (GLsizei) attributesStride
{
    return sizeof(DHSceneGeometryAttribtues);
}

@end
