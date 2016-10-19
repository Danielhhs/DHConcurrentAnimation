//
//  DHObjectClothLineAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectClothLineAnimation.h"
#import "DHObjectClothLineSceneMesh.h"
#import "DHAnimationSettings.h"
#import "NSBKeyframeAnimationFunctions.h"

@interface DHObjectClothLineAnimation () {
    GLuint offsetLoc, rotationMatrixLoc, transitionRatioLoc;
}
@property (nonatomic) CGPoint offset;
@property (nonatomic) NSInteger swingCycleCount;
@property (nonatomic) NSTimeInterval swingCycle;
@property (nonatomic) GLfloat attenuationPerCycle;
@property (nonatomic) GLfloat initialSwingAmplitude;
@end

#define TRANSITION_RATIO 0.3
#define MIN_SWING_CYCLE 0.382
#define INITIAL_SWING_AMPLITUDE (M_PI / 6)

@implementation DHObjectClothLineAnimation

- (NSString *) vertexShaderName
{
    return @"ObjectClothLineVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectClothLineFragment.glsl";
}

- (void) setupExtraUniforms
{
    offsetLoc = glGetUniformLocation(program, "u_offset");
    rotationMatrixLoc = glGetUniformLocation(program, "u_rotationMatrix");
    transitionRatioLoc = glGetUniformLocation(program, "u_transitionRatio");
}

- (void) setUpTargetGeometry
{
    [super setUpTargetGeometry];
    if (self.settings.direction == DHAnimationDirectionLeftToRight) {
        self.offset = CGPointMake(-self.targetOrigin.x - self.targetSize.width * 1.5, 0);
    } else {
        self.offset = CGPointMake(self.settings.animationView.bounds.size.width - self.targetOrigin.x + self.targetSize.width * 0.5, 0);
    }
    self.swingCycleCount = self.settings.duration * (1.f - TRANSITION_RATIO) / MIN_SWING_CYCLE;
    self.swingCycle = self.settings.duration * (1.f - TRANSITION_RATIO) / self.swingCycleCount;
    self.attenuationPerCycle = INITIAL_SWING_AMPLITUDE / self.swingCycleCount;
    self.initialSwingAmplitude = INITIAL_SWING_AMPLITUDE;
    if (self.settings.direction == DHAnimationDirectionLeftToRight) {
        self.initialSwingAmplitude *= -1;
    }
}

- (void) setupMeshes
{
    self.mesh = [[DHObjectClothLineSceneMesh alloc] initWithTarget:self.settings.targetView size:self.targetSize origin:self.targetOrigin columnCount:1 rowCount:1 columnMajored:YES rotate:NO];
    [self.mesh generateMeshesData];
}

- (void) drawFrame
{
    GLKMatrix4 rotationMatrix = [self rotationMatrix];
    glUniformMatrix4fv(rotationMatrixLoc, 1, GL_FALSE, rotationMatrix.m);
    glUniform2f(offsetLoc, self.offset.x, self.offset.y);
    glUniform1f(transitionRatioLoc, TRANSITION_RATIO);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(samplerLoc, 0);
    [self.mesh drawEntireMesh];
}

- (GLKMatrix4) rotationMatrix
{
    if (self.settings.event == DHAnimationEventBuiltIn) {
        return [self rotationMatrixForBuiltInEvent];
    } else {
        return [self rotationMatrixForBuiltOutEvent];
    }
}

- (GLKMatrix4) rotationMatrixForBuiltInEvent
{
    GLfloat rotation = 0.f;
    if (self.percent < TRANSITION_RATIO) {
        rotation = self.initialSwingAmplitude * self.percent / TRANSITION_RATIO;
    } else {
        CGFloat swingTime = self.elapsedTime - TRANSITION_RATIO * self.settings.duration;
        NSInteger currentCycle = swingTime / self.swingCycle;
        GLfloat currentAmplitude = INITIAL_SWING_AMPLITUDE - currentCycle * self.attenuationPerCycle;
        GLfloat nextAmplitude = INITIAL_SWING_AMPLITUDE - (currentCycle + 1) * self.attenuationPerCycle;
        NSTimeInterval timeInCycle = swingTime - currentCycle * self.swingCycle;
        GLfloat percentInCycle = timeInCycle / self.swingCycle;
        if (percentInCycle < 0.5) {
            percentInCycle = NSBKeyframeAnimationFunctionEaseInSine(timeInCycle * 1000, 0, 0.5, self.swingCycle / 2 * 1000);
        } else {
            percentInCycle = NSBKeyframeAnimationFunctionEaseOutSine((timeInCycle - self.swingCycle * 0.5) * 1000, 0, 0.5,  self.swingCycle / 2 * 1000) + 0.5;
        }
        NSInteger swingDirection = 1;
        if (self.settings.direction == DHAnimationDirectionLeftToRight) {
            swingDirection = 0;
        }
        if (currentCycle % 2 == swingDirection) {
            currentAmplitude *= -1;
        } else {
            nextAmplitude *= -1;
        }
        rotation = currentAmplitude + (nextAmplitude - currentAmplitude) * percentInCycle;
    }
    GLKMatrix4 transformMatrix = GLKMatrix4MakeTranslation(-self.targetOrigin.x - self.targetSize.width / 2, -self.targetSize.height - self.targetOrigin.y, 0);
    GLKMatrix4 rotationMatrix = GLKMatrix4Rotate(GLKMatrix4Identity, rotation, 0, 0, 1);
    GLKMatrix4 transformBackMatrix = GLKMatrix4Translate(GLKMatrix4Identity, self.targetOrigin.x + self.targetSize.width / 2, self.targetSize.height + self.targetOrigin.y, 0);
    GLKMatrix4 theMatrix = GLKMatrix4Multiply(transformBackMatrix, GLKMatrix4Multiply(rotationMatrix, transformMatrix));
    return theMatrix;
}

- (GLKMatrix4) rotationMatrixForBuiltOutEvent
{
    GLfloat rotation = self.percent * self.initialSwingAmplitude * -1;
    
    GLKMatrix4 transformMatrix = GLKMatrix4MakeTranslation(-self.targetOrigin.x - self.targetSize.width / 2, -self.targetSize.height - self.targetOrigin.y, 0);
    GLKMatrix4 rotationMatrix = GLKMatrix4Rotate(GLKMatrix4Identity, rotation, 0, 0, 1);
    GLKMatrix4 transformBackMatrix = GLKMatrix4Translate(GLKMatrix4Identity, self.targetOrigin.x + self.targetSize.width / 2, self.targetSize.height + self.targetOrigin.y, 0);
    GLKMatrix4 theMatrix = GLKMatrix4Multiply(transformBackMatrix, GLKMatrix4Multiply(rotationMatrix, transformMatrix));
    return theMatrix;
}

- (NSString *) description
{
    return @"Cloth Line";
}
@end
