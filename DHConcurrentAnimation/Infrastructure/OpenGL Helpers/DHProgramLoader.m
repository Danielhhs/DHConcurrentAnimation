//
//  DHProgramLoader.m
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/7/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "DHProgramLoader.h"

@implementation DHProgramLoader

+ (GLuint) loadProgramWithVertexShader:(NSString *)vertexShaderPath fragmentShader:(NSString *)fragmentShaderPath
{
    GLuint program = glCreateProgram();
    
    GLuint vertexShader = [DHProgramLoader loadShaderOfType:GL_VERTEX_SHADER shaderSource:vertexShaderPath];
    GLuint fragmentShader = [DHProgramLoader loadShaderOfType:GL_FRAGMENT_SHADER shaderSource:fragmentShaderPath];
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    glLinkProgram(program);
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    GLint status;
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status != GL_TRUE) {
        GLint errorLogLength;
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &errorLogLength);
        GLchar *errorLog = malloc(errorLogLength * sizeof(GLchar));
        glGetProgramInfoLog(program, errorLogLength, NULL, errorLog);
        NSLog(@"Fail to link program due to %s", errorLog);
        glDeleteProgram(program);
        return 0;
    }
    
    return program;
}

+ (GLuint) loadShaderOfType:(GLenum)shaderType shaderSource:(NSString *)shaderSourceFile
{
    GLuint shader = glCreateShader(shaderType);
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *sourceFilePath = [[bundle resourcePath] stringByAppendingPathComponent:shaderSourceFile];
    const char *source = [[NSString stringWithContentsOfFile:sourceFilePath encoding:NSUTF8StringEncoding error:NULL] cStringUsingEncoding:NSUTF8StringEncoding];
    
    glShaderSource(shader, 1, &source, NULL);
    glCompileShader(shader);
    
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status != GL_TRUE) {
        GLint errorLogLength;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &errorLogLength);
        GLchar *errorLog = malloc(errorLogLength * sizeof(GLchar));
        glGetShaderInfoLog(shader, errorLogLength, NULL, errorLog);
        NSString *shaderTypeName = (shaderType == GL_VERTEX_SHADER) ? @"Vertex Shader" : @"FragmentShader";
        NSLog(@"Fail to compile %@ for %s", shaderTypeName, errorLog);
    }
    
    return shader;
}

@end
