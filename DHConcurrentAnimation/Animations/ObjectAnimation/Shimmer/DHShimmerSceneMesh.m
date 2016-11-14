//
//  DHShimmerSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/24.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHShimmerSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector3 originalCenter;
}DHShimmerSceneMeshAttributes;

@implementation DHShimmerSceneMesh

- (void) generateMeshesData
{
    [self generateGeometryAttributes];
    [self generateIndicesData];
    
    DHShimmerSceneMeshAttributes *vertices = malloc(sizeof(DHShimmerSceneMeshAttributes) * self.vertexCount);
    
    for (int i = 0; i < self.vertexCount; i++) {
        vertices[i].position = geometryAttribtues[i].position;
        vertices[i].texCoords = geometryAttribtues[i].texCoords;
        
        NSInteger index = i / 4;
        GLKVector3 offset = GLKVector3Make([self.offsetData[index] doubleValue], [self.offsetData[index+ 1] doubleValue], [self.offsetData[index + 2] doubleValue]);
        vertices[index * 4 + 0].originalCenter = GLKVector3Add(vertices[index * 4 + 0].position, offset);
        vertices[index * 4 + 1].originalCenter = GLKVector3Add(vertices[index * 4 + 1].position, offset);
        vertices[index * 4 + 2].originalCenter = GLKVector3Add(vertices[index * 4 + 2].position, offset);
        vertices[index * 4 + 3].originalCenter = GLKVector3Add(vertices[index * 4 + 3].position, offset);
    }
    
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:sizeof(DHShimmerSceneMeshAttributes) * self.vertexCount freeWhenDone:YES];
    self.indexData = [NSData dataWithBytesNoCopy:indices length:sizeof(GLuint) * self.indexCount freeWhenDone:YES];
    
    [self prepareToDraw];
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.vertexData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.vertexData length], [self.vertexData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0 && [self.indexData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indexData length], [self.indexData bytes], GL_STATIC_DRAW);
    }
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHShimmerSceneMeshAttributes), NULL + offsetof(DHShimmerSceneMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHShimmerSceneMeshAttributes), NULL + offsetof(DHShimmerSceneMeshAttributes,
                                                                                                          texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(DHShimmerSceneMeshAttributes), NULL + offsetof(DHShimmerSceneMeshAttributes, originalCenter));
    
    glBindVertexArray(0);
}

@end
