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
import Lottie
import SnapKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    // 图库展示
    public var dataItems = DataItemView()
    
    // Menu Status
    public var menuIsOpen: Bool = true
    
    // Switch Button
    public var switchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(controlMenu), for: .touchUpInside)
        return button
    }()
    
    // SCENE
    @IBOutlet var sceneView: ARSCNView!
    var latestPrediction : String = "…" // a variable containing the latest CoreML prediction
    
    var scnNodes: Set = Set<SCNNode>()
    
    // SCNAction
    var foreverBounceAction: SCNAction!
    
    // 镜头动画
    var cameraAnimation: LOTAnimationView = LOTAnimationView()
    
    // CoreML
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    @IBOutlet weak var debugTextView: UITextView!
    
    private let squareRect: CGRect = {
        return CGRect(x: 0, y: 0.5 * (kScreenHeight - kScreenWidth), width: kScreenWidth, height: kScreenWidth)
    }()
    
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
        
        // 防止键盘弹出
        debugTextView.isUserInteractionEnabled = false
        
        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
        
        setUpActions()
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
        
        // 增加镜头动画
        cameraAnimation = LOTAnimationView(name: "camera")
        cameraAnimation.alpha = 0.1
        cameraAnimation.loopAnimation = true
        view.addSubview(cameraAnimation)
        
        cameraAnimation.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.height.width.equalTo(400)
        }
        
        cameraAnimation.play()
        
        // 增加图片库
        view.addSubview(dataItems)
        
        dataItems.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
            make.height.equalTo(100)
        }
        
        // 开关按钮
        view.addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.centerX.equalTo(dataItems.snp.centerX)
            make.bottom.equalTo(dataItems.snp.top).offset(-10)
            make.height.width.equalTo(35)
        }
        
//        NLPUnderstandingHelper.shared.analyze(text: "In computing, a computer keyboard is a typewriter-style device which uses an arrangement of buttons or keys to act as a mechanical lever or electronic switch. Following the decline of punch cards and paper tape, interaction via teleprinter-style keyboards became the main input device for computers.\nA keyboard typically has characters engraved or printed on the keys (buttons) and each press of a key typically corresponds to a single written symbol. However, to produce some symbols requires pressing and holding several keys simultaneously or in sequence. While most keyboard keys produce letters, numbers or signs (characters), other keys or simultaneous key presses can produce actions or execute computer commands.\nDespite the development of alternative input devices, such as the mouse, touchscreen, pen devices, character recognition and voice recognition, the keyboard remains the most commonly used device for direct (human) input of alphanumeric data into computers.\nIn normal usage, the keyboard is used as a text entry interface to type text and numbers into a word processor, text editor or other programs. In a modern computer, the interpretation of key presses is generally left to the software.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        
        // 退出停止动画
        cameraAnimation.stop()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Draw the square frame
        let rectPath = UIBezierPath(rect: squareRect)
        rectPath.lineWidth = 1.5
        rectPath.lineCapStyle = .square
        rectPath.lineJoinStyle = .miter
        let layer = CAShapeLayer()
        layer.path = rectPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.init(red: 34.0/255.0, green: 196.0/255.0, blue: 228.0/255.0, alpha: 1.0).cgColor
        rectPath.stroke()
        sceneView.layer.addSublayer(layer)
        
//        WikipediaHelper.shared.getSummary(of: "Computer Keyboard") { (model) in
//            print(model?.title ?? "no title")
//        }
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
        
        _ = screenshotAction()
        
//        let screenCenter = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
//        let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCenter, types: [.featurePoint])
        
//        if let closestResult = arHitTestResults.first {
//            // Get Coordinates of HitTest
//            let transform: matrix_float4x4 = closestResult.worldTransform
//            var currentPosition: SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
//
//            ImageClassifier.shared.classify(withUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Pembroke_Welsh_Corgi_frontal.jpg/912px-Pembroke_Welsh_Corgi_frontal.jpg", completion: {
//                print($0.map { ($0.name, $0.score) })
//
//                for tuple in $0 {
//                    let lastNode = self.addNode(with: tuple.name, at: currentPosition)
//                    let boxNode = lastNode.childNode(withName: "backgroundNode", recursively: true)
//                    let box = boxNode?.geometry as? SCNBox
//                    currentPosition.x += Float(((box?.width)! / 2 + 0.05))
//                }
//            })
//        }
        
        let screenCenter: CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)

        let arHitTestResults: [ARHitTestResult] = sceneView.hitTest(screenCenter, types: [.featurePoint])

        if let closestResult = arHitTestResults.first {
            // Get Coordinates of HitTest
            let transform: matrix_float4x4 = closestResult.worldTransform
            let worldCoordinate: SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)

            print(worldCoordinate)

            // Remove the tapped node
            var flag = false
            for node in scnNodes where node.position.distance(from: worldCoordinate) <= 0.15 {
                
                
                let particleSystem = SCNParticleSystem(named: "art.scnassets/Explode.scnp", inDirectory: nil)
                let systemNode = SCNNode()
                systemNode.addParticleSystem(particleSystem!)
                // place explosion where node is
                systemNode.position = worldCoordinate
                sceneView.scene.rootNode.addChildNode(systemNode)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1000), execute: {
                    self.scnNodes.remove(node)
                    node.removeFromParentNode()
                })
                
                flag = true
            }

            // Add a node if no node needs to be removed
            if !flag {
                _ = addNode(with: latestPrediction, at: worldCoordinate)
                /// TODO 增加气泡添加之后，的维基检索结果
                let title = latestPrediction
                
                WikipediaHelper.shared.getSummary(of: title) { model in
                    guard let model = model else {
                        return
                    }
                    self.dataItems.wikiModel = model
                    if !self.menuIsOpen {
                        DispatchQueue.main.async {
                            self.controlMenu()
                        }
                    }
                    WikipediaHelper.shared.getURL(from: String(model.pageid), completion: { url in
                        self.dataItems.firstItemClickAction = {
                            guard let url = url else { return }
                            let detailVC = DataItemDetailViewController()
                            detailVC.wikiURL = url
                            DispatchQueue.main.async {

                                self.navigationController?.pushViewController(detailVC, animated: true)
                            }
                        }
                        DispatchQueue.main.async {
                            self.dataItems.updateDatas()
                        }
                    })
                }
            }
        }
    }
    
    func addNode(with text: String, at position: SCNVector3) -> SCNNode {
        let node: SCNNode = BubbleTextNode(text: text, at: position)
        node.position = position
        
        sceneView.scene.rootNode.addChildNode(node)
        node.runAction(foreverBounceAction)
        
        scnNodes.insert(node)
        
        return node
    }
    
    // Explosion
    func createExplosion(color: UIColor, shape: SCNGeometry, position: SCNVector3, rotation: SCNVector4) {
        let particleSystem = SCNParticleSystem(named: "art.scnassets/Explode.scnp", inDirectory: nil)
        let systemNode = SCNNode()
        systemNode.addParticleSystem(particleSystem!)
        // place explosion where node is
        systemNode.position = position
        sceneView.scene.rootNode.addChildNode(systemNode)
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

extension ViewController {
    
    func screenshotAction() -> UIImage {
        cameraAnimation.isHidden = true
        
        for node in scnNodes {
            node.isHidden = true
        }
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(kScreenBounds.size, false, scale)
        self.sceneView.drawHierarchy(in: kScreenBounds, afterScreenUpdates: true)
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        image = image?.getSubImage(rect: squareRect, scale: scale)
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 70, width: 150, height: 150))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        sceneView.addSubview(imageView)
        
        cameraAnimation.isHidden = false
        
        for node in scnNodes {
            node.isHidden = false
        }
        
        return image!
    }
    
}
