//
//  DHAnimation.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimationSceneMesh.h"
#import "DHAnimationSettings.h"

@class DHAnimation;
@protocol DHAnimationDelegate <NSObject>

- (void) animationDidStop:(DHAnimation *)animation;
- (void) animationDidFinishSettingUp:(DHAnimation *)animation;

@end

@interface DHAnimation : NSObject {
    GLuint program;
    GLuint texture;
    GLuint mvpLoc, samplerLoc, timeLoc, durationLoc, directionLoc, eventLoc, percentLoc;
}
@property (nonatomic, readonly) BOOL readyToAnimate;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) CGFloat percent;

@property (nonatomic, strong) DHAnimationSettings *settings;
@property (nonatomic) CGPoint targetOrigin;
@property (nonatomic) CGSize targetSize;
@property (nonatomic) GLKMatrix4 mvpMatrix;
@property (nonatomic, strong) DHAnimationSceneMesh *mesh;

@property (nonatomic, weak) id<DHAnimationDelegate> delegate;

#pragma mark - Public APIs
- (void) setupWithSettings:(DHAnimationSettings *)settings;
- (void) start;
- (void) stop;

- (void) draw;

#pragma mark - For Overriding
- (NSString *)vertexShaderName;
- (NSString *)fragmentShaderName;
- (void) drawFrame;
- (void) setUpTargetGeometry;
- (void) setupMeshes;
- (void) setupTexture;
- (void) setupUniforms;
- (void) updateWithTimeInterval:(NSTimeInterval)timeInterval;

@end
