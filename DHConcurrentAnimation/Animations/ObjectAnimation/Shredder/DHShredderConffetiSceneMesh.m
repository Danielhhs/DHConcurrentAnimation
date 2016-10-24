//
//  DHShredderConffetiSceneMesh.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/19.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHShredderConffetiSceneMesh.h"
#import <OpenGLES/ES3/glext.h>

typedef struct{
    GLKVector3 position;
    GLKVector2 texCoords;
    GLfloat startY;
    GLfloat length;
    GLfloat radius;
    GLfloat startFallingTime;
    GLKVector3 direction;
}DHShredderConfettiMeshAttributes;
@interface DHShredderConffetiSceneMesh ()
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, strong) NSMutableData *verticesData;
@property (nonatomic, strong) NSMutableData *indicesData;
@end

@implementation DHShredderConffetiSceneMesh
- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView
{
    self = [super init];
    if (self) {
        self.targetView = targetView;
        self.containerView = containerView;
        self.verticesData = [NSMutableData data];
        self.indicesData = [NSMutableData data];
    }
    return self;
}

- (void) appendConfettiAtPosition:(GLKVector3)position length:(GLfloat)length startFallingTime:(GLfloat)startFallingTime
{
    GLfloat width = 2 + arc4random() % 2;
    GLfloat originX = self.targetView.frame.origin.x;
    GLfloat originY = 0;
    if (self.containerView) {
        originY = self.containerView.bounds.size.height - CGRectGetMaxY(self.targetView.frame);
    }
    GLKVector3 direction = [self randomDirectionForLength:length];
    DHShredderConfettiMeshAttributes bottomLeft;
    bottomLeft.position = GLKVector3Make(position.x, position.y, position.z);
    bottomLeft.texCoords = GLKVector2Make((bottomLeft.position.x - originX) / self.targetView.frame.size.width, 1.f - (bottomLeft.position.y - originY) / self.targetView.frame.size.height);
    bottomLeft.length = length;
    bottomLeft.radius = 0;
    bottomLeft.startY = position.y;
    bottomLeft.startFallingTime = startFallingTime;
    bottomLeft.direction = direction;
    [self.verticesData appendBytes:&bottomLeft length:sizeof(DHShredderConfettiMeshAttributes)];
    
    DHShredderConfettiMeshAttributes bottomRight;
    bottomRight.position = GLKVector3Make(position.x + width, position.y, position.z);
    bottomRight.texCoords = GLKVector2Make((bottomRight.position.x - originX) / self.targetView.frame.size.width, 1.f - (bottomRight.position.y - originY) / self.targetView.frame.size.height);
    bottomRight.length = length;
    bottomRight.radius = 0;
    bottomRight.startY = position.y;
    bottomRight.startFallingTime = startFallingTime;
    bottomRight.direction = direction;
    [self.verticesData appendBytes:&bottomRight length:sizeof(DHShredderConfettiMeshAttributes)];
    
    DHShredderConfettiMeshAttributes topLeft;
    topLeft.position = GLKVector3Make(position.x, position.y + length, position.z);
    topLeft.texCoords = GLKVector2Make((topLeft.position.x - originX) / self.targetView.frame.size.width, 1.f - (topLeft.position.y - originY) / self.targetView.frame.size.height);
    topLeft.length = length;
    topLeft.radius = 0;
    topLeft.startY = position.y;
    topLeft.startFallingTime = startFallingTime;
    topLeft.direction = direction;
    [self.verticesData appendBytes:&topLeft length:sizeof(DHShredderConfettiMeshAttributes)];
    
    DHShredderConfettiMeshAttributes topRight;
    topRight.position = GLKVector3Make(position.x + width, position.y + length, position.z);
    topRight.texCoords = GLKVector2Make((topRight.position.x - originX) / self.targetView.frame.size.width, 1.f - (topRight.position.y - originY) / self.targetView.frame.size.height);
    topRight.length = length;
    topRight.radius = 0;
    topRight.startY = position.y;
    topRight.startFallingTime = startFallingTime;
    topLeft.direction = direction;
    [self.verticesData appendBytes:&topRight length:sizeof(DHShredderConfettiMeshAttributes)];
    
    
    GLuint index1 = ((GLuint)self.indexCount / 6) * 4 + 0;
    GLuint index2 = ((GLuint)self.indexCount / 6) * 4 + 1;
    GLuint index3 = ((GLuint)self.indexCount / 6) * 4 + 2;
    GLuint index4 = ((GLuint)self.indexCount / 6) * 4 + 2;
    GLuint index5 = ((GLuint)self.indexCount / 6) * 4 + 1;
    GLuint index6 = ((GLuint)self.indexCount / 6) * 4 + 3;
    [self.indicesData appendBytes:&index1 length:sizeof(GLuint)];
    [self.indicesData appendBytes:&index2 length:sizeof(GLuint)];
    [self.indicesData appendBytes:&index3 length:sizeof(GLuint)];
    [self.indicesData appendBytes:&index4 length:sizeof(GLuint)];
    [self.indicesData appendBytes:&index5 length:sizeof(GLuint)];
    [self.indicesData appendBytes:&index6 length:sizeof(GLuint)];
    
    self.indexCount += 6;
    self.vertexCount += 4;
}

- (GLKVector3) randomDirectionForLength:(GLfloat)length
{
    GLfloat x = arc4random() % ((int)length / 3);
    GLfloat y = arc4random() % ((int)length / 2);
    GLfloat z = arc4random() % ((int)length / 3);
    GLKVector3 direction = GLKVector3Normalize(GLKVector3Make(-x, -y, z));
    return direction;
}

- (void) prepareToDraw
{
    if (vertexBuffer == 0 && [self.verticesData length] > 0) {
        glGenBuffers(1, &vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, [self.verticesData length], [self.verticesData bytes], GL_STATIC_DRAW);
        glGenVertexArrays(1, &vertexArray);
    }
    if (indexBuffer == 0 && [self.indicesData length] > 0) {
        glGenBuffers(1, &indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, [self.indicesData length], [self.indicesData bytes], GL_STATIC_DRAW);
    }
    
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, position));
    
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, texCoords));
    
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, startY));
    
    glEnableVertexAttribArray(3);
    glVertexAttribPointer(3, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, length));
    
    glEnableVertexAttribArray(4);
    glVertexAttribPointer(4, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, radius));
    
    glEnableVertexAttribArray(5);
    glVertexAttribPointer(5, 1, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, startFallingTime));
    
    glEnableVertexAttribArray(6);
    glVertexAttribPointer(6, 3, GL_FLOAT, GL_FALSE, sizeof(DHShredderConfettiMeshAttributes), NULL + offsetof(DHShredderConfettiMeshAttributes, direction));
    glBindVertexArray(0);
}

- (void) drawEntireMesh
{
    glBindVertexArray(vertexArray);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_INT, NULL);
    glBindVertexArray(0);
}
@end
