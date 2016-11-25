//
//  GameScene.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import SpriteKit
import GameplayKit

class UniverseScene: SKScene {
    
    private var lastUpdateTime : TimeInterval = 0
    private let universe = Universe(size: .small)
    private let infoNode = SKLabelNode(text: "Touch a case!")
    private let subInfoNode = SKLabelNode(text: "")
    
    private var _systemUI: SystemUI?
    private var systemUI: SystemUI! {
        get {
            if _systemUI == nil {
                let nib = UINib(nibName: "SystemUI", bundle: Bundle.main)
                _systemUI = nib.instantiate(withOwner: self, options: nil)[0] as? SystemUI
                _systemUI!.isHidden = true
            }
            return _systemUI!
        }
    }
    
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        infoNode.position = CGPoint(x: 0, y: (self.frame.height / 2) - 70)
        
        if infoNode.parent == nil {
            addChild(infoNode)
        }
        
        subInfoNode.position = CGPoint(x: 0, y: (self.frame.height / 2) - 110)
        
        if subInfoNode.parent == nil {
            addChild(subInfoNode)
        }
        
        
        let mapNode = SKNode()
        for node in self.universe.grid.nodes! {
            if let node = node as? UniverseNode {
                let spriteNode = node.entity.spriteNode
                spriteNode.position = CGPoint(x: CGFloat(CGFloat(node.gridPosition.x) * node.entity.spriteNode.size.width),
                                              y: CGFloat(CGFloat(node.gridPosition.y) * node.entity.spriteNode.size.height))
                if spriteNode.parent == nil {
                    mapNode.addChild(spriteNode)
                }
            }
        }
        mapNode.position = CGPoint(x: CGFloat(-((UniverseSpriteComponent.size.width * self.universe.size.width) / 2)),
                                   y: CGFloat(-((UniverseSpriteComponent.size.height * self.universe.size.height) / 2)))
        addChild(mapNode)
        
        
    }
    
    
    override func didMove(to view: SKView) {
        self.view?.addSubview(systemUI)
    }
    
    private func updateInfoText(_ touches: Set<UITouch>, with event: UIEvent?) {
        let node = nodes(at: (touches.first?.location(in: self))!).first
        if let entity = node?.entity as? UniverseEntity {
            self.infoNode.text = entity.description
            if let info = entity.extraInfo {
                self.subInfoNode.text = info
            } else {
                self.subInfoNode.text = ""
            }
        }
    }
    
    private func systemAt(_ touches: Set<UITouch>, with event: UIEvent?) -> System? {
        let node = nodes(at: (touches.first?.location(in: self))!).first
        if let entity = node?.entity as? System {
            return entity
        }
        return nil
    }
    
    private func showSystemUI(with system: System) {
        self.systemUI.system = system
        self.systemUI.isHidden = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        /*
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        self.lastUpdateTime = currentTime
         */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateInfoText(touches, with: event)
        
        self.systemUI.isHidden = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateInfoText(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let system = systemAt(touches, with: event) {
            showSystemUI(with: system)
        }
    }
}

