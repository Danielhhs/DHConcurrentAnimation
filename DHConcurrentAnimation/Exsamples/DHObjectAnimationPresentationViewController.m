//
//  DHObjectAnimationPresentationViewController.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/13/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHObjectAnimationPresentationViewController.h"
#import <GLKit/GLKit.h>

@interface DHObjectAnimationPresentationViewController () <GLKViewDelegate>
@property (nonatomic, strong) GLKView *animationView;
@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic, strong) EAGLContext *context;
@end

@implementation DHObjectAnimationPresentationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.animations = [NSMutableArray array];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    self.animationView = [[GLKView alloc] initWithFrame:self.view.bounds context:self.context];
    self.animationView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
