//
//  DHAnimation.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimationSettings.h"
#import "DHAnimationSceneMesh.h"

@interface DHAnimation : NSObject {
    GLuint program;
    GLuint texture;
    GLuint mvpLoc, samplerLoc, timeLoc, durationLoc, directionLoc, eventLoc;
}
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) CGFloat percent;

@property (nonatomic, strong) DHAnimationSettings *settings;
@property (nonatomic) CGPoint targetOrigin;
@property (nonatomic) CGSize targetSize;
@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic, strong) DHAnimationSceneMesh *mesh;

#pragma mark - Public APIs
- (void) setupWithSettings:(DHAnimationSettings *)settings;
- (void) start;
- (void) stop;

- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval;
- (void) draw;

#pragma mark - For Overriding
- (NSString *)vertexShaderName;
- (NSString *)fragmentShaderName;
- (void) drawFrame;
- (void) setupMeshes;
- (void) setupTexture;
- (void) setupUniforms;

@end
