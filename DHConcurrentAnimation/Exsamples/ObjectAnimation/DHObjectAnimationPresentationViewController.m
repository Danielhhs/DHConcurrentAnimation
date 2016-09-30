//
//  DHObjectAnimationPresentationViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationPresentationViewController.h"
#import "DHAnimationView.h"
@interface DHObjectAnimationPresentationViewController () <DHAnimationViewDelegate>

@property (nonatomic, strong) DHAnimationView *animationView;

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval elapsedTime;

@property(nonatomic, strong) NSMutableArray *animationTargets;
@end

@implementation DHObjectAnimationPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.animationView = [[DHAnimationView alloc] initWithFrame:self.view.bounds context:self.context];
    self.animationView.delegate = self;
    for (DHAnimation *animation in self.animations) {
        UIView *animationTarget = [self randomAnimationTarget];
        [self.animationTargets addObject:animationTarget];
        animation.settings.targetView = animationTarget;
        animation.settings.animationView = self.animationView;
        animation.mvpMatrix = self.animationView.mvpMatrix;
        [self.animationView addAnimation:animation];
        [animation setup];
    }
    [self.view addSubview:self.animationView];
    [self.animationView startAnimating];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) addAnimationOfType:(DHObjectAnimationType)type event:(DHAnimationEvent)event
{
    UIImageView *animationTarget = [self randomAnimationTarget];
    DHAnimation *animation = [DHAnimationFactory animationOfType:type event:event forTarget:animationTarget animationView:self.animationView];
    
    animation.mvpMatrix = self.animationView.mvpMatrix;
    
    [self.animationView addAnimation:animation];
}

- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0, 0, 0, 0);
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glViewport(0, 0, (GLsizei)view.drawableWidth, (GLsizei)view.drawableHeight);
    
    [self.animationView draw];
}

- (UIImageView *) randomAnimationTarget
{
    CGRect randomRect = CGRectMake(0, 0, arc4random() % 50 + 100, arc4random() % 150 + 75);
    UIImageView *target = [[UIImageView alloc] initWithFrame:randomRect];
    target.image = [self randomImage];
    CGPoint randomCenter = CGPointMake(randomRect.size.width / 2 + arc4random() % (int)(self.view.bounds.size.width - randomRect.size.width), randomRect.size.height / 2 + arc4random() % (int)(self.view.bounds.size.height - randomRect.size.height));
    target.center = randomCenter;
    target.contentMode = UIViewContentModeScaleToFill;
    GLfloat angle = arc4random() % 100 / 100.f * M_PI * 2;
    target.transform = CGAffineTransformMakeRotation(angle);
    return target;
}

- (UIImage *)randomImage
{
    int randomNumber = arc4random() % 10;
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", randomNumber]];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    [self.animationView updateWithTimeInterval:displayLink.duration];
    [self.animationView display];
}

- (void) handleTapOnAnimationView:(DHAnimationView *)animationView
{
    [animationView playNextAnimation];
}

- (NSMutableArray *) animationTargets
{
    if (!_animationTargets) {
        _animationTargets = [NSMutableArray array];
    }
    return _animationTargets;
}

@end
