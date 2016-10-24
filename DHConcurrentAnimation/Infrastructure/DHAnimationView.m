//
//  DHAnimationView.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationView.h"

@interface DHAnimationView ()<DHAnimationDelegate>

@property (nonatomic, strong, readwrite) NSMutableArray *animations;
@property (nonatomic) NSInteger currentAnimationIndex;
@property (nonatomic, strong) NSMutableArray *playingAnimations;
@property (nonatomic, strong) NSMutableArray *stoppedAnimations;

@property (nonatomic) BOOL waitingForNextAnimationToPlay;
@end

@implementation DHAnimationView

@dynamic delegate;

#pragma mark - Set up
- (instancetype) initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    self = [super initWithFrame:frame context:context];
    if (self) {
        self.drawableMultisample = GLKViewDrawableMultisample4X;
        [self setupMvpMatrix];
        self.animations = [NSMutableArray array];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(handleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) setupMvpMatrix
{
    self.modelMatrix = GLKMatrix4MakeTranslation(-self.bounds.size.width / 2, -self.bounds.size.height / 2, -self.bounds.size.height / 2 / tan(M_PI / 24));
    self.viewMatrix = GLKMatrix4MakeLookAt(0, 0, 1, 0, 0, 0, 0, 1, 0);
    self.projectionMatrix = GLKMatrix4MakePerspective(M_PI / 12, self.bounds.size.width / self.bounds.size.height, 0.1, 10000);
    self.modelViewMatrix = GLKMatrix4Multiply(self.viewMatrix, self.modelMatrix);
    self.mvpMatrix = GLKMatrix4Multiply(self.projectionMatrix, self.modelViewMatrix);
}

#pragma mark - Public APIs
- (void) startAnimating
{
    [self playNextTriggeredByTimeAnimationForAnimationAtIndex:-1];
}

- (void) addAnimation:(DHAnimation *)animation
{
    animation.delegate = self;
    [self.animations addObject:animation];
    if (animation.settings.event == DHAnimationEventBuiltOut) {
        [self addSubview:animation.settings.targetView];
    }
}

- (void) playNextAnimation
{
    if (self.currentAnimationIndex >= [self.animations count]) {
        if ([self.delegate respondsToSelector:@selector(animationViewDidFinishPlayingAnimations:)]) {
            [self.delegate animationViewDidFinishPlayingAnimations:self];
        }
    } else {
        DHAnimation *currentAnimation = self.animations[self.currentAnimationIndex];
        [self playAnimation:currentAnimation];
    }
}

- (void) playSimutaneousTriggeredAnimations
{
    if (self.currentAnimationIndex < [self.animations count]) {
        DHAnimation *nextAnimation = self.animations[self.currentAnimationIndex];
        if (nextAnimation.settings.triggerEvent == DHAnimationTriggerEventStartSimutanously) {
            [self playAnimation:nextAnimation];
            [self playSimutaneousTriggeredAnimations];
        }
    }
}

- (void) playAnimation:(DHAnimation *)animation
{
    if ([animation readyToAnimate] == YES) {
        [animation start];
        [self.playingAnimations addObject:animation];
        self.currentAnimationIndex++;
        [self playSimutaneousTriggeredAnimations];
    } else {
        self.waitingForNextAnimationToPlay = YES;
    }
}

- (void) playNextTriggeredByTimeAnimationForAnimationAtIndex:(NSInteger)index
{
    index += 1;
    if (index < [self.animations count]) {
        DHAnimation *nextAnimation = self.animations[index];
        if (nextAnimation.settings.triggerEvent == DHAnimationTriggerEventByTime) {
            [self performSelector:@selector(playNextAnimation) withObject:nil afterDelay:nextAnimation.settings.triggerTime];
        }
    }
}

- (void) stopCurrentAnimation
{
    DHAnimation *currentAnimation = self.animations[self.currentAnimationIndex];
    [currentAnimation stop];
}

#pragma mark - Event Handling
- (void) handleTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(handleTapOnAnimationView:)]) {
        [self.delegate handleTapOnAnimationView:self];
    }
}

#pragma mark - Drawing
- (void) draw
{
    for (DHAnimation *animation in self.playingAnimations) {
        [animation draw];
    }
}

- (void) updateWithTimeInterval:(NSTimeInterval)interval
{
    for (DHAnimation *animation in self.playingAnimations) {
        [animation updateWithTimeInterval:interval];
    }
    [self.playingAnimations removeObjectsInArray:self.stoppedAnimations];
    [self.stoppedAnimations removeAllObjects];
}


#pragma mark - Lazy Instantiations
- (NSArray *) animationsArray
{
    return [self.animations copy];
}

- (NSMutableArray *) playingAnimations
{
    if (!_playingAnimations) {
        _playingAnimations = [NSMutableArray array];
    }
    return _playingAnimations;
}

- (NSMutableArray *) stoppedAnimations
{
    if (!_stoppedAnimations) {
        _stoppedAnimations = [NSMutableArray array];
    }
    return _stoppedAnimations;
}

#pragma mark - DHAnimationDelegate
- (void) animationDidStop:(DHAnimation *)animation
{
    [self.stoppedAnimations addObject:animation];
    NSInteger animationIndex = [self.animations indexOfObject:animation];
    [self playNextTriggeredByTimeAnimationForAnimationAtIndex:animationIndex];
}

- (void) animationDidFinishSettingUp:(DHAnimation *)animation
{
    DHAnimation *nextAnimation = self.animations[self.currentAnimationIndex];
    if ([animation isEqual:nextAnimation] && self.waitingForNextAnimationToPlay == YES) {
        [self playNextAnimation];
        self.waitingForNextAnimationToPlay = NO;
    }
}


@end
