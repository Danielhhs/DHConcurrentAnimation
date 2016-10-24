//
//  DHShredderPieceSceneMesh.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 16/10/19.
//  Copyright © 2016年 cn.daniel. All rights reserved.
//

#import "DHAnimationSceneMesh.h"

@interface DHShredderPieceSceneMesh : DHAnimationSceneMesh
@property (nonatomic) NSInteger numberOfColumns;

- (instancetype) initWithTargetView:(UIView *)targetView containerView:(UIView *)containerView columnCount:(NSInteger)columnCount;
@end
