//
//  DHProgramLoader.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface DHProgramLoader : NSObject

+ (GLuint) loadProgramWithVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;

@end
