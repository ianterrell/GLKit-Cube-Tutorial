//
//  ColorfulCube.m
//  Cube
//
//  Created by Ian Terrell on 7/19/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "ColorfulCube.h"
#define M_TAU (2*M_PI)

static BOOL initialized = NO;
static GLKVector3 vertices[8];
static GLKVector4 colors[8];
static GLKVector3 triangleVertices[36];
static GLKVector4 triangleColors[36];
static GLKBaseEffect *effect;

@implementation ColorfulCube

- (id)init
{
  self = [super init];
  if (self) {
      // Initialization code here.
  }
  
  return self;
}

+ (void)initialize {
  if (!initialized) {
    vertices[0] = GLKVector3Make(-0.5, -0.5,  0.5); // Left  bottom front
    vertices[1] = GLKVector3Make( 0.5, -0.5,  0.5); // Right bottom front
    vertices[2] = GLKVector3Make( 0.5,  0.5,  0.5); // Right top    front
    vertices[3] = GLKVector3Make(-0.5,  0.5,  0.5); // Left  top    front
    vertices[4] = GLKVector3Make(-0.5, -0.5, -0.5); // Left  bottom back
    vertices[5] = GLKVector3Make( 0.5, -0.5, -0.5); // Right bottom back
    vertices[6] = GLKVector3Make( 0.5,  0.5, -0.5); // Right top    back
    vertices[7] = GLKVector3Make(-0.5,  0.5, -0.5); // Left  top    back
    
    colors[0] = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Red
    colors[1] = GLKVector4Make(0.0, 1.0, 0.0, 1.0); // Green
    colors[2] = GLKVector4Make(0.0, 0.0, 1.0, 1.0); // Blue
    colors[3] = GLKVector4Make(0.0, 0.0, 0.0, 1.0); // Black
    colors[4] = GLKVector4Make(0.0, 0.0, 1.0, 1.0); // Blue
    colors[5] = GLKVector4Make(0.0, 0.0, 0.0, 1.0); // Black
    colors[6] = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Red
    colors[7] = GLKVector4Make(0.0, 1.0, 0.0, 1.0); // Green
    
    int vertexIndices[36] = {
      // Front
      0, 1, 2,
      0, 2, 3,
      // Right
      1, 5, 6,
      1, 6, 2,
      // Back
      5, 4, 7,
      5, 7, 6,
      // Left
      4, 0, 3,
      4, 3, 7,
      // Top
      3, 2, 6,
      3, 6, 7,
      // Bottom
      4, 5, 1,
      4, 1, 0,
    };
    
    for (int i = 0; i < 36; i++) {
      triangleVertices[i] = vertices[vertexIndices[i]];
      triangleColors[i] = colors[vertexIndices[i]];
    }
    
    effect = [[GLKBaseEffect alloc] init];
    
    initialized = YES;
  }
}

- (void)draw
{
  GLKMatrix4 yRotation = GLKMatrix4MakeYRotation(1.0/8.0*M_TAU);
  GLKMatrix4 xRotation = GLKMatrix4MakeXRotation(1.0/8.0*M_TAU);
  GLKMatrix4 scale = GLKMatrix4MakeScale(0.5, 0.5, 0.5);
  GLKMatrix4 translate = GLKMatrix4MakeTranslation(0, 0.5, 0);
  
  GLKMatrix4 modelMatrix = GLKMatrix4Multiply(translate,GLKMatrix4Multiply(scale,GLKMatrix4Multiply(xRotation, yRotation)));
  GLKMatrix4 viewMatrix = GLKMatrix4MakeLookAt(0, 0, 3, 0, 0, 0, 0, 1, 0);
  effect.transform.modelviewMatrix = GLKMatrix4Multiply(viewMatrix, modelMatrix);
  
  effect.transform.projectionMatrix = GLKMatrix4MakePerspective(0.125*M_TAU, 1.0, 2, -1);
  
  [effect prepareToDraw];
  
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  
  glEnableVertexAttribArray(GLKVertexAttribPosition);
  glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, triangleVertices);
  
  glEnableVertexAttribArray(GLKVertexAttribColor);
  glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, triangleColors);
  
  glDrawArrays(GL_TRIANGLES, 0, 36);
  
  glDisableVertexAttribArray(GLKVertexAttribPosition);
  glDisableVertexAttribArray(GLKVertexAttribColor);
}

@end
