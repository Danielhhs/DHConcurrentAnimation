//
//  DHAnimationContinousSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationContinousSceneMesh.h"

@implementation DHAnimationContinousSceneMesh

- (void) generateGeometryAttributes
{
    self.vertexCount = (self.rowCount + 1) * (self.columnCount + 1);
    self.indexCount = self.rowCount * self.columnCount * 6;
    
    geometryAttribtues = malloc(sizeof(DHSceneGeometryAttribtues) * self.vertexCount);
    
    if (self.columnMajored) {
        [self generateColumnMajoredGeometryAttributes];
    } else {
        [self generateRowMajoredGeometryAttributes];
    }
}

- (void) generateColumnMajoredGeometryAttributes
{
    CGFloat ux = 1.f / self.columnCount;
    CGFloat uy = 1.f / self.rowCount;
    for (int x = 0;  x <= self.columnCount; x++) {
        CGFloat vx = ux * x;
        for (int y = 0; y <= self.rowCount; y++) {
            CGFloat vy = uy * y;
            geometryAttribtues[x * (self.rowCount + 1) + y].position = GLKVector3Make(self.origin.x + vx * self.size.width, self.origin.y + vy * self.size.height, 0);
            geometryAttribtues[x * (self.rowCount + 1) + y].texCoords = GLKVector2Make(vx, 1 - vy);
        }
    }
}

- (void) generateRowMajoredGeometryAttributes
{
    CGFloat ux = 1.f / self.columnCount;
    CGFloat uy = 1.f / self.rowCount;
    for (int y = 0; y <= self.rowCount; y++) {
        CGFloat vy = uy * y;
        for (int x = 0;  x <= self.columnCount; x++) {
            CGFloat vx = ux * x;
            geometryAttribtues[y * (self.columnCount + 1) + x].position = GLKVector3Make(self.origin.x + vx * self.size.width, self.origin.y + vy * self.size.height, 0);
            geometryAttribtues[y * (self.columnCount + 1) + y].texCoords = GLKVector2Make(vx, 1 - vy);
        }
    }
}

- (void) generateIndicesData
{
    indices = malloc(sizeof(GLuint) * self.indexCount);
    if (self.columnMajored) {
        for (NSInteger x = 0; x < self.columnCount; x++) {
            for (NSInteger y = 0; y < self.rowCount; y++) {
                NSInteger index = x * self.rowCount + y;
                NSInteger i = x * (self.rowCount + 1) + y;
                indices[index * 6 + 0] = (GLuint)i;
                indices[index * 6 + 1] = (GLuint)i + 1;
                indices[index * 6 + 2] = (GLuint)(i + self.rowCount + 1);
                indices[index * 6 + 3] = (GLuint)(i + self.rowCount + 1);
                indices[index * 6 + 4] = (GLuint)(i + 1);
                indices[index * 6 + 5] = (GLuint)(i + self.rowCount + 2);
            }
        }
    } else {
        for (NSInteger y = 0; y < self.rowCount; y++) {
            for (NSInteger x = 0; x < self.columnCount; x++) {
                NSInteger index = y * self.columnCount + x;
                NSInteger i = y * (self.columnCount + 1) + x;
                indices[index * 6 + 0] = (GLuint)i;
                indices[index * 6 + 1] = (GLuint)(i + self.columnCount + 1);
                indices[index * 6 + 2] = (GLuint)i + 1;
                indices[index * 6 + 3] = (GLuint)i + 1;
                indices[index * 6 + 4] = (GLuint)(i + self.columnCount + 1);
                indices[index * 6 + 5] = (GLuint)(i + self.columnCount + 2);
            }
        }
    }
}

@end
