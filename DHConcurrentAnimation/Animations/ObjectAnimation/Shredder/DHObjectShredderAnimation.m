//
//  DHObjectShredderAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/19.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectShredderAnimation.h"
#import "DHProgramLoader.h"
#import "DHTextureLoader.h"
#import "DHObjectShredderMesh.h"
#import "DHShredderPieceSceneMesh.h"
#import "DHShredderConffetiSceneMesh.h";
@interface DHObjectShredderAnimation () {
    GLuint shredderPositionLoc, columnWidthLoc, screenScaleLoc, shredderDisappearTimeLoc, maxShredderPositionLoc;
    GLuint shredderProgram, shredderMvpLoc, shredderShredderPositionLoc, shredderSamplerLoc, shredderTexture;
    GLuint confettiProgram, confettiMvpLoc, confettiShredderPositionLoc, confettiSamplerLoc, confettiTimeLoc, confettiDurationLoc;
}
@property (nonatomic, strong) DHObjectShredderMesh *shredderMesh;
@property (nonatomic, strong) DHShredderConffetiSceneMesh *confettiMesh;
@end

#define SHREDDER_APPEAR_TIME_RATIO 0.1
#define SHREDDER_DISAPPEAR_TIME_RATIO 0.1
#define SHREDDER_STOP_TIME_RATIO 0.05
#define SHREDDER_TIME_RATIO (1-SHREDDER_APPEAR_TIME_RATIO-SHREDDER_DISAPPEAR_TIME_RATIO-SHREDDER_STOP_TIME_RATIO)

@implementation DHObjectShredderAnimation
- (NSString *) vertexShaderName
{
    return @"ObjectShredderPiecesVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectShredderPiecesFragment.glsl";
}

- (void) setupExtraUniforms
{
    shredderPositionLoc = glGetUniformLocation(program, "u_shredderPosition");
    columnWidthLoc = glGetUniformLocation(program, "u_columnWidth");
    screenScaleLoc = glGetUniformLocation(program, "u_screenScale");
    shredderDisappearTimeLoc = glGetUniformLocation(program, "u_shredderDisappearTime");
    maxShredderPositionLoc = glGetUniformLocation(program, "u_maxShredderPosition");
    
    shredderProgram = [DHProgramLoader loadProgramWithVertexShader:@"ObjectShredderVertex.glsl" fragmentShader:@"ObjectShredderFragment.glsl"];
    glUseProgram(shredderProgram);
    shredderShredderPositionLoc = glGetUniformLocation(shredderProgram, "u_shredderPosition");
    shredderMvpLoc = glGetUniformLocation(shredderProgram, "u_mvpMatrix");
    shredderSamplerLoc = glGetUniformLocation(shredderProgram, "s_tex");
    
    confettiProgram = [DHProgramLoader loadProgramWithVertexShader:@"ObjectShredderConfettiVertex.glsl" fragmentShader:@"ObjectShredderConfettiFragment.glsl"];
    glUseProgram(confettiProgram);
    confettiMvpLoc = glGetUniformLocation(confettiProgram, "u_mvpMatrix");
    confettiSamplerLoc = glGetUniformLocation(confettiProgram, "s_tex");
    confettiShredderPositionLoc = glGetUniformLocation(confettiProgram, "u_shredderPosition");
    confettiTimeLoc = glGetUniformLocation(confettiProgram, "u_time");
    confettiDurationLoc = glGetUniformLocation(confettiProgram, "u_duration");
}

- (void) setupTexture
{
    texture = [DHTextureLoader loadTextureWithView:self.settings.targetView];
    shredderTexture = [DHTextureLoader loadTextureWithImage:[UIImage imageNamed:@"Shredder.png"]];
}

- (void) setupMeshes
{
    self.mesh = [[DHShredderPieceSceneMesh alloc] initWithTargetView:self.settings.targetView containerView:self.settings.animationView columnCount:self.settings.columnCount];
    [self.mesh generateMeshesData];
    [self.mesh prepareToDraw];
    
    self.shredderMesh = [[DHObjectShredderMesh alloc] initWithTarget:self.settings.targetView size:self.targetSize origin:self.targetOrigin columnCount:1 rowCount:1 columnMajored:YES rotate:NO];
    self.shredderMesh.shredderHeight = self.shredderHeight;
    self.shredderMesh.containerHeight = 0;
    [self.shredderMesh generateMeshesData];
    [self.shredderMesh prepareToDraw];
    
    int baseConffetiCount = (int)self.settings.targetView.frame.size.height / 50;
    GLfloat originX = self.settings.targetView.frame.origin.x;
    GLfloat originY = self.settings.animationView.bounds.size.height - CGRectGetMaxY(self.settings.targetView.frame);
    self.confettiMesh = [[DHShredderConffetiSceneMesh alloc] initWithTargetView:self.settings.targetView containerView:self.settings.animationView];
    
    for (int i = 0; i < self.settings.columnCount; i++) {
        int conffetiCount = baseConffetiCount + arc4random() % ((int)self.settings.targetView.frame.size.height / 30 - baseConffetiCount);
        GLfloat x = i / (GLfloat)self.settings.columnCount * self.settings.targetView.frame.size.width + originX;
        GLfloat yGap = self.settings.targetView.frame.size.height / conffetiCount;
        GLfloat previousY = originY;
        for (int j = 0; j < conffetiCount; j++) {
            GLfloat y = previousY + yGap * 0.5 + arc4random() % ((int)yGap / 2);
            GLfloat length = arc4random() % (int)(y - previousY) * 0.2 + (y - previousY) * 0.1;
            previousY = y;
            GLKVector3 position = GLKVector3Make(x, y, 0);
            GLfloat fallingTime = (SHREDDER_STOP_TIME_RATIO + SHREDDER_APPEAR_TIME_RATIO + (y - originY + length) / (self.settings.targetView.frame.size.height) * SHREDDER_TIME_RATIO) * self.settings.duration;
            [self.confettiMesh appendConfettiAtPosition:position length:ceil(length) startFallingTime:fallingTime];
        }
    }
    [self.confettiMesh prepareToDraw];
}

- (void) drawFrame
{
    [super drawFrame];
    GLfloat shredderPosition = [self shredderPosition];
    glUniform1f(shredderPositionLoc, shredderPosition - self.shredderMesh.shredderHeight);
    glUniform1f(timeLoc, self.elapsedTime);
    glUniform1f(durationLoc, self.settings.duration);
    glUniform1f(columnWidthLoc, self.settings.targetView.frame.size.width / self.settings.columnCount);
    glUniform1f(shredderDisappearTimeLoc, self.settings.duration * SHREDDER_DISAPPEAR_TIME_RATIO);
    glUniform1f(maxShredderPositionLoc, self.settings.animationView.bounds.size.height - self.settings.targetView.frame.origin.y);
    glUniform1f(screenScaleLoc, [UIScreen mainScreen].scale);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(samplerLoc, 0);
    [self.mesh drawEntireMesh];
    
    glUseProgram(shredderProgram);
    glUniformMatrix4fv(shredderMvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(shredderShredderPositionLoc, shredderPosition);
    glBindTexture(GL_TEXTURE_2D, shredderTexture);
    glUniform1i(shredderSamplerLoc, 0);
    [self.shredderMesh drawEntireMesh];
    
    glUseProgram(confettiProgram);
    glUniformMatrix4fv(confettiMvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    glUniform1f(confettiShredderPositionLoc, shredderPosition - [self.shredderMesh shredderHeight]);
    glUniform1f(confettiTimeLoc, self.elapsedTime);
    glUniform1f(confettiDurationLoc, self.settings.duration);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(confettiSamplerLoc, 0);
    [self.confettiMesh drawEntireMesh];
}

- (CGFloat) shredderHeight
{
    if (_shredderHeight == 0) {
        return _shredderHeight = 200;
    }
    return _shredderHeight;
}


- (GLfloat) shredderPosition
{
    GLfloat shredderPosition = 0;
    GLfloat base = (self.settings.animationView.frame.size.height - CGRectGetMaxY(self.settings.targetView.frame) + self.shredderMesh.shredderHeight);
    if (self.percent < SHREDDER_APPEAR_TIME_RATIO) {
        shredderPosition = self.percent / SHREDDER_APPEAR_TIME_RATIO * base;
    } else if (self.percent < SHREDDER_APPEAR_TIME_RATIO + SHREDDER_STOP_TIME_RATIO) {
        shredderPosition = base;
    } else if (self.percent < 1 - SHREDDER_DISAPPEAR_TIME_RATIO) {
        GLfloat time = self.percent - (SHREDDER_APPEAR_TIME_RATIO + SHREDDER_STOP_TIME_RATIO);
        shredderPosition = base + time / SHREDDER_TIME_RATIO * self.settings.targetView.frame.size.height;
    } else {
        shredderPosition = (base + self.settings.targetView.frame.size.height) + (self.percent - (1 - SHREDDER_DISAPPEAR_TIME_RATIO)) / SHREDDER_DISAPPEAR_TIME_RATIO * (self.settings.targetView.frame.origin.y + self.shredderMesh.shredderHeight);
    }
    return shredderPosition;
}

- (void) tearDownMeshes
{
    [self.mesh tearDown];
    [self.confettiMesh tearDown];
    [self.shredderMesh tearDown];
}

- (void) tearDownTextures
{
    [super tearDownTextures];
    glDeleteTextures(1, &shredderTexture);
    shredderTexture = 0;
}

- (void) tearDownPrograms
{
    [super tearDownPrograms];
    glDeleteProgram(shredderProgram);
    shredderProgram = 0;
    glDeleteProgram(confettiProgram);
    confettiProgram = 0;
}
@end
