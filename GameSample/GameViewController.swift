//
//  GameViewController.swift
//  GameSample
//
//  Created by kazuki.horie.ts on 2019/06/25.
//  Copyright © 2019 Kazuki Horie. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//        let scene = SCNScene(named: "art.scnassets/cube_noanimate.dae")!
//        let scene = SCNScene(named: "art.scnassets/cube_animate_y.dae")!
//        let scene = SCNScene(named: "art.scnassets/cube_animate_y.scn")!
//        let url = Bundle.main.url(forResource: "art.scnassets/cube_animate_all", withExtension: "dae")!
//        let url = Bundle.main.url(forResource: "art.scnassets/test_stage", withExtension: "dae")!
//        let url = Bundle.main.url(forResource: "art.scnassets/tri_matrix", withExtension: "dae")!
//        let url = Bundle.main.url(forResource: "art.scnassets/tri", withExtension: "dae")!
//        let url = Bundle.main.url(forResource: "art.scnassets/none", withExtension: "dae")!
//        let url = Bundle.main.url(forResource: "art.scnassets/ball_animation_bake", withExtension: "dae")!
//        let url = Bundle.main.url(forResource: "art.scnassets/ball_mesh", withExtension: "dae")!
//        let anim1Url = Bundle.main.url(forResource: "art.scnassets/ball_animation", withExtension: "dae")!
        
        let cameraAnimUrl = Bundle.main.url(forResource: "gacha001.scnassets/camera", withExtension: "dae")!
        let baseScene = try! SCNScene(url: cameraAnimUrl, options: [SCNSceneSource.LoadingOption.animationImportPolicy : SCNSceneSource.AnimationImportPolicy.playRepeatedly])
        
        baseScene.rootNode.animationKeys.forEach {
//            childNode.animationKeys.forEach {
                print("1Key: \($0)")
//            }
        }
        
        let stageUrl = Bundle.main.url(forResource: "art.scnassets/test_stage", withExtension: "dae")!
        let stageScene = try! SCNScene(url: stageUrl, options: [SCNSceneSource.LoadingOption.animationImportPolicy : SCNSceneSource.AnimationImportPolicy.playRepeatedly])
        
        let ball1Url = Bundle.main.url(forResource: "gacha001.scnassets/ball_1_horie", withExtension: "dae")!
        let ball1Scene = try! SCNScene(url: ball1Url, options: [SCNSceneSource.LoadingOption.animationImportPolicy : SCNSceneSource.AnimationImportPolicy.playRepeatedly])
 
        
        let ballAnim1Url = Bundle.main.url(forResource: "gacha001.scnassets/ball_1_anim", withExtension: "dae")!
        let ballAnim1Scene = try! SCNScene(url: ballAnim1Url, options: [SCNSceneSource.LoadingOption.animationImportPolicy : SCNSceneSource.AnimationImportPolicy.playRepeatedly])
        
        func setBallAnimation(_ scene: SCNScene, root: SCNScene) {
            scene.rootNode.childNodes.forEach { childNode in
                print("child: \(childNode.name)")
                childNode.animationKeys.forEach { key in
                    guard let anim = childNode.animation(forKey: key) else { return }
                    root.rootNode.childNodes.forEach {
                        if $0.name == "joint" {
                            $0.addAnimation(anim, forKey: key)
                        }
                        print("anim: " + String($0.name ?? ""))
                    }
                }
            }
        }
        
        setBallAnimation(ballAnim1Scene, root: ball1Scene)
        
        
//        if let anim = anim1SceneSource?.entryWithIdentifier("ball_locator", withClass: SCNAnimation.self) {
//            scene.rootNode.addAnimation(anim, forKey: "ball_locator")
//        }
        
        baseScene.rootNode.childNodes.forEach {
            $0.animationKeys.forEach {
                print($0)
            }
            
//            let anim1 = $0.animationPlayer(forKey: "ball_locator-anim")
//            anim1?.stop()
            
//            let anim1 = $0.animationPlayer(forKey: "Cube_location_Y")
//            anim1?.stop()
//
//            let anim2 = $0.animationPlayer(forKey: "Camera_location_X")
//            anim2?.stop()
        }
        
        baseScene.rootNode.addChildNode(ball1Scene.rootNode)
        baseScene.rootNode.addChildNode(stageScene.rootNode)
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        baseScene.rootNode.addChildNode(cameraNode)
        
        baseScene.rootNode.animationKeys.forEach {
            guard let anim = baseScene.rootNode.animation(forKey: $0) else { return }
            cameraNode.addAnimation(anim, forKey: $0)
        }
        
        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 150)
//        cameraNode.camera?.zFar = 3000
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        baseScene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        baseScene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
//        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = baseScene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.darkGray
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
