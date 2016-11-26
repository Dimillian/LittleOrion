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
    private var loaded = false
    
    private var _systemUI: SystemUI?
    private var systemUI: SystemUI! {
        get {
            if _systemUI == nil {
                _systemUI = SystemUI.loadFromNib()
                _systemUI!.isHidden = true
            }
            return _systemUI!
        }
    }
    
    
    override func sceneDidLoad() {
        
        self.backgroundColor = UIColor.black
        
        if (!loaded) {
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
                    let size = UniverseSpriteComponent.nodeSize
                    let spriteNode = node.entity.spriteNode
                    spriteNode.position = CGPoint(x: CGFloat(CGFloat(node.gridPosition.x) * size.width),
                                                  y: CGFloat(CGFloat(node.gridPosition.y) * size.height))
                    if spriteNode.parent == nil {
                        mapNode.addChild(spriteNode)
                    }
                }
            }
            mapNode.position = CGPoint(x: CGFloat(-((UniverseSpriteComponent.size.width * self.universe.size.width) / 2)),
                                       y: CGFloat(-((UniverseSpriteComponent.size.height * self.universe.size.height) / 2)))
            addChild(mapNode)
            
            generateStarField()
        }
        
        self.loaded = true
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
        self.systemUI.show()
    }
    
    func generateStarField() {
        var emitterNode = starfieldEmitter(color: SKColor.lightGray, starSpeedY: 50, starsPerSecond: 1, starScaleFactor: 0.2)
        emitterNode.zPosition = -10
        self.addChild(emitterNode)
        
        emitterNode = starfieldEmitter(color: SKColor.gray, starSpeedY: 30, starsPerSecond: 2, starScaleFactor: 0.1)
        emitterNode.zPosition = -11
        self.addChild(emitterNode)
        
        emitterNode = starfieldEmitter(color: SKColor.darkGray, starSpeedY: 15, starsPerSecond: 4, starScaleFactor: 0.05)
        emitterNode.zPosition = -12
        self.addChild(emitterNode)
    }
    
    func starfieldEmitter(color: SKColor, starSpeedY: CGFloat, starsPerSecond: CGFloat, starScaleFactor: CGFloat) -> SKEmitterNode {
        
        let lifetime =  frame.size.height * UIScreen.main.scale / starSpeedY
        
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "StarParticle")
        emitterNode.particleBirthRate = starsPerSecond
        emitterNode.particleColor = color
        emitterNode.particleSpeed = starSpeedY * -1
        emitterNode.particleScale = starScaleFactor
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleLifetime = lifetime
        
        emitterNode.position = CGPoint(x: 0, y: frame.size.height)
        emitterNode.particlePositionRange = CGVector(dx: frame.size.width, dy: 0)
        
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        
        return emitterNode
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
        
        self.systemUI.hide()
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

