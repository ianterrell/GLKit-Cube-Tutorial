//
//  CubeAppDelegate.m
//  Cube
//
//  Created by Ian Terrell on 7/19/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import "CubeAppDelegate.h"
#import "ColorfulCube.h"

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
  
  cubes = [[NSMutableArray alloc] init];
  
  ColorfulCube *cube = [[ColorfulCube alloc] init];
  cube.position = GLKVector3Make(0.25, 0.25, 0.0);
  cube.scale = GLKVector3Make(0.5, 0.5, 0.5);
  cube.rotation = GLKVector3Make(1.0/8*M_TAU, 1.0/8*M_TAU, 0);
  [cubes addObject:cube];
  
  ColorfulCube *cube2 = [[ColorfulCube alloc] init];
  cube2.position = GLKVector3Make(-0.5, -0.25, 0.0);
  cube2.scale = GLKVector3Make(0.4, 0.4, 0.4);
  cube2.rotation = GLKVector3Make(1.0/8*M_TAU, 0, 1.0/8*M_TAU);
  [cubes addObject:cube2];
  
  return YES;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClearColor(0.5, 0.5, 0.5, 0.5);
  glClear(GL_COLOR_BUFFER_BIT);
    
  [cubes makeObjectsPerformSelector:@selector(draw)];
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
