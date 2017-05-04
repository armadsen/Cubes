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
		
		setupScene()
	}
	
	private var cubeNode: SCNNode?
	
	private func setupScene() {
		
		// Configure the Scene View
		sceneView.backgroundColor = .darkGray
		
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
		animation.values = [SCNVector4(1, 1, 0.3, 0 * .pi),
		                    SCNVector4(1, 1, 0.3, 1 * .pi),
		                    SCNVector4(1, 1, 0.3, 2 * .pi)]
		animation.duration = 5
		animation.repeatCount = HUGE
		self.cubeNode?.addAnimation(animation, forKey: "rotation")
		self.cubeNode?.isPaused = true // Start out paused
		
		sceneView.scene = scene
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let touch = touches.first
		if let touchPoint = touch?.location(in: sceneView),
			let hitTestResult = sceneView.hitTest(touchPoint, options: nil).first {
			let hitNode = hitTestResult.node
			hitNode.isPaused = !hitNode.isPaused
		}
		
	}
}

