//
//  PlanetViewController.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 29/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import UIKit
import SceneKit

class PlanetViewController: UIViewController {

    let planet: Planet
    
    var mainScene: SCNScene! = nil
    var mainSceneView: SCNView! = nil
    
    init(planet: Planet){
        self.planet = planet
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupCloseButton()
    }
}

// MARK: - Action
extension PlanetViewController {
    
    func onClose() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Setup
extension PlanetViewController {

    func setupCloseButton() {
        let button = UIButton(type: .custom)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.frame = CGRect(x: view.frame.size.width - 70, y: 15.0, width: 60, height: 30)
        button.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        view.addSubview(button)
    }
    
    func setupScene() {
        
        mainSceneView = SCNView(frame: view.bounds)
        view.addSubview(mainSceneView)
        
        mainScene = SCNScene()
        mainScene.background.contents = planet.planet3D.skybox
        
        setupLight()
        setupCamera()
        
        mainSceneView.scene = mainScene
        
        mainScene.rootNode.addChildNode(SCNNode(geometry: planet.planet3D.sphere))
    }
    
    func setupLight() {        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .ambient
        lightNode.light?.color = UIColor(white: 0.37, alpha: 1.0)
        lightNode.position = SCNVector3Make(0, 50, 50)
        
        mainScene.rootNode.addChildNode(lightNode)
        
        
        mainScene.rootNode.addChildNode(planet.planet3D.light)
    }
    
    func setupCamera() {
        mainSceneView.allowsCameraControl = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 20)
        
        mainScene.rootNode.addChildNode(cameraNode)
    }
 
}
