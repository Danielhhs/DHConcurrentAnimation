//
//  DHAnimationSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

@implementation DHAnimationSceneMesh

- (instancetype) initWithTargetSize:(CGSize)size
                             origin:(CGPoint)origin
                        columnCount:(NSInteger)columnCount
                           rowCount:(NSInteger)rowCount
                      columnMajored:(BOOL)columnMajored
                             rotate:(BOOL)rotate
{
    self = [super init];
    if (self) {
        _size = size;
        _origin = origin;
        _columnCount = columnCount;
        _rowCount = rowCount;
    }
    return self;
}

- (void) generateMeshesData
{
    
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, [self attributesStride], NULL + offsetof(DHSceneGeometryAttribtues, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, [self attributesStride], NULL + offsetof(DHSceneGeometryAttribtues, texCoords));
    
    [self enableExtraVertexAttributes];
    
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_INT, NULL);
    glBindVertexArray(0);
}

- (void) tearDown
{
    if (vertexArray) {
        glDeleteVertexArrays(1, &vertexArray);
        vertexArray = 0;
    }
    if (vertexBuffer) {
        glDeleteBuffers(1, &vertexBuffer);
        vertexBuffer = 0;
    }
    if (indexBuffer) {
        glDeleteBuffers(1, &indexBuffer);
        indexBuffer = 0;
    }
}

- (void) generateGeometryAttributes
{
    
}

- (GLsizei) attributesStride
{
    return 0;
}

- (void) enableExtraVertexAttributes
{
    
}

- (void) generateIndicesData
{
    
}

- (void) printGeometryData
{
    for (int i = 0; i < self.vertexCount; i++) {
        NSLog(@"position = (%g, %g, %g), texCoords = (%g, %g)", geometryAttribtues[i].position.x, geometryAttribtues[i].position.y, geometryAttribtues[i].position.z, geometryAttribtues[i].texCoords.s, geometryAttribtues[i].texCoords.t);
    }
}

- (void) printIndices
{
    for (int i = 0; i < self.indexCount; i++) {
        NSLog(@"%d", indices[i]);
    }
}
@end
