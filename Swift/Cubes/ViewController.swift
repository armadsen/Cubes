//
//  ViewController.swift
//  Cubes
//
//  Created by Andrew Madsen on 11/1/15.
//  Copyright © 2015 Open Reel Software. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
	
	@IBOutlet var sceneView: SCNView!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setupScene()
	}
	
	private var cubeNode: SCNNode?
	
	private func setupScene() {
		
		// Configure the Scene View
		self.sceneView.backgroundColor = .darkGrayColor()
		
		// Create the scene
		let scene = SCNScene()
		
		// Create a camera and attach it to a node
		let camera = SCNCamera()
		camera.xFov = 10
		camera.yFov = 45
		
		let cameraNode = SCNNode()
		cameraNode.camera = camera
		cameraNode.position = SCNVector3(0, 0, 50)
		scene.rootNode.addChildNode(cameraNode)
		
		// Create a cube and place it in the scene
		let cube = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
		cube.firstMaterial?.diffuse.contents = UIColor(red: 0.149, green: 0.604, blue: 0.859, alpha: 1.0)
		let cubeNode = SCNNode(geometry: cube)
		scene.rootNode.addChildNode(cubeNode)
		self.cubeNode = cubeNode
		
		// Add an animation to the cube.
		let animation = CAKeyframeAnimation(keyPath: "rotation")
		animation.values = [NSValue(SCNVector4: SCNVector4(1, 1, 0.3, 0 * M_PI)),
		NSValue(SCNVector4: SCNVector4(1, 1, 0.3, 1 * M_PI)),
		NSValue(SCNVector4: SCNVector4(1, 1, 0.3, 2 * M_PI))]
		animation.duration = 5
		animation.repeatCount = HUGE
		self.cubeNode?.addAnimation(animation, forKey: "rotation")
		self.cubeNode?.paused = true // Start out paused
		
		self.sceneView.scene = scene
	}

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		
		let touch = touches.first
		if let touchPoint = touch?.locationInView(self.sceneView),
		hitTestResult = self.sceneView.hitTest(touchPoint, options: nil).first {
			let hitNode = hitTestResult.node
			hitNode.paused = !hitNode.paused
		}
		
	}
}
