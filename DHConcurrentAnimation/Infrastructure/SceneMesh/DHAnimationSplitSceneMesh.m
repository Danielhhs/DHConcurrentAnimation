//
//  DHAnimationSplitSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/12/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationSplitSceneMesh.h"

@implementation DHAnimationSplitSceneMesh

- (void) generateGeometryAttributes
{
    self.vertexCount = self.columnCount * self.rowCount * 4;
    self.indexCount = self.columnCount * self.rowCount * 6;
    geometryAttribtues = malloc(sizeof(DHSceneGeometryAttribtues) * self.vertexCount);
    
    if (self.columnMajored) {
        [self generateColumnMajoredGeometryAttributes];
    } else {
        [self generateRowMajoredGeometryAttributes];
    }
}

- (void) generateColumnMajoredGeometryAttributes
{
    NSInteger index = 0;
    CGFloat ux = 1.f / self.columnCount;
    CGFloat uy = 1.f / self.rowCount;
    for (int x = 0; x < self.columnCount; x++) {
        CGFloat vx = ux * x;
        for (int y = 0; y < self.rowCount; y++) {
            CGFloat vy = uy * y;
            index = (x * self.rowCount + y) * 4;
            geometryAttribtues[index + 0].position = GLKVector3Make(self.origin.x + vx * self.size.width, self.origin.y + vy * self.size.height, 0);
            geometryAttribtues[index + 0].texCoords = GLKVector2Make(vx, 1 - vy);
            
            geometryAttribtues[index + 1].position = GLKVector3Make(self.origin.x + (vx + ux) * self.size.width, self.origin.y + vy * self.size.height, 0);
            geometryAttribtues[index + 1].texCoords = GLKVector2Make(vx + ux, 1 - vy);
            
            geometryAttribtues[index + 2].position = GLKVector3Make(self.origin.x + vx * self.size.width, self.origin.y + (vy + uy) * self.size.height, 0);
            geometryAttribtues[index + 2].texCoords = GLKVector2Make(vx, 1 - (vy + uy));
            
            geometryAttribtues[index + 3].position = GLKVector3Make(self.origin.x + (vx + ux) * self.size.width, self.origin.y + (vy + uy) * self.size.height, 0);
            geometryAttribtues[index + 3].texCoords = GLKVector2Make(vx + ux, 1 - (vy + uy));
        }
    }
}

- (void) generateRowMajoredGeometryAttributes
{
    NSInteger index = 0;
    CGFloat ux = 1.f / self.columnCount;
    CGFloat uy = 1.f / self.rowCount;
    for (int y = 0; y < self.rowCount; y++) {
        CGFloat vy = uy * y;
        for (int x = 0; x < self.columnCount; x++) {
            CGFloat vx = ux * x;
            index = y * self.columnCount + x;
            geometryAttribtues[index + 0].position = GLKVector3Make(self.origin.x + vx * self.size.width, self.origin.y + vy * self.size.height, 0);
            geometryAttribtues[index + 0].texCoords = GLKVector2Make(vx, 1 - vy);
            
            geometryAttribtues[index + 1].position = GLKVector3Make(self.origin.x + (vx + ux) * self.size.width, self.origin.y + vy * self.size.height, 0);
            geometryAttribtues[index + 1].texCoords = GLKVector2Make(vx + ux, 1 - vy);
            
            geometryAttribtues[index + 2].position = GLKVector3Make(self.origin.x + vx * self.size.width, self.origin.y + (vy + uy) * self.size.height, 0);
            geometryAttribtues[index + 2].texCoords = GLKVector2Make(vx, 1 - (vy + uy));
            
            geometryAttribtues[index + 3].position = GLKVector3Make(self.origin.x + (vx + ux) * self.size.width, self.origin.y + (vy + uy) * self.size.height, 0);
            geometryAttribtues[index + 3].texCoords = GLKVector2Make(vx + ux, 1 - (vy + uy));
        }
    }
}


- (void) generateIndicesData
{
    indices = malloc(sizeof(GLuint) * self.indexCount);
    int index = 0;
    for (int x = 0; x < self.columnCount; x++) {
        for (int y = 0; y < self.rowCount; y++) {
            index = x * (int)self.rowCount + y;
            indices[index * 6 + 0] = index * 4;
            indices[index * 6 + 1] = index * 4 + 1;
            indices[index * 6 + 2] = index * 4 + 2;
            indices[index * 6 + 3] = index * 4 + 2;
            indices[index * 6 + 4] = index * 4 + 1;
            indices[index * 6 + 5] = index * 4 + 3;
        }
    }
}

@end
