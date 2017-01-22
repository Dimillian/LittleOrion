//
//  GameScene.swift
//  Little Orion
//
//  Created by Thomas Ricouard on 21/11/2016.
//  Copyright © 2016 Thomas Ricouard. All rights reserved.
//

import SpriteKit
import GameplayKit
import ReSwift

class UniverseScene: SKScene {
    
    var lastUpdateTime : TimeInterval = 0
    var universe: Universe? {
        didSet {
            if let universe = universe {
                setupUniverse(universe: universe)
            }
        }
    }

    let topBar = TopBar.loadFromNib()

    var universeSubscriber: UniverseSubscriber?
    var uiSubscriber: UISubscriber?

    var loaded = false
    var universeLoaded = false
    
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

            universeSubscriber = UniverseSubscriber(scene: self)
            uiSubscriber = UISubscriber(scene: self)

            store.subscribe(universeSubscriber!) {state in
                state.universeState
            }

            store.subscribe(uiSubscriber!) {state in
                state.uiState
            }

            lastUpdateTime = 0

            store.dispatch(CreateUnivserse(size: .standard))
            store.dispatch(StartDateTimer())
        }
        
        loaded = true
    }

    func setupUniverse(universe: Universe) {
        if !universeLoaded {
            universeLoaded = true
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
    }

    override func didMove(to view: SKView) {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinchGesture(pinch:)))
        self.view?.addGestureRecognizer(pinch)

        self.view?.addSubview(topBar)
        topBar.frame = CGRect(x: -2, y: -1, width: self.view!.frame.size.width + 4, height: 50)
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

//MARK: - State
class UniverseSubscriber: StoreSubscriber {
    weak var scene: UniverseScene?

    init(scene: UniverseScene) {
        self.scene = scene
    }

    func newState(state: UniverseState) {
        scene?.updateUniverse(state: state)
    }
}

class UISubscriber: StoreSubscriber {

    weak var scene: UniverseScene?

    init(scene: UniverseScene) {
        self.scene = scene
    }


    func newState(state: UIState) {
        scene?.updateModal(state: state)
        scene?.updateScene(state: state)
    }
}

extension UniverseScene {
    func updateUniverse(state: UniverseState) {
        if let universe = state.universe {
            self.universe = universe
        }
    }

    func updateScene(state: UIState) {
        switch state.currentScene {
        case .universe:
            break
        case .planet:
            let planetController = PlanetViewController()
            view?.window?.rootViewController?.present(planetController, animated: true, completion: nil)
            break
        }
    }

    func updateModal(state: UIState) {
        switch state.currentModal {
        case .none:
            ModalUI.dismissSystemUI()
            break
        case .system:
            ModalUI.presentSystemUI(from: self, delegate: self)
            break
        }
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
    func systemUISelectedPlanet(planet: Planet) {
        store.dispatch(ShowPlanetDetail(planet: planet))
    }
    
}

//MARK: - Touch
extension UniverseScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectedNode?.highlightNode(highlight: false)
        if (touches.count == 1) {
            let position = touches.first!.location(in: self)
            
            startX = position.x
            startY = position.y
        }
        if systemAt(touches, with: event) == nil {
            store.dispatch(DismissSystemModal())
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {        
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
                store.dispatch(ShowSelectedSystemModal(system: system))
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

