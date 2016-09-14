//
//  DHAnimationSceneMesh.h
//  DHConcurrentAnimation
//
//  Created by Huang Hongsen on 9/9/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>

typedef struct {
    GLKVector3 position;
    GLKVector2 texCoords;
}DHSceneGeometryAttribtues;

//DO NOT inherit this class directly. You can choose to override either DHAnimationSplitSceneMesh or DHAnimationContinousSceneMesh.
@interface DHAnimationSceneMesh : NSObject {
    GLuint vertexBuffer, indexBuffer;
    GLuint vertexArray;
    GLuint *indices;
    DHSceneGeometryAttribtues *geometryAttribtues;
}

@property (nonatomic, strong) NSData *vertexData;
@property (nonatomic, strong) NSData *indexData;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;
@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) NSInteger indexCount;
@property (nonatomic) NSInteger columnCount;
@property (nonatomic) NSInteger rowCount;
@property (nonatomic) BOOL columnMajored;
@property (nonatomic) BOOL rotate;

/**
 * Designated Initializer
 *
 * @param size: size of the target --> get it from the frame.size of your animation target;
 * @param origin: origin of the target --> get the bottom-left cornor coordinates for your animation target;
 * @param columnCount: columnCount of your animation;
 * @param rowCount: rowCount of your animation;
 * @param columnMajored: YES if the scene is columnMajored, NO if the scene is rowMajored;
 * @param rotate: If your target has been rotated, YES would mean to transform the position of each vertex, NO means just as a normal rectangle;
 */
- (instancetype) initWithTargetSize:(CGSize)size
                             origin:(CGPoint)origin
                        columnCount:(NSInteger)columnCount
                           rowCount:(NSInteger)rowCount
                      columnMajored:(BOOL)columnMajored
                             rotate:(BOOL)rotate;

#pragma mark - Public APIs
/**
 * Overridable
 *
 * Call this method to generate mesh data.
 * Usually you call this method after all properties are well set.
 *
 * If you have any other vertex attributes to set up, you need to override this method.
 */
- (void) generateMeshesData;

/**
 * Overridable
 *
 * Call this method to generate vertexBuffer, indexBuffer and vertexArray for drawing.
 * Default implementation will generate vertex buffer, index buffer and vertex array; But only the geometry attributes will be enabled and transferred to GPU;
 * If you have more vertex attributes to set up, please override "enableExtraVertexAttributes" to set up;
 * You Also need to implement "attributesStride" method to provide the stride;
 *
 * If you don't want the default implementation, like if you have to update value while animation, you could not use vertex array. Then you can override this method and provide your own implementation;
 */
- (void) prepareToDraw;

/**
 * Overridable
 *
 * Call this method to draw the entire mesh.
 * Default implementation is just to draw the indices as GL_TRIANGLE.
 */
- (void) drawEntireMesh;

#pragma mark - For Overriding
/**
 * Override this method to enable extra vertex attributes other than geometry attributes;
 */
- (void)enableExtraVertexAttributes;

/**
 * Override this method to provide the stride of your scene mesh attributes;
 */
- (GLsizei) attributesStride;

#pragma mark - For SubClasses calling
//Call this method to generate geometry attributes from SubClass implementation
//The generated attributes could be retrieved from "geometryAttributes"
- (void) generateGeometryAttributes;

//Call this method to generate
- (void) generateIndicesData;

@end
