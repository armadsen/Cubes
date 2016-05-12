//: Playground - noun: a place where people can play

import Cocoa
import SceneKit
import XCPlayground

// This just makes it so we can write the code exactly as we would on iOS.
typealias UITapGestureRecognizer = NSClickGestureRecognizer

/*:
## SceneKit Demo
This playground uses SceneKit to create a simple 3D scene and displays it. It demonstrates the basics of SceneKit, which is a system framework for doing 3D graphics available on iOS and OS X.

First, let's create a scene view, which is an instance of `SCNView`.
*/

let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))

/*:
Configure the Scene View
*/
sceneView.backgroundColor = [#Color(colorLiteralRed: 0.1956433057785034, green: 0.2113749980926514, blue: 0.2356699705123901, alpha: 1)#]
sceneView.autoenablesDefaultLighting = true

/*:
An `SCNView` draws a scene. Scenes are represented by an `SCNScene` instance. Think of `SCNScene` as the model object that represents an entire scene filled with 3D objects.

We'll create a scene here:
*/
let scene = SCNScene()

/*:
In order for our `SCNView` to know how to render the scene, we need to place a camera in the scene. The camera provides our view into the scene. The xFov and yFov properties determine the camera's field of view, in the x and y directions.
*/

let camera = SCNCamera()
camera.xFov = 10
camera.yFov = 45

/*:
In a scene, all objects, including shapes and cameras, are attached to nodes. Think of a node like a "hook" that you can hang things on. It has a position, rotation, etc. but does not itself appear visually in the scene. We need a node to attach our camera to:
*/

let cameraNode = SCNNode()
cameraNode.camera = camera
cameraNode.position = SCNVector3(0, 0, 50)
scene.rootNode.addChildNode(cameraNode)

/*:
Now we're ready to create an object that we can actually see. Let's create a cube using the `SCNBox` class. We'll place it in the scene by createing a node for it, too.
*/
let cube = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
cube.firstMaterial?.diffuse.contents = [#Color(colorLiteralRed: 0.1490196078431373, green: 0.6039215686274509, blue: 0.8588235294117647, alpha: 1)#]
let cubeNode = SCNNode(geometry: cube)
scene.rootNode.addChildNode(cubeNode)

/*:
SceneKit lets us animate elements of a scene using CoreAnimation. Let's add a rotation animation to our cube:
*/
let animation = CAKeyframeAnimation(keyPath: "rotation")
animation.values = [NSValue(SCNVector4: SCNVector4(1, 1, 0.3, 0 * M_PI)),
                    NSValue(SCNVector4: SCNVector4(1, 1, 0.3, 1 * M_PI)),
                    NSValue(SCNVector4: SCNVector4(1, 1, 0.3, 2 * M_PI))]
animation.duration = 5
animation.repeatCount = HUGE
cubeNode.addAnimation(animation, forKey: "rotation")
cubeNode.paused = true // Start out paused

sceneView.scene = scene
XCPlaygroundPage.currentPage.liveView = sceneView

/*:
We can make the animation start and stop when the scene is tapped on. We'll attach a gesture recognizer to the
scene view to receive taps. SceneKit makes it easy to figure out which node was tapped on using the `hitTest()`
method.

We create a TouchHandler class just so that we have a target for our gesture recognizer.
*/
class TouchHandler: NSObject {
	func tapGestureRecognized(recognizer: UITapGestureRecognizer) {
		guard let view = recognizer.view as? SCNView else { return }
		let touchPoint = recognizer.locationInView(view)
		if let hitNode = view.hitTest(touchPoint, options: nil).first?.node {
			hitNode.paused = !hitNode.paused
		}
	}
}

let touchHandler = TouchHandler()
let tapRecognizer = UITapGestureRecognizer(target: touchHandler, action: #selector(TouchHandler.tapGestureRecognized(_:)))
sceneView.addGestureRecognizer(tapRecognizer)
