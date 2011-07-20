//
//  ColorfulCube.h
//  Cube
//
//  Created by Ian Terrell on 7/19/11.
//  Copyright 2011 Ian Terrell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ColorfulCube : NSObject {
  GLKVector3 position, rotation, scale, rps;
}

@property GLKVector3 position, rotation, scale, rps;

- (void)draw;
- (void)updateRotations:(NSTimeInterval)dt;

@end
