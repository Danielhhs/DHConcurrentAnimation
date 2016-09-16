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
    for (NSNumber *type in self.animations) {
        [self addAnimationOfType:[type intValue] event:DHAnimationEventBuiltIn];
    }
    [self.view addSubview:self.animationView];
    
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
    UIImageView *target = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    target.image = [self randomImage];
    target.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    target.contentMode = UIViewContentModeScaleToFill;
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
    [self.animationView display];
}

- (void) handleTapOnAnimationView:(DHAnimationView *)animationView
{
    [animationView playNextAnimation];
}
@end
