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
                       splitTexture:(BOOL)splitTexture
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
    
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_INT, NULL);
    glBindVertexArray(0);
}

- (void) generateGeometryAttributes
{
    
}

@end
