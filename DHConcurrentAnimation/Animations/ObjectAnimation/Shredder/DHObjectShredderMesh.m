//
//  DHObjectShredderMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/19.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectShredderMesh.h"

#define SHREDDER_INSET 5

@implementation DHObjectShredderMesh

- (void) generateMeshesData
{
    [self generateGeometryAttributes];
    [self generateIndicesData];
    
    geometryAttribtues[0].position = GLKVector3Make(self.origin.x - SHREDDER_INSET, self.containerHeight - self.shredderHeight, 0);
    geometryAttribtues[0].texCoords = GLKVector2Make(0, 1);
    geometryAttribtues[1].position = GLKVector3Make(CGRectGetMaxX(self.target.frame) + SHREDDER_INSET, self.containerHeight - self.shredderHeight, 0);
    geometryAttribtues[1].texCoords = GLKVector2Make(1, 1);
    geometryAttribtues[2].position = GLKVector3Make(self.origin.x - SHREDDER_INSET, self.containerHeight - SHREDDER_INSET, 0);
    geometryAttribtues[2].texCoords = GLKVector2Make(0, 0);
    geometryAttribtues[3].position = GLKVector3Make(CGRectGetMaxX(self.target.frame) + SHREDDER_INSET, self.containerHeight - SHREDDER_INSET, 0);
    geometryAttribtues[3].texCoords = GLKVector2Make(1, 0);
    
    self.vertexData = [NSData dataWithBytesNoCopy:geometryAttribtues length:sizeof(DHSceneGeometryAttribtues) * 4 freeWhenDone:YES];
    self.indexData = [NSData dataWithBytesNoCopy:indices length:sizeof(GLuint) * 6 freeWhenDone:YES];
    [self prepareToDraw];
}

- (GLsizei) attributesStride
{
    return sizeof(DHSceneGeometryAttribtues);
}
@end
