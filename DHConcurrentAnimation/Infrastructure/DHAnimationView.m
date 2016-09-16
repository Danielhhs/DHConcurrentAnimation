//
//  DHAnimationView.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHAnimationView.h"

@interface DHAnimationView ()<DHAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic) NSInteger currentAnimationIndex;

@end

@implementation DHAnimationView

@dynamic delegate;

- (instancetype) initWithFrame:(CGRect)frame context:(EAGLContext *)context
{
    self = [super initWithFrame:frame context:context];
    if (self) {
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

- (void) addAnimation:(DHAnimation *)animation
{
    animation.delegate = self;
    [self.animations addObject:animation];
}

- (void) playNextAnimation
{
    if (self.currentAnimationIndex == [self.animations count]) {
        if ([self.delegate respondsToSelector:@selector(animationViewDidFinishPlayingAnimations:)]) {
            [self.delegate animationViewDidFinishPlayingAnimations:self];
        }
    } else {
        //TO-DO: Deal with multiple animation start simutaniously
        DHAnimation *nextAnimation = self.animations[self.currentAnimationIndex];
        [nextAnimation start];
        self.currentAnimationIndex++;
    }
}

- (void) stopCurrentAnimation
{
    DHAnimation *currentAnimation = self.animations[self.currentAnimationIndex];
    [currentAnimation stop];
}

- (void) handleTap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(handleTapOnAnimationView:)]) {
        [self.delegate handleTapOnAnimationView:self];
    }
}

- (void) setupGL
{
    
}

- (void) draw
{
    for (DHAnimation *animation in self.animations) {
        [animation draw];
    }
}

#pragma mark - DHAnimationDelegate
- (void) animationDidStop:(DHAnimation *)animation
{
    [self.animations removeObject:animation];
}

@end
