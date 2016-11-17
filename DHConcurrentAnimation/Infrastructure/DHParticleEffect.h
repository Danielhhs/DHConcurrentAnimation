//
//  DHParticleEffect.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/24.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHParticleEffect : NSObject {
    GLuint program;
    GLuint texture, backgroundTexture;
    GLuint vertexBuffer;
    GLuint vertexArray;
    GLuint mvpLoc, samplerLoc, percentLoc, directionLoc, eventLoc, elapsedTimeLoc, backgroundSamplerLoc;
}

@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic) GLfloat percent;
@property (nonatomic, weak) UIView *targetView;
@property (nonatomic, weak) UIView *containerView;

@property (nonatomic, weak) EAGLContext *context;
@property (nonatomic, strong) NSString *vertexShaderName;
@property (nonatomic, strong) NSString *fragmentShaderName;
@property (nonatomic, strong) NSString *particleImageName;
@property (nonatomic, strong) NSMutableData *particleData;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;

- (void) prepareToDraw;
- (void) draw;
- (void) setupGL;
- (void) setupExtraUniforms;
- (void) setupTextures;
- (void) generateParticleData;
- (instancetype) initWithContext:(EAGLContext *)context;
- (void) updateWithElapsedTime:(NSTimeInterval)elapsedTime percent:(GLfloat)percent;
- (GLKVector3) rotatedPosition:(GLKVector3)position;

- (void) tearDownGL;

@end
