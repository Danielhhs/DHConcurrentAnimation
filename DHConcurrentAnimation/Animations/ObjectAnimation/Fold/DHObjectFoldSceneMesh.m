//
//  DHObjectFoldSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/19/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectFoldSceneMesh.h"
#import <OpenGLES/ES3/glext.h>
typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat index;
    GLKVector3 columnStartPosition;
}DHFoldSceneMeshAttributes;

@interface DHObjectFoldSceneMesh () {
    DHFoldSceneMeshAttributes *vertices;
}
@end

@implementation DHObjectFoldSceneMesh
- (void) generateMeshesData
{
    [self generateVerticesData];
    
    NSInteger gridCount = self.columnCount;
    if (self.direction == DHAnimationDirectionTopToBottom || self.direction == DHAnimationDirectionBottomToTop) {
        gridCount = self.rowCount;
    }
    self.indexCount = (gridCount + 1) * 6;
    indices = malloc(sizeof(GLuint) * self.indexCount);
    for (int i = 0; i <= gridCount; i++) {
        indices[i * 6 + 0] = i * 4 + 0;
        indices[i * 6 + 1] = i * 4 + 1;
        indices[i * 6 + 2] = i * 4 + 2;
        indices[i * 6 + 3] = i * 4 + 2;
        indices[i * 6 + 4] = i * 4 + 1;
        indices[i * 6 + 5] = i * 4 + 3;
    }
    self.vertexData = [NSData dataWithBytesNoCopy:vertices length:self.vertexCount * sizeof(DHFoldSceneMeshAttributes) freeWhenDone:YES];
    self.indexData = [NSData dataWithBytesNoCopy:indices length:self.indexCount * sizeof(GLuint) freeWhenDone:YES];
    [self prepareToDraw];
}

- (void) generateVerticesData
{
    switch (self.direction) {
        case DHAnimationDirectionLeftToRight:
        case DHAnimationDirectionRightToLeft:
        {
            [self generateVerticesForHorizontal];
        }
            break;
        case DHAnimationDirectionBottomToTop:
        case DHAnimationDirectionTopToBottom:
        {
            [self generateVerticesForVertical];
        }
            break;
        default:
            break;
    }
}
- (void) generateVerticesForHorizontal
{
    self.vertexCount = (self.columnCount + 1) * 4;
    vertices = malloc(self.vertexCount * sizeof(DHFoldSceneMeshAttributes));
    
    GLfloat columnWidth = (self.size.width - self.headerHeight) / self.columnCount;
    GLfloat originX = self.origin.x;
    GLfloat originY = self.origin.y;
    
    CGFloat originXOffset = self.headerHeight;
    if (self.direction == DHAnimationDirectionRightToLeft) {
        vertices[0].position = GLKVector3Make(originX, originY, 0);
        vertices[0].texCoords = GLKVector2Make(0, 1);
        vertices[0].index = -1.f;
        vertices[1].position = GLKVector3Make(originX + self.headerHeight, originY, 0);
        vertices[1].texCoords = GLKVector2Make(self.headerHeight / self.size.width, 1);
        vertices[1].index = -1.f;
        
        vertices[2].position = GLKVector3Make(originX, originY + self.size.height, 0);
        vertices[2].texCoords = GLKVector2Make(0, 0);
        vertices[2].index = -1.f;
        vertices[3].position = GLKVector3Make(originX + self.headerHeight, originY + self.size.height, 0);
        vertices[3].texCoords = GLKVector2Make(self.headerHeight / self.size.width, 0);
        vertices[3].index = -1.f;
    } else {
        vertices[0].position = GLKVector3Make(originX + self.size.width - self.headerHeight, originY, 0);
        vertices[0].texCoords = GLKVector2Make(1 - self.headerHeight / self.size.width, 1);
        vertices[0].index = -1.f;
        vertices[1].position = GLKVector3Make(originX + self.size.width, originY, 0);
        vertices[1].texCoords = GLKVector2Make(1, 1);
        vertices[1].index = -1.f;
        
        vertices[2].position = GLKVector3Make(originX + self.size.width - self.headerHeight, originY + self.size.height, 0);
        vertices[2].texCoords = GLKVector2Make(1 - self.headerHeight / self.size.width, 0);
        vertices[2].index = -1.f;
        vertices[3].position = GLKVector3Make(originX + self.size.width, originY + self.size.height, 0);
        vertices[3].texCoords = GLKVector2Make(1, 0);
        vertices[3].index = -1.f;
        originXOffset = 0;
    }
    for (int i = 0; i < self.columnCount; i++) {
        int index = i;
        if (self.direction == DHAnimationDirectionLeftToRight) {
            index = (int)self.columnCount - 1 - i;
        }
        vertices[(i + 1) * 4 + 0].position = GLKVector3Make(originX + originXOffset + i * columnWidth, originY, 0);
        vertices[(i + 1) * 4 + 0].texCoords = GLKVector2Make((originXOffset + i * columnWidth) / self.size.width, 1.f);
        vertices[(i + 1) * 4 + 0].index = index;
        vertices[(i + 1) * 4 + 0].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 1].position = GLKVector3Make(originX + originXOffset + (i + 1) * columnWidth, originY, 0);
        vertices[(i + 1) * 4 + 1].texCoords = GLKVector2Make((originXOffset + (i + 1) * columnWidth) / self.size.width, 1.f);
        vertices[(i + 1) * 4 + 1].index = index;
        vertices[(i + 1) * 4 + 1].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 2].position = GLKVector3Make(originX + originXOffset + i * columnWidth, originY + self.size.height, 0);
        vertices[(i + 1) * 4 + 2].texCoords = GLKVector2Make((originXOffset + i * columnWidth) / self.size.width, 0.f);
        vertices[(i + 1) * 4 + 2].index = index;
        vertices[(i + 1) * 4 + 2].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 3].position = GLKVector3Make(originX + originXOffset + (i + 1) * columnWidth, originY + self.size.height, 0);
        vertices[(i + 1) * 4 + 3].texCoords = GLKVector2Make((originXOffset + (i + 1) * columnWidth) / self.size.width, 0.f);
        vertices[(i + 1) * 4 + 3].index = index;
        vertices[(i + 1) * 4 + 3].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
    }
    
}

- (void) generateVerticesForVertical
{
    self.vertexCount = (self.rowCount + 1) * 4;
    vertices = malloc(self.vertexCount * sizeof(DHFoldSceneMeshAttributes));
    
    GLfloat rowHeight = (self.size.height - self.headerHeight) / self.rowCount;
    GLfloat originX = self.origin.x;
    GLfloat originY = self.origin.y;
    
    CGFloat originYOffset = self.headerHeight;
    if (self.direction == DHAnimationDirectionTopToBottom) {
        vertices[0].position = GLKVector3Make(originX, originY, 0);
        vertices[0].texCoords = GLKVector2Make(0, 1);
        vertices[0].index = -1.f;
        vertices[1].position = GLKVector3Make(originX + self.size.width, originY, 0);
        vertices[1].texCoords = GLKVector2Make(1, 1);
        vertices[1].index = -1.f;
        
        vertices[2].position = GLKVector3Make(originX, originY + self.headerHeight, 0);
        vertices[2].texCoords = GLKVector2Make(0, 1 - self.headerHeight / self.size.height);
        vertices[2].index = -1.f;
        vertices[3].position = GLKVector3Make(originX + self.size.width, originY + self.headerHeight, 0);
        vertices[3].texCoords = GLKVector2Make(1, 1 - self.headerHeight / self.size.height);
        vertices[3].index = -1.f;
    } else {
        vertices[0].position = GLKVector3Make(originX, originY + self.size.height, 0);
        vertices[0].texCoords = GLKVector2Make(0, 0);
        vertices[0].index = -1.f;
        vertices[1].position = GLKVector3Make(originX + self.size.width, originY + self.size.height, 0);
        vertices[1].texCoords = GLKVector2Make(1, 0);
        vertices[1].index = -1.f;
        
        vertices[2].position = GLKVector3Make(originX, originY + self.size.height - self.headerHeight, 0);
        vertices[2].texCoords = GLKVector2Make(0, self.headerHeight / self.size.height);
        vertices[2].index = -1.f;
        vertices[3].position = GLKVector3Make(originX + self.size.width, originY + self.size.height - self.headerHeight, 0);
        vertices[3].texCoords = GLKVector2Make(1, self.headerHeight / self.size.height);
        vertices[3].index = -1.f;
    }
    for (int i = 0; i < self.rowCount; i++) {
        int index = i;
        if (self.direction == DHAnimationDirectionBottomToTop) {
            index = (int)self.rowCount - 1 - i;
            vertices[(i + 1) * 4 + 0].texCoords = GLKVector2Make(0, (originYOffset + index * rowHeight) / self.size.height);
            vertices[(i + 1) * 4 + 1].texCoords = GLKVector2Make(1, (originYOffset + index * rowHeight) / self.size.height);
            vertices[(i + 1) * 4 + 2].texCoords = GLKVector2Make(0, (originYOffset + (index + 1) * rowHeight) / self.size.height);
            vertices[(i + 1) * 4 + 3].texCoords = GLKVector2Make(1, (originYOffset + (index + 1) * rowHeight) / self.size.height);
        } else  {
            vertices[(i + 1) * 4 + 0].texCoords = GLKVector2Make(0, 1.f - (originYOffset + index * rowHeight) / self.size.height);
            vertices[(i + 1) * 4 + 1].texCoords = GLKVector2Make(1, 1.f - (originYOffset + index * rowHeight) / self.size.height);
            vertices[(i + 1) * 4 + 2].texCoords = GLKVector2Make(0, 1.f - (originYOffset + (index + 1) * rowHeight) / self.size.height);
            vertices[(i + 1) * 4 + 3].texCoords = GLKVector2Make(1, 1.f - (originYOffset + (index + 1) * rowHeight) / self.size.height);
        }
        vertices[(i + 1) * 4 + 0].position = GLKVector3Make(originX, originY + originYOffset + index * rowHeight, 0);
        vertices[(i + 1) * 4 + 0].index = index;
        vertices[(i + 1) * 4 + 0].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 1].position = GLKVector3Make(originX + self.size.width, originY + originYOffset + index * rowHeight, 0);
        vertices[(i + 1) * 4 + 1].index = index;
        vertices[(i + 1) * 4 + 1].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 2].position = GLKVector3Make(originX, originY + originYOffset + (index + 1) * rowHeight, 0);
        vertices[(i + 1) * 4 + 2].index = index;
        vertices[(i + 1) * 4 + 2].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
        
        vertices[(i + 1) * 4 + 3].position = GLKVector3Make(originX + self.size.width, originY + originYOffset + (index + 1) * rowHeight, 0);
        vertices[(i + 1) * 4 + 3].index = index;
        vertices[(i + 1) * 4 + 3].columnStartPosition = vertices[(i + 1) * 4 + 0].position;
    }
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
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, index));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(DHFoldSceneMeshAttributes), NULL + offsetof(DHFoldSceneMeshAttributes, columnStartPosition));
    
    glBindVertexArray(0);
    [self printVertices];
}

- (void) printVertices
{
    for (int i = 0; i < self.vertexCount; i++) {
        DHFoldSceneMeshAttributes attributes = vertices[i];
        NSLog(@"position = (%g, %g, %g)", attributes.position.x, attributes.position.y, attributes.position.z);
    }
}
@end
