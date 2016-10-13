//
//  DHObjectBlindsSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/13.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHAnimationSimpleSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector3 columnStartPosition;
}DHSimpleSceneMeshAttributes;

@implementation DHAnimationSimpleSceneMesh

- (void) generateMeshesData
{
    [self generateGeometryAttributes];
    [self generateIndicesData];
    DHSimpleSceneMeshAttributes *vertices = malloc(sizeof(DHSimpleSceneMeshAttributes) * self.vertexCount);
    for (NSInteger i = 0; i < self.vertexCount; i++) {
        vertices[i].position = geometryAttribtues[i].position;
        vertices[i].texCoords = geometryAttribtues[i].texCoords;
        vertices[i].columnStartPosition = geometryAttribtues[i / 4 * 4].position;
    }
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:sizeof(DHSimpleSceneMeshAttributes) * self.vertexCount freeWhenDone:YES];
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHSimpleSceneMeshAttributes), NULL + offsetof(DHSimpleSceneMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHSimpleSceneMeshAttributes), NULL + offsetof(DHSimpleSceneMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(DHSimpleSceneMeshAttributes), NULL + offsetof(DHSimpleSceneMeshAttributes, columnStartPosition));
    
    glBindVertexArray(0);
}

@end
