//
//  ViewController.m
//  Cubes
//
//  Created by Andrew Madsen on 2/12/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self setupScene];
}

- (void)setupScene
{
	self.sceneView.autoenablesDefaultLighting = YES;
	self.sceneView.backgroundColor = [UIColor darkGrayColor];
	
	// Create the scene
	SCNScene *scene = [SCNScene scene];
	
	// Create a camera and attach it to a node
	SCNCamera *camera = [SCNCamera camera];
	camera.xFov = 10;
	camera.yFov = 45;
	
	SCNNode *cameraNode = [SCNNode node];
	cameraNode.camera = camera;
	cameraNode.position = SCNVector3Make(0, 0, 50);
	[scene.rootNode addChildNode:cameraNode]; // Place camera in the scene
	
	// Create a cube and place it in the scene
	SCNBox *cube = [SCNBox boxWithWidth:5 height:5 length:5 chamferRadius:0.0];
	cube.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.149 green:0.604 blue:0.859 alpha:1.000];
	SCNNode *cubeNode = [SCNNode nodeWithGeometry:cube];
	[scene.rootNode addChildNode:cubeNode];
	
	// Add an animation to the cube.
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.values = @[[NSValue valueWithSCNMatrix4:SCNMatrix4MakeRotation(0 * M_PI, 1, 1, 0.3)],
						 [NSValue valueWithSCNMatrix4:SCNMatrix4MakeRotation(1 * M_PI, 1, 1, 0.3)],
						[NSValue valueWithSCNMatrix4:SCNMatrix4MakeRotation(2 * M_PI, 1, 1, 0.3)]];
	animation.duration = 5;
	animation.repeatCount = HUGE_VALF;
	
	[cubeNode addAnimation:animation forKey:@"transform"];
	
	self.sceneView.scene = scene;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self.sceneView];
	SCNHitTestResult *hitTestResult = [[self.sceneView hitTest:touchPoint options:nil] firstObject];
	SCNNode *hitNode = hitTestResult.node;
	NSString *animationKey = @"transform";
	if ([hitNode isAnimationForKeyPaused:animationKey]) {
		[hitNode resumeAnimationForKey:animationKey];
	} else {
		[hitNode pauseAnimationForKey:animationKey];
	}
}

@end
