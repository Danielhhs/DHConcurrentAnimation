//
//  DHShredderConffetiSceneMesh.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/19.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHAnimationSplitSceneMesh.h"

@interface DHShredderConffetiSceneMesh : DHAnimationSplitSceneMesh
- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView;
- (void) appendConfettiAtPosition:(GLKVector3)position length:(GLfloat)length startFallingTime:(GLfloat)startFallingTime;
@end
