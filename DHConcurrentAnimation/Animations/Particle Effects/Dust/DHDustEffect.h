//
//  DHDustEffect.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/11/22.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

typedef NS_ENUM(NSInteger, DHDustEffectDirection) {
    DHDustEffectDirectionLeftToRight,
    DHDustEffectDirectionRightToLeft,
};

typedef struct {
    GLKVector3 startPosition;
    GLKVector3 targetPosition;
    GLfloat startPointSize;
    GLfloat targetPointSize;
    GLfloat rotation;
    GLfloat aLifeTime;
}DHDustEffectAttributes;

@interface DHDustEffect : DHParticleEffect

@property (nonatomic) DHDustEffectDirection direction;
@property (nonatomic) GLKVector3 emitPosition;
@property (nonatomic) GLfloat dustWidth;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) GLfloat emissionRadius;

@end
