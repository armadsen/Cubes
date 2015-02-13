//
//  ViewController.m
//  Cubes
//
//  Created by Andrew Madsen on 2/12/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) SCNNode *cubeNode;
@property (nonatomic, strong) SCNNode *pyramidNode;

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
	cubeNode.position = SCNVector3Make(0, 10, 0);
	[scene.rootNode addChildNode:cubeNode];
	self.cubeNode = cubeNode;
	
	// Add an animation to the cube.
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"rotation"];
	animation.values = @[[NSValue valueWithSCNVector4:SCNVector4Make(1, 1, 0.3, 0 * M_PI)],
						 [NSValue valueWithSCNVector4:SCNVector4Make(1, 1, 0.3, 1 * M_PI)],
						 [NSValue valueWithSCNVector4:SCNVector4Make(1, 1, 0.3, 2 * M_PI)]];
	animation.duration = 5;
	animation.repeatCount = HUGE_VALF;
	[self.cubeNode addAnimation:animation forKey:@"rotation"];
	self.cubeNode.paused = YES; // Start out paused
	
	// Create a cone and place it in the scene
	SCNPyramid *pyramid = [SCNPyramid pyramidWithWidth:5 height:5 length:5];
	pyramid.firstMaterial.diffuse.contents = [UIColor purpleColor];
	pyramid.firstMaterial.emission.contents = [UIColor lightGrayColor];
	pyramid.firstMaterial.emission.intensity = 0;
	SCNNode *pyramidNode = [SCNNode nodeWithGeometry:pyramid];
	pyramidNode.position = SCNVector3Make(0, -10, 0);
	pyramidNode.rotation = SCNVector4Make(0, 1, 0, M_PI / 3.0);
	[scene.rootNode addChildNode:pyramidNode];
	self.pyramidNode = pyramidNode;
	
	self.sceneView.scene = scene;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint touchPoint = [touch locationInView:self.sceneView];
	SCNHitTestResult *hitTestResult = [[self.sceneView hitTest:touchPoint options:nil] firstObject];
	SCNNode *hitNode = hitTestResult.node;
	if (hitNode == self.cubeNode) {
		hitNode.paused = !hitNode.paused;
	} else {
		// Pyramid node
		if (hitNode.geometry.firstMaterial.emission.intensity == 0) {
			hitNode.geometry.firstMaterial.emission.intensity = 1;
		} else {
			hitNode.geometry.firstMaterial.emission.intensity = 0;
		}
	}
}

@end
