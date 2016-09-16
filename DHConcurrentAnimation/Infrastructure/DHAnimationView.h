//
//  DHAnimationView.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "DHAnimation.h"

@class DHAnimationView;
@protocol DHAnimationViewDelegate <GLKViewDelegate>

@optional
- (void) animationViewDidFinishPlayingAnimations:(DHAnimationView *)animationView;
- (void) handleTapOnAnimationView:(DHAnimationView *)animationView;

@end

@interface DHAnimationView : GLKView

@property (nonatomic) GLKMatrix4 modelMatrix;
@property (nonatomic) GLKMatrix4 viewMatrix;
@property (nonatomic) GLKMatrix4 projectionMatrix;
@property (nonatomic) GLKMatrix4 modelViewMatrix;
@property (nonatomic) GLKMatrix4 mvpMatrix;

@property (nonatomic, weak) id<DHAnimationViewDelegate> delegate;

- (void) setupGL;
- (void) draw;
- (void) addAnimation:(DHAnimation *)animation;
- (void) playNextAnimation;
- (void) stopCurrentAnimation;

@end
