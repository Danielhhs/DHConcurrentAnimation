//
//  DHTextureLoader.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHTextureLoader.h"
#import <CoreText/CoreText.h>

@implementation DHTextureLoader

#define NUMBER_OF_GLYPHS_PER_LINE 10
#define TEXT_SPACE 10

#pragma mark - Load Texture From View
+ (GLuint) loadTextureWithView:(UIView *)view
{
    return [DHTextureLoader loadTextureWithView:view flipHorizontal:NO flipVertical:YES];
}

+ (GLuint) loadTextureWithView:(UIView *)view
                flipHorizontal:(BOOL)flipHorizontal
                  flipVertical:(BOOL) flipVertical
{
    return [DHTextureLoader loadTextureWithView:view rotate:YES flipHorizontal:flipHorizontal flipVertical:flipVertical];
}

+ (GLuint) loadTextureWithView:(UIView *)view
                        rotate:(BOOL)rotate
                flipHorizontal:(BOOL)flipHorizontal
                  flipVertical:(BOOL)flipVertical
{
    GLuint texture = [DHTextureLoader generateTexture];
    
    [DHTextureLoader drawView:view onTexture:texture rotate:rotate flipHorizontal:flipHorizontal flipVertical:flipVertical];
    
    return texture;
}

+ (void) drawView:(UIView *)view
        onTexture:(GLuint)texture
           rotate:(BOOL)rotate
   flipHorizontal:(BOOL)flipHorizontal
     flipVertical:(BOOL)flipVertical
{
    GLfloat screenScale = [UIScreen mainScreen].scale;
    GLfloat textureWidth = view.frame.size.width * screenScale;
    GLfloat textureHeight = view.frame.size.height * screenScale;
    [DHTextureLoader drawOnTexture:texture textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight drawBlock:^(CGContextRef context) {
        UIGraphicsPushContext(context);
        if (flipVertical) {
            CGContextTranslateCTM(context, 0, textureHeight);
            CGContextScaleCTM(context, 1, -1);
        }
        if (flipHorizontal) {
            CGContextTranslateCTM(context, textureWidth, 0);
            CGContextScaleCTM(context, -1, 1);
        }
        if (rotate) {
            CGFloat angle = atan(-view.transform.c / view.transform.a);
            if (angle > -M_PI && angle < 0) {
                CGContextTranslateCTM(context, 0, fabs(view.bounds.size.width * screenScale * sin(angle)));
            } else {
                CGContextTranslateCTM(context, view.bounds.size.height * sin(angle) * screenScale, 0);
            }
            CGContextRotateCTM(context, angle);
        }
        
        [view drawViewHierarchyInRect:CGRectMake(0, 0, textureWidth, textureHeight) afterScreenUpdates:YES];
        UIGraphicsPopContext();
    }];
}

#pragma mark - Load Texture From Image
+ (GLuint) loadTextureWithImage:(UIImage *)image
{
    return [DHTextureLoader loadTextureWithImage:image flipHorizontal:NO flipVertical:NO];
}

+ (GLuint) loadTextureWithImage:(UIImage *)image
                 flipHorizontal:(BOOL)flipHorizontal
                   flipVertical:(BOOL)flipVertical
{
    GLuint texture = [DHTextureLoader generateTexture];
    
    [DHTextureLoader drawImage:image onTexture:texture flipHorizontal:flipHorizontal flipVertical:flipVertical];
    
    return texture;
}

+ (void) drawImage:(UIImage *)image
         onTexture:(GLuint)texture
    flipHorizontal:(BOOL)flipHorizontal
      flipVertical:(BOOL)flipVertical
{
    GLfloat screenScale = [UIScreen mainScreen].scale;
    GLfloat textureWidth = image.size.width * screenScale;
    GLfloat textureHeight = image.size.height * screenScale;
    [DHTextureLoader drawOnTexture:texture textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight drawBlock:^(CGContextRef context) {
        UIGraphicsPushContext(context);
        CGContextSaveGState(context);
        if (flipVertical) {
            CGContextTranslateCTM(context, 0, textureHeight);
            CGContextScaleCTM(context, 1, -1);
        }
        if (flipHorizontal) {
            CGContextTranslateCTM(context, textureWidth, 0);
            CGContextScaleCTM(context, -1, 1);
        }
        CGContextDrawImage(context, CGRectMake(0, 0, textureWidth, textureHeight), image.CGImage);
        CGContextRestoreGState(context);
        UIGraphicsPopContext();
    }];
}

#pragma mark - Load Texture From AttributedString
+ (GLuint) loadTextureWithAttributedString:(NSAttributedString *)attributedString
{
    return [DHTextureLoader loadTextureWithAttributedString:attributedString flipHorizontal:NO flipVertical:YES];
}

+ (GLuint) loadTextureWithAttributedString:(NSAttributedString *)attributedString
                            flipHorizontal:(BOOL)flipHorizontal
                              flipVertical:(BOOL)flipVertical
{
    GLuint texture = [DHTextureLoader generateTexture];
    
    [DHTextureLoader drawAttributedString:attributedString onTexture:texture flipHorizontal:flipHorizontal flipVertical:flipVertical];
    
    return texture;
}

+ (void) drawAttributedString:(NSAttributedString *)attributedString
                    onTexture:(GLuint)texture
               flipHorizontal:(BOOL)flipHorizontal
                 flipVertical:(BOOL)flipVertical
{
    __block GLint maxGlyphWidth, maxGlyphHeight;
    maxGlyphWidth = maxGlyphHeight = 0;
    
    [attributedString enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, [attributedString length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        for (NSInteger i = 0; i < range.length; i++) {
            NSInteger index = range.location + i;
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[[attributedString string] substringWithRange:NSMakeRange(index, 1)] attributes:@{NSFontAttributeName : value}];
            CGRect boundingRect = [attrString boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesLineFragmentOrigin context:NULL];
            if (maxGlyphWidth < ceil(boundingRect.size.width)) {
                maxGlyphWidth = ceil(boundingRect.size.width);
            }
            if (maxGlyphHeight < ceil(boundingRect.size.height)) {
                maxGlyphHeight = ceil(boundingRect.size.height);
            }
        }
    }];
    
    size_t textureWidth = (maxGlyphWidth + TEXT_SPACE) * NUMBER_OF_GLYPHS_PER_LINE;
    size_t textureHeight = ([attributedString length] / NUMBER_OF_GLYPHS_PER_LINE + 1.5) * (maxGlyphHeight + TEXT_SPACE);
    
    [DHTextureLoader drawOnTexture:texture textureWidth:(size_t)textureWidth textureHeight:(size_t)textureHeight drawBlock:^(CGContextRef context) {
        UIGraphicsPushContext(context);
        CGContextSaveGState(context);
        if (flipVertical) {
            CGContextTranslateCTM(context, 0, textureHeight);
            CGContextScaleCTM(context, 1, -1);
        }
        if (flipHorizontal) {
            CGContextTranslateCTM(context, textureWidth, 0);
            CGContextScaleCTM(context, -1, 1);
        }
        for (NSInteger i = 0; i < [attributedString length]; i++) {
            CGPoint textPosition = [DHTextureLoader textPositionAtIndex:i inAttributedString:attributedString forGlyphWidth:maxGlyphWidth glyphHeight:maxGlyphHeight textureHeight:textureHeight];
            CGContextSetTextPosition(context, textPosition.x, textPosition.y);
            NSAttributedString *attrString = [attributedString attributedSubstringFromRange:NSMakeRange(i, 1)];
            [attrString drawAtPoint:textPosition];
        }
        
        CGContextRestoreGState(context);
        UIGraphicsPopContext();
    }];
}

+ (CGPoint) textPositionAtIndex:(NSInteger)index
             inAttributedString:(NSAttributedString *)attributedString
                  forGlyphWidth:(CGFloat)glyphWidth
                    glyphHeight:(CGFloat)glyphHeight
                  textureHeight:(CGFloat)textureHeight
{
    NSInteger column = index % NUMBER_OF_GLYPHS_PER_LINE;
    NSInteger row = index / NUMBER_OF_GLYPHS_PER_LINE;
    CGFloat x = (glyphWidth + TEXT_SPACE) * column;
    CGFloat y = (glyphHeight + TEXT_SPACE) * (row);
    return CGPointMake(x, y);
}

#pragma mark - Util Methods
+ (GLuint) generateTexture
{
    GLuint texture;
    glGenTextures(1, &texture);
    
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    return texture;
}

+ (void) drawOnTexture:(GLuint)texture
     textureWidth:(size_t)textureWidth
    textureHeight:(size_t)textureHeight
        drawBlock:(void(^)(CGContextRef))drawBlock
{
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = textureWidth * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, textureWidth, textureHeight, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    drawBlock(context);
    GLubyte *data = CGBitmapContextGetData(context);
    UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)textureWidth, (GLsizei)textureHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    CGContextRelease(context);
}

@end
