//
//  CubeAppDelegate.m
//  Cube
//
//  Created by Ian Terrell on 7/19/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "CubeAppDelegate.h"
#define M_TAU (2*M_PI)

@implementation CubeAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:context];
  
  GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds] context:context];
  view.delegate = self;
 
  GLKViewController *controller = [[GLKViewController alloc] init];
  controller.delegate = self;
  controller.view = view;
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = controller;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.5, 0.5, 0.5, 0.5);
  glClear(GL_COLOR_BUFFER_BIT);
  
  GLKVector3 vertices[] = {
    GLKVector3Make(-0.5, -0.5,  0.5), // Left  bottom front
    GLKVector3Make( 0.5, -0.5,  0.5), // Right bottom front
    GLKVector3Make( 0.5,  0.5,  0.5), // Right top    front
    GLKVector3Make(-0.5,  0.5,  0.5), // Left  top    front
    GLKVector3Make(-0.5, -0.5, -0.5), // Left  bottom back
    GLKVector3Make( 0.5, -0.5, -0.5), // Right bottom back
    GLKVector3Make( 0.5,  0.5, -0.5), // Right top    back
    GLKVector3Make(-0.5,  0.5, -0.5), // Left  top    back
  };
  
  GLKVector4 colors[] = {
    GLKVector4Make(1.0, 0.0, 0.0, 1.0), // Red
    GLKVector4Make(0.0, 1.0, 0.0, 1.0), // Green
    GLKVector4Make(0.0, 0.0, 1.0, 1.0), // Blue
    GLKVector4Make(0.0, 0.0, 0.0, 1.0), // Black
    GLKVector4Make(0.0, 0.0, 1.0, 1.0), // Blue
    GLKVector4Make(0.0, 0.0, 0.0, 1.0), // Black
    GLKVector4Make(1.0, 0.0, 0.0, 1.0), // Red
    GLKVector4Make(0.0, 1.0, 0.0, 1.0), // Green
  };
  
  GLKVector3 triangleVertices[] = {
    // Front
    vertices[0], vertices[1], vertices[2],
    vertices[0], vertices[2], vertices[3],
    // Right
    vertices[1], vertices[5], vertices[6],
    vertices[1], vertices[6], vertices[2],
    // Back
    vertices[5], vertices[4], vertices[7],
    vertices[5], vertices[7], vertices[6],
    // Left
    vertices[4], vertices[0], vertices[3],
    vertices[4], vertices[3], vertices[7],
    // Top
    vertices[3], vertices[2], vertices[6],
    vertices[3], vertices[6], vertices[7],
    // Bottom
    vertices[4], vertices[5], vertices[1],
    vertices[4], vertices[1], vertices[0],
  };
  
  GLKVector4 colorVertices[] = {
    // Front
    colors[0], colors[1], colors[2],
    colors[0], colors[2], colors[3],
    // Right
    colors[1], colors[5], colors[6],
    colors[1], colors[6], colors[2],
    // Back
    colors[5], colors[4], colors[7],
    colors[5], colors[7], colors[6],
    // Left
    colors[4], colors[0], colors[3],
    colors[4], colors[3], colors[7],
    // Top
    colors[3], colors[2], colors[6],
    colors[3], colors[6], colors[7],
    // Bottom
    colors[4], colors[5], colors[1],
    colors[4], colors[1], colors[0],
  };
  
  GLKBaseEffect *effect = [[GLKBaseEffect alloc] init];

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
  glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colorVertices);
  
  glDrawArrays(GL_TRIANGLES, 0, 36);
  
  glDisableVertexAttribArray(GLKVertexAttribPosition);
  glDisableVertexAttribArray(GLKVertexAttribColor);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
