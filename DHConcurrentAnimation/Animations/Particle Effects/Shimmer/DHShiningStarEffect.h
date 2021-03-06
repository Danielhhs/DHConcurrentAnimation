//
//  DHShiningStarEffect.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/24.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"

@interface DHShiningStarEffect : DHParticleEffect
- (instancetype) initWithContext:(EAGLContext *)context starImage:(UIImage *)starImage targetView:(UIView *)targetView containerView:(UIView *)containerView duration:(NSTimeInterval) duration starsPerSecond:(NSInteger) starsPerSecond starLifeTime:(NSTimeInterval)starLifeTime;
@end
