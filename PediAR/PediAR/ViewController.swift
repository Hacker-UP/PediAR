//
//  ViewController.swift
//  PediAR
//
//  Created by 宋 奎熹 on 2017/11/4.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import VisualRecognitionV3
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // Scene
    @IBOutlet var sceneView: ARSCNView!
    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction
    
    var scnNodes: Set = Set<SCNNode>()
    
    // SCNAction
    var foreverBounceAction: SCNAction!
    
    // CoreML
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    @IBOutlet weak var debugTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Tap Gesture Recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognize:)))
        view.addGestureRecognizer(tapGesture)
        
        // Set up Vision Model
        guard let selectedModel = try? VNCoreMLModel(for: Inceptionv3().model) else { // (Optional) This can be replaced with other models on https://developer.apple.com/machine-learning/
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project from https://developer.apple.com/machine-learning/ . Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        let classificationRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        // Crop from centre of images and scale to appropriate size.
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        
        visionRequests = [classificationRequest]
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
        
        setUpActions()
        
        let apiKey = ibm_key
        let version = "2017-11-04" // use today's date for the most recent version
        let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        
        let url = "http://mpic.tiankong.com/e91/c4c/e91c4c22674f98dd384fa40ae1417e99/640.jpg"
        let failure = { (error: Error) in print(error) }
        visualRecognition.classify(image: url, language: "en", failure: failure) { classifiedImages in
            print(classifiedImages.images.first?.classifiers.first?.classes.map { ($0.classification, $0.score) })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Enable plane detection
        configuration.planeDetection = .horizontal
        
        // Enable light estimation
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - SCNActions
    
    func setUpActions() {
        let bounceUpAction = SCNAction.moveBy(x: 0, y: 0.04, z: 0, duration: 1.0)
        let bounceDownAction = SCNAction.moveBy(x: 0, y: -0.04, z: 0, duration: 1.0)
        bounceUpAction.timingMode = .easeInEaseOut
        bounceDownAction.timingMode = .easeInEaseOut
        let bounceAction = SCNAction.sequence([bounceUpAction, bounceDownAction])
        foreverBounceAction = SCNAction.repeatForever(bounceAction)
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            // Do any desired updates to SceneKit here.
        }
    }
    
    // MARK: - Status Bar: Hide
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Interaction
    
    @objc func handleTap(gestureRecognize: UITapGestureRecognizer) {
        let screenCenter: CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
        
        let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCenter, types: [.featurePoint])
        
        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform: matrix_float4x4 = closestResult.worldTransform
            let worldCoordinate: SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            
            print(worldCoordinate)
            
            for node in scnNodes {
                print(node.name ?? "", node.position)
            }
            
            // Remove the tapped node
            var flag = false
            for node in scnNodes where node.position.distance(from: worldCoordinate) <= 0.1 {
                node.removeFromParentNode()
                scnNodes.remove(node)
                flag = true
            }
            
            // Add a node if no node needs to be removed
            if !flag {
                let node: SCNNode = BubbleTextNode(text: latestPrediction, at: worldCoordinate)
                node.position = worldCoordinate
                
                sceneView.scene.rootNode.addChildNode(node)
                node.runAction(foreverBounceAction)
                
                scnNodes.insert(node)
            }
        }
    }
    
    // MARK: - CoreML Vision Handling
    
    func loopCoreMLUpdate() {
        
        // Continuously run CoreML whenever it's ready. (Preventing 'hiccups' in Frame Rate)
        dispatchQueueML.async {
            // Run Update.
            self.updateCoreML()
        
            // Loop this function.
            self.loopCoreMLUpdate()
        }
        
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...1] // top 2 results
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Display Debug Text on screen
            var debugText:String = ""
            debugText += classifications
            self.debugTextView.text = debugText
            
            // Store the latest prediction
            var objectName:String = "…"
            objectName = classifications.components(separatedBy: "-")[0]
            objectName = objectName.components(separatedBy: ",")[0]
            self.latestPrediction = objectName
        }
        
    }
    
    func updateCoreML() {
        // Get Camera Image as RGB
        let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
        if pixbuff == nil { return }
        let ciImage = CIImage(cvPixelBuffer: pixbuff!)
        // Note: Not entirely sure if the ciImage is being interpreted as RGB, but for now it works with the Inception model.
        // Note2: Also uncertain if the pixelBuffer should be rotated before handing off to Vision (VNImageRequestHandler) - regardless, for now, it still works well with the Inception model.
        
        // Prepare CoreML/Vision Request
        let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        // let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage!, orientation: myOrientation, options: [:]) // Alternatively; we can convert the above to an RGB CGImage and use that. Also UIInterfaceOrientation can inform orientation values.
        
        // Run Image Request
        do {
            try imageRequestHandler.perform(self.visionRequests)
        } catch {
            print(error)
        }
    }
    
}
