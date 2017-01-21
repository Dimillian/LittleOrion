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
    
    var lastUpdateTime : TimeInterval = 0
    let universe = Universe(size: .standard)
    let infoNode = SKLabelNode(text: "Touch a case!")
    let subInfoNode = SKLabelNode(text: "")
    var loaded = false
    
    var _systemUI: SystemUI?
    var systemUI: SystemUI! {
        get {
            if _systemUI == nil {
                _systemUI = SystemUI.loadFromNib()
                _systemUI!.isHidden = true
            }
            return _systemUI!
        }
    }
    
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    
    var mapNode = SKNode()
    var mapMoved = false
    var mapNewPosition: CGPoint?
    var mapNewScale: CGFloat?
    var inZoomGesture = false

    var selectedNode: SKShapeNode?
    
    override func sceneDidLoad() {
        
        view?.isMultipleTouchEnabled = true
        backgroundColor = UIColor.black
        
        if (!loaded) {
            
            lastUpdateTime = 0
            
            infoNode.position = CGPoint(x: 0, y: (frame.height / 2) - 70)
            
            if infoNode.parent == nil {
                addChild(infoNode)
            }
            
            subInfoNode.position = CGPoint(x: 0, y: (frame.height / 2) - 110)
            
            if subInfoNode.parent == nil {
                addChild(subInfoNode)
            }
            
            for node in universe.grid.nodes! {
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
            mapNode.position = CGPoint(x: CGFloat(-((UniverseSpriteComponent.size.width * universe.size.width) / 2)),
                                       y: CGFloat(-((UniverseSpriteComponent.size.height * universe.size.height) / 2)))
            addChild(mapNode)
            
            generateStarField()
        }
        
        loaded = true
    }
    
    
    override func didMove(to view: SKView) {
        self.view?.addSubview(systemUI)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinchGesture(pinch:)))
        self.view?.addGestureRecognizer(pinch)
    }
    

    func generateStarField() {
        var emitterNode = starfieldEmitter(color: SKColor.lightGray, starSpeedY: 50, starsPerSecond: 1, starScaleFactor: 0.2)
        emitterNode.zPosition = -10
        addChild(emitterNode)
        
        emitterNode = starfieldEmitter(color: SKColor.gray, starSpeedY: 30, starsPerSecond: 2, starScaleFactor: 0.1)
        emitterNode.zPosition = -11
        addChild(emitterNode)
        
        emitterNode = starfieldEmitter(color: SKColor.darkGray, starSpeedY: 15, starsPerSecond: 4, starScaleFactor: 0.05)
        emitterNode.zPosition = -12
        addChild(emitterNode)
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

        if mapNewPosition != nil {
            mapNode.position = mapNewPosition!
        }
        if mapNewScale != nil {
            mapNode.setScale(mapNewScale!)
        }
        
        mapNewPosition = nil
        mapNewScale = nil
    }
    
}

//MARK: - Nodes
extension UniverseScene {
    func systemAt(_ touches: Set<UITouch>, with event: UIEvent?) -> System? {
        let node = nodeAt(touches, with: event)
        if let entity = node?.entity as? System {
            return entity
        }
        return nil
    }
    
    func nodeAt(_ touches: Set<UITouch>, with event: UIEvent?) -> SKNode? {
        return nodes(at: (touches.first?.location(in: self))!).first
    }
    
}

//MARK: - UI
extension UniverseScene: SystemUiDelegate {
    
    func showSystemUI(with system: System) {
        systemUI.system = system
        systemUI.delegate = self
        systemUI.show()
        
    }
    
    func updateInfoText(_ touches: Set<UITouch>, with event: UIEvent?) {
        let node = nodeAt(touches, with: event)
        
        if let entity = node?.entity as? UniverseEntity {
            infoNode.text = entity.description
            if let info = entity.extraInfo {
                subInfoNode.text = info
            } else {
                subInfoNode.text = ""
            }
        }
    }
    
    func systemUISelectedPlanet(planet: Planet) {
        let planetController = PlanetViewController(planet: planet)
        view?.window?.rootViewController?.present(planetController, animated: true, completion: nil)
    }
    
}

//MARK: - Touch
extension UniverseScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateInfoText(touches, with: event)
        selectedNode?.highlightNode(highlight: false)
        if (touches.count == 1) {
            let position = touches.first!.location(in: self)
            
            startX = position.x
            startY = position.y
        }
        if systemAt(touches, with: event) == nil {
            systemUI.hide()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateInfoText(touches, with: event)
        
        if (touches.count == 1 && !inZoomGesture) {
            let position = touches.first!.location(in: self)
            let currentMapPosition = mapNode.position
            
            let delX = position.x - startX
            let delY = position.y - startY
            
            //Will be updated in the update method
            mapNewPosition = CGPoint(x: currentMapPosition.x + delX , y: currentMapPosition.y + delY)
            
            startX = position.x
            startY = position.y
            
            if (abs(delX) >= 5 || abs(delY) >= 5) {
                mapMoved = true
                selectedNode?.highlightNode(highlight: false)
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !mapMoved {
            if let system = systemAt(touches, with: event) {
                showSystemUI(with: system)
            }
            
            if let node = nodeAt(touches, with: event) as? SKShapeNode {
                node.highlightNode(highlight: true)
                selectedNode = node
            }
        }
        
        mapMoved = false
    }
    
    func onPinchGesture(pinch: UIPinchGestureRecognizer) {
        
        if pinch.state == .began {
            inZoomGesture = true
        } else if pinch.state == .ended {
            inZoomGesture = false
        }
        
        var anchorPoint = pinch.location(in: pinch.view)
        anchorPoint = self.convertPoint(fromView: anchorPoint)
        let mapAnchorPoint = mapNode.convert(anchorPoint, from: self)
        
        let newScale = mapNode.xScale * pinch.scale
        
        if (newScale >= 0.7 && newScale <= 3) {
            mapNewScale = newScale
            
            let mapSceneAnchorPoint = self.convert(mapAnchorPoint, from: mapNode)
            let translationOfAnchorInScene = (x: anchorPoint.x - mapSceneAnchorPoint.x, y: anchorPoint.y - mapSceneAnchorPoint.y)
            
            mapNewPosition = CGPoint(x: mapNode.position.x + translationOfAnchorInScene.x, y: mapNode.position.y + translationOfAnchorInScene.y)
        }
        
        pinch.scale = 1.0
    }
}

