//
//  DHShimmerEffect.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/24.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHParticleEffect.h"
#import "DHAnimationEnums.h"
@interface DHShimmerEffect : DHParticleEffect

@property (nonatomic, strong) NSArray *offsetData;
@property (nonatomic) DHAnimationEvent event;
@property (nonatomic) DHAnimationDirection direction;
- (instancetype) initWithContext:(EAGLContext *)context columnCount:(NSInteger)columnCount rowCount:(NSInteger)rowCount targetView:(UIView *)targetView containerView:(UIView *)containerView offsetData:(NSArray *)offsetData event:(DHAnimationEvent)event;
@end
