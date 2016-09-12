//
//  DHTextureLoader.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHTextureLoader : NSObject

+ (GLuint) loadTextureWithView:(UIView *)view;
+ (GLuint) loadTextureWithView:(UIView *)view
                flipHorizontal:(BOOL)flipHorizontal
                  flipVertical:(BOOL) flipVertical;
+ (GLuint) loadTextureWithView:(UIView *)view
                        rotate:(BOOL)rotate
                flipHorizontal:(BOOL)flipHorizontal
                  flipVertical:(BOOL)flipVertical;

+ (GLuint) loadTextureWithImage:(UIImage *)image;
+ (GLuint) loadTextureWithImage:(UIImage *)image
                 flipHorizontal:(BOOL)flipHorizontal
                   flipVertical:(BOOL)flipVertical;

+ (GLuint) loadTextureWithAttributedString:(NSAttributedString *)attributedString;

@end
