//
//  DHShimmerAnimation.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/24.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHObjectShimmerAnimation.h"

#import <OpenGLES/ES3/glext.h>
#import "DHShimmerSceneMesh.h"
#import "DHShimmerEffect.h"
#import "DHShiningStarEffect.h"

@interface DHObjectShimmerAnimation ()

@property (nonatomic, strong) NSMutableData *shiningStarData;
@property (nonatomic) NSInteger numberOfParticles;
@property (nonatomic, strong) DHShimmerSceneMesh *shimmerBackgroundMesh;
@property (nonatomic, strong) DHShimmerEffect *shimmerEffect;
@property (nonatomic, strong) DHShiningStarEffect *starEffect;
@property (nonatomic, strong) NSMutableArray *offsetData;
@end

@implementation DHObjectShimmerAnimation

#pragma mark - Setup GL
- (void) setupExtraUniforms
{
    [self generateOffsetData];
}

#pragma mark - Setup Meshes

- (void) setupMeshes
{
    self.shimmerBackgroundMesh = [[DHShimmerSceneMesh alloc] initWithTarget:self.settings.targetView size:self.targetSize origin:self.targetOrigin columnCount:self.settings.columnCount rowCount:self.settings.rowCount columnMajored:YES rotate:YES];
    self.shimmerBackgroundMesh.offsetData = self.offsetData;
    [self.shimmerBackgroundMesh generateMeshesData];
}

#pragma mark - Setup Effects
- (void) setupEffects
{
    [self setupShimmerEffect];
    [self setupShiningStarEffect];
}

- (void) setupShimmerEffect
{
    self.shimmerEffect = [[DHShimmerEffect alloc] initWithContext:self.context columnCount:self.settings.columnCount rowCount:self.settings.rowCount targetView:self.settings.targetView containerView:self.settings.animationView offsetData:self.offsetData event:self.settings.event];
    self.shimmerEffect.mvpMatrix = self.mvpMatrix;
    [self.shimmerEffect generateParticleData];
}

- (GLfloat) randomOffset
{
    int random = (arc4random() % 500 - 250);
    return random;
}


- (void) generateOffsetData
{
    self.offsetData = [NSMutableArray array];
    for (int x = 0; x < self.settings.columnCount; x++) {
        for (int y = 0; y < self.settings.rowCount; y++) {
            [self.offsetData addObject:@([self randomOffset])];
            [self.offsetData addObject:@([self randomOffset])];
            [self.offsetData addObject:@([self randomOffset])];
        }
    }
}

- (void) setupShiningStarEffect
{
    self.starEffect = [[DHShiningStarEffect alloc] initWithContext:self.context starImage:[UIImage imageNamed:@"star_white.png"] targetView:self.settings.targetView containerView:self.settings.animationView duration:self.settings.duration starsPerSecond:6 starLifeTime:0.382];
    self.starEffect.mvpMatrix = self.mvpMatrix;
}

#pragma mark - Update
- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval
{
    [super updateWithTimeInterval:timeInterval];
    self.percent = self.elapsedTime / self.settings.duration;
    self.shimmerEffect.percent = self.percent;
    self.starEffect.elapsedTime = self.elapsedTime;
}

#pragma mark - Drawing
- (void) drawFrame
{
    glUseProgram(program);
    glUniformMatrix4fv(mvpLoc, 1, GL_FALSE, self.mvpMatrix.m);
    [self.shimmerBackgroundMesh prepareToDraw];
    glUniform1f(percentLoc, self.percent);
    glUniform1f(eventLoc, self.settings.event);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1f(samplerLoc, 0);
    [self.shimmerBackgroundMesh drawEntireMesh];
    
    [self.shimmerEffect draw];
    
    [self.starEffect draw];
}

- (NSString *) vertexShaderName
{
    return @"ObjectShimmerVertex.glsl";
}

- (NSString *) fragmentShaderName
{
    return @"ObjectShimmerFragment.glsl";
}
@end
