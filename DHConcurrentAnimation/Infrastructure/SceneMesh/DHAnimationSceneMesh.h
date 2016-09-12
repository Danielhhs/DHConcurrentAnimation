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
    GLKVector2 texture;
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

/**
 * Designated Initializer
 *
 * @param size: size of the target --> get it from the frame.size of your animation target;
 * @param origin: origin of the target --> get the bottom-left cornor coordinates for your animation target;
 * @param columnCount: columnCount of your animation;
 * @param rowCount: rowCount of your animation;
 * @param splitTexture: Whether the scene is continuous or splitted;
 * @param columnMajored: YES if the scene is columnMajored, NO if the scene is rowMajored;
 * @param rotate: If your target has been rotated, YES would mean to transform the position of each vertex, NO means just as a normal rectangle;
 */
- (instancetype) initWithTargetSize:(CGSize)size
                             origin:(CGPoint)origin
                        columnCount:(NSInteger)columnCount
                           rowCount:(NSInteger)rowCount
                       splitTexture:(BOOL)splitTexture
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
 * Call this method to draw the entire mesh.
 * Default implementation is just to draw the indices as GL_TRIANGLE.
 */
- (void) drawEntireMesh;

#pragma mark - For Overriding

/**
 * Override this method to generate vertexBuffer, indexBuffer and vertexArray for drawing.
 */
- (void) prepareToDraw;

#pragma mark - For SubClasses calling
//Call this method to generate geometry attributes from SubClass implementation
//The generated attributes could be retrieved from "geometryAttributes"
- (void) generateGeometryAttributes;

@end
