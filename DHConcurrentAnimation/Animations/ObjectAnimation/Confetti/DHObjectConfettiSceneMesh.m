//
//  DHObjectConfettiSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/17.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectConfettiSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLKVector3 vertexToCenter;
    GLfloat rotation;
    GLKVector3 originalCenter;
    GLKVector3 targetCenter;
}DHObjectConfettiSceneMeshAttributes;

@interface DHObjectConfettiSceneMesh () {
    DHObjectConfettiSceneMeshAttributes *vertices;
}

@end

@implementation DHObjectConfettiSceneMesh

- (void) generateMeshesData
{
    [self generateGeometryAttributes];
    [self generateIndicesData];
    vertices = malloc(self.vertexCount * sizeof(DHObjectConfettiSceneMeshAttributes));
    
    for (int x = 0; x < self.columnCount; x++) {
        for (int y = 0; y < self.rowCount; y++) {
            NSInteger index = (x * self.rowCount + y) * 4;
            GLKVector3 center = GLKVector3Make(-1 * (geometryAttribtues[index + 1].position.x + geometryAttribtues[index + 0].position.x) / 2, -1 * (geometryAttribtues[index + 2].position.y + geometryAttribtues[index + 0].position.y) / 2, geometryAttribtues[index + 2].position.z - geometryAttribtues[index + 0].position.z);
            
            vertices[index + 0].vertexToCenter = GLKVector3Add(geometryAttribtues[index + 0].position, center);
            vertices[index + 1].vertexToCenter = GLKVector3Add(geometryAttribtues[index + 1].position, center);
            vertices[index + 2].vertexToCenter = GLKVector3Add(geometryAttribtues[index + 2].position, center);
            vertices[index + 3].vertexToCenter = GLKVector3Add(geometryAttribtues[index + 3].position, center);
            
            center.z = 0;
            center.x *= -1;
            center.y *= -1;
            vertices[index + 0].originalCenter = center;
            vertices[index + 1].originalCenter = center;
            vertices[index + 2].originalCenter = center;
            vertices[index + 3].originalCenter = center;
            
            CGFloat columnWidth = geometryAttribtues[index + 1].position.x - geometryAttribtues[index + 0].position.x;
            if (columnWidth == 0) {
                columnWidth = geometryAttribtues[index + 2].position.x - geometryAttribtues[index + 0].position.x;
            }
            GLKVector3 targetCenter = [self targetCenterForVertexWithOriginalCenter:center columnWidth:columnWidth];
            vertices[index + 0].targetCenter = targetCenter;
            vertices[index + 1].targetCenter = targetCenter;
            vertices[index + 2].targetCenter = targetCenter;
            vertices[index + 3].targetCenter = targetCenter;
            
            
            GLfloat rotation = (arc4random() % 5 + 2) * M_PI * 2;
            vertices[index + 0].rotation = rotation;
            vertices[index + 1].rotation = rotation;
            vertices[index + 2].rotation = rotation;
            vertices[index + 3].rotation = rotation;
            
            vertices[index + 0].position = geometryAttribtues[index + 0].position;
            vertices[index + 1].position = geometryAttribtues[index + 1].position;
            vertices[index + 2].position = geometryAttribtues[index + 2].position;
            vertices[index + 3].position = geometryAttribtues[index + 3].position;
            vertices[index + 0].texCoords = geometryAttribtues[index + 0].texCoords;
            vertices[index + 1].texCoords = geometryAttribtues[index + 1].texCoords;
            vertices[index + 2].texCoords = geometryAttribtues[index + 2].texCoords;
            vertices[index + 3].texCoords = geometryAttribtues[index + 3].texCoords;
        }
    }
    
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:self.vertexCount * sizeof(DHObjectConfettiSceneMeshAttributes) freeWhenDone:YES];
    self.indexData = [NSData dataWithBytesNoCopy:indices length:self.indexCount * sizeof(GLuint) freeWhenDone:YES];
    [self prepareToDraw];
}

- (GLKVector3) targetCenterForVertexWithOriginalCenter:(GLKVector3)originalCenter columnWidth:(CGFloat)columnWidth
{
    GLKVector3 center = originalCenter;
    int maxOffset = columnWidth * 5;
    center.z = arc4random() % 1000 + 1000;
    GLfloat xOffset = (int)arc4random() % (maxOffset * 2) - maxOffset;
    center.x += xOffset;
    GLfloat yOffset = (int)arc4random() % (maxOffset * 2) - maxOffset;
    center.y += yOffset;
    return center;
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHObjectConfettiSceneMeshAttributes), NULL + offsetof(DHObjectConfettiSceneMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHObjectConfettiSceneMeshAttributes), NULL + offsetof(DHObjectConfettiSceneMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, sizeof(DHObjectConfettiSceneMeshAttributes), NULL + offsetof(DHObjectConfettiSceneMeshAttributes, vertexToCenter));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHObjectConfettiSceneMeshAttributes), NULL + offsetof(DHObjectConfettiSceneMeshAttributes, rotation));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 3, GL_FLOAT, GL_FALSE, sizeof(DHObjectConfettiSceneMeshAttributes), NULL + offsetof(DHObjectConfettiSceneMeshAttributes, originalCenter));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 3, GL_FLOAT, GL_FALSE, sizeof(DHObjectConfettiSceneMeshAttributes), NULL + offsetof(DHObjectConfettiSceneMeshAttributes, targetCenter));
    
    glBindVertexArray(0);
    
}

- (void) printVertices
{
    for (int i = 0; i < self.vertexCount; i++) {
        NSLog(@"position = (%g, %g, %g)", vertices[i].position.x, vertices[i].position.y, vertices[i].position.z);
        NSLog(@"vertexToCenter = (%g, %g, %g)", vertices[i].vertexToCenter.x, vertices[i].vertexToCenter.y, vertices[i].vertexToCenter.z);
        NSLog(@"originalCenter = (%g, %g, %g)", vertices[i].originalCenter.x, vertices[i].originalCenter.y, vertices[i].originalCenter.z);
        NSLog(@"targetCenter = (%g, %g, %g)", vertices[i].targetCenter.x, vertices[i].targetCenter.y, vertices[i].targetCenter.z);
    }
}

@end
