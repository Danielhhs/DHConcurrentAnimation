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
@property (nonatomic, readonly) NSArray *animationsArray;

@property (nonatomic, weak) id<DHAnimationViewDelegate> delegate;

//Calling this method will start a timer if the first animation is triggered by time;
//If the first animation is not triggered by time, then do nothing;
- (void) startAnimating;
- (void) draw;
- (void) updateWithTimeInterval:(NSTimeInterval)interval;
- (void) addAnimation:(DHAnimation *)animation;
- (void) playNextAnimation;
- (void) stopCurrentAnimation;

@end
