//
//  DHAnimationEnums.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DHAnimationDirection) {
    DHAnimationDirectionLeftToRight,
    DHAnimationDirectionRightToLeft,
    DHAnimationDirectionTopToBottom,
    DHAnimationDirectionBottomToTop,
};

typedef NS_ENUM(NSInteger, DHAnimationEvent) {
    DHAnimationEventBuiltIn,
    DHAnimationEventBuiltOut,
};

typedef NS_ENUM(NSInteger, DHAnimationTriggerEvent) {
    DHAnimationTriggerEventByTap,
    DHAnimationTriggerEventByTime,
    DHAnimationTriggerEventStartSimutanously,
};

typedef NS_ENUM(NSInteger, DHTransitionType) {
    DHTransitionTypeNone,
};

typedef NS_ENUM(NSInteger, DHObjectAnimationType) {
    DHObjectAnimationTypeNone,
    DHObjectAnimationTypeClothLine,
    DHObjectAnimationTypeFold,
    DHObjectAnimationTypeScale,
    DHObjectAnimationTypeScaleBig,
    DHObjectAnimationTypeDrop,
    DHObjectAnimationTypeBlinds,
};

typedef NS_ENUM(NSInteger, DHTextAnimationType) {
    DHTextAnimationTypeNone,
};


@interface DHAnimationEnums : NSObject

@end
