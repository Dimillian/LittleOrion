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

    let topBar: TopBar = TopBar.loadFromNib()
    let bottomBar: BottomBar = BottomBar.loadFromNib()
    let outliner: Outliner = Outliner.loadFromNib()

    var universeSubscriber: UniverseSubscriber?
    var uiSubscriber: UISubscriber?
    var playerSubscriber: PlayerSubcriber?

    var loaded = false
    var universeLoaded = false
    var dismissiveInteraction = false
    
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0
    
    var mapNode = SKNode()
    var mapMoved = false
    var mapNewPosition: CGPoint?
    var mapNewScale: CGFloat?
    var inZoomGesture = false
    
    override func sceneDidLoad() {

        view?.isMultipleTouchEnabled = true
        backgroundColor = UIColor.black

        if (!loaded) {

            universeSubscriber = UniverseSubscriber(scene: self)
            uiSubscriber = UISubscriber(scene: self)
            playerSubscriber = PlayerSubcriber(scene: self)

            store.subscribe(universeSubscriber!) {
                $0.select{ $0.universeState }.skipRepeats()
            }

            store.subscribe(uiSubscriber!) {
                $0.select{ $0.uiState }.skipRepeats()
            }

            store.subscribe(playerSubscriber!) {
                $0.select{ $0.playerState }.skipRepeats()
            }

            lastUpdateTime = 0

            store.dispatch(UniverseActions.CreateUnivserse(size: .standard))
            store.dispatch(PlayerActions.Initialize())
            store.dispatch(PlayerActions.StartTimer())

            onCenterPlayerButton()

            bottomBar.delegate = self
            outliner.delegate = self
        }
        
        loaded = true
    }

    func setupUniverse(universe: Universe) {
        if !universeLoaded {
            universeLoaded = true
            for node in universe.grid.nodes! {
                if let node = node as? UniverseNode {
                    let spriteNode = node.entity.spriteNode
                    spriteNode.position = Universe.grideNodePositionToMapPosition(gridNode: node)
                    if spriteNode.parent == nil {
                        mapNode.addChild(spriteNode)
                    }
                }
            }
            addChild(mapNode)

            generateStarField()
        }
    }

    override func didMove(to view: SKView) {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.onPinchGesture(pinch:)))
        self.view?.addGestureRecognizer(pinch)

        self.view?.addSubview(topBar)
        topBar.frame = CGRect(x: -2, y: -1, width: self.view!.frame.size.width + 4, height: 80)

        self.view?.addSubview(bottomBar)
        bottomBar.frame = CGRect(x: -2, y: self.view!.frame.size.height - 49,
                                 width: self.view!.frame.size.width + 4, height: 50)

        self.view?.addSubview(outliner)
        outliner.frame = CGRect(x: -130, y: 90, width: 150, height: self.view!.frame.size.height - 180)
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

        universe?.update(deltaTime: currentTime)
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

class PlayerSubcriber: StoreSubscriber {
    weak var scene: UniverseScene?

    init(scene: UniverseScene) {
        self.scene = scene
    }

    func newState(state: PlayerState) {
        scene?.updatePlayer(state: state)
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
            ModalUI.dismissSelectionUI()
        case .system:
            ModalUI.presentSystemUI(from: self, delegate: self)
        case .entity:
            ModalUI.presentSelectionUI(from: self)
        }
    }

    func updatePlayer(state: PlayerState) {
        if state.player.spriteNode.parent == nil {
            mapNode.addChild(state.player.spriteNode)
        }
    }
}

//MARK: - Nodes
extension UniverseScene {
    func systemAt(_ touches: Set<UITouch>, with event: UIEvent?) -> SystemEntity? {
        let node = nodeAt(touches, with: event)
        if let entity = node?.entity as? SystemEntity {
            return entity
        }
        return nil
    }
    
    func nodeAt(_ touches: Set<UITouch>, with event: UIEvent?) -> SKNode? {
        return nodes(at: (touches.first?.location(in: self))!).first
    }

    func gridNodeAt(_ touches: Set<UITouch>, with event: UIEvent?) -> UniverseNode? {
        if let node = nodeAt(touches, with: event) {
            return gridNodeRelativeTo(node: node)
        }
        return nil
    }

    func gridNodeRelativeTo(node: SKNode) -> UniverseNode? {
        let entity = universe?.nodeAt(location: Universe.mapNodePositionToGridPosition(mapNode: node))
        return entity
    }
}

//MARK: - UI
extension UniverseScene: SystemUiDelegate {
    func systemUISelectedPlanet(planet: PlanetEntity) {
        store.dispatch(UIActions.ShowPlanetDetail(planet: planet))
    }
}

//MARK: - BottomBar delegate
extension UniverseScene: BottomBarDelegate {
    func onCenterPlayerButton() {
        let playerPosition = store.state.playerState.player.spriteNode.position
        mapNewPosition = CGPoint(x: -playerPosition.x, y: -playerPosition.y)
    }

    func onMovePlayerButton() {
        if store.state.playerState.player.isInMovement {
            store.dispatch(PlayerActions.StopMovement())
        } else if let node = store.state.uiState.selectedNode {
            if let originalGridNode = gridNodeRelativeTo(node: store.state.playerState.player.spriteNode),
                let newGridPosition = gridNodeRelativeTo(node: node) {
                let paths = originalGridNode.findPath(to: newGridPosition)
                for universeNode in paths {
                    if let universeNode = universeNode as? UniverseNode,
                        let shapeNode = universeNode.entity.spriteNode as? SKShapeNode {
                        //TODO: Hightlight travel path
                    }
                }
                let fromLocation = Universe.mapNodePositionToGridPosition(mapNode: store.state.playerState.player.spriteNode)
                let toLocation = Universe.mapNodePositionToGridPosition(mapNode: node)
                let movement = PlayerMovementComponent(startDate: store.state.playerState.currentDate,
                                                       from: fromLocation, 
                                                       to: toLocation)
                store.dispatch(PlayerActions.MoveToPosition(movement: movement))
            }
        }
    }
}

//MARK: - OutlinerDelegate
extension UniverseScene: OutlinerDelegate {
    func outlinerDidChangeExpanded(outliner: Outliner, expanded: Bool) {
        var frame = outliner.frame
        frame.origin.x = expanded ? 0 : -outliner.bounds.size.width + 20
        UIView.animate(withDuration: 0.20) {
            self.outliner.frame = frame
        }
    }

    func outlinerDidSelectSystem(outliner: Outliner, system: UniverseId) {
        if let system = universe!.entityAt(location: system.location) as? SystemEntity {
            store.dispatch(UIActions.ShowSelectedSystemModal(system: system))
        }
    }
}

//MARK: - Touch
extension UniverseScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        store.dispatch(UIActions.RemoveSelectedNode())

        if (touches.count == 1) {
            let position = touches.first!.location(in: self)
            
            startX = position.x
            startY = position.y
        }

        if store.state.uiState.currentModal != .none {
            store.dispatch(UIActions.DismissModal())
            dismissiveInteraction = true
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
                store.dispatch(UIActions.RemoveSelectedNode())
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !mapMoved && !dismissiveInteraction {
            if let system = systemAt(touches, with: event), system.discovered {
                store.dispatch(UIActions.ShowSelectedSystemModal(system: system))
            }

            if let universeNode = gridNodeAt(touches, with: event), !universeNode.entity.discovered {
                store.dispatch(UIActions.ShowSelectionModal(entity: universeNode.entity))
            }
            
            if let node = nodeAt(touches, with: event) as? SKShapeNode {
                store.dispatch(UIActions.SetSelectedNode(node: node))
            }
        }

        dismissiveInteraction = false
        mapMoved = false
    }
    
    @objc func onPinchGesture(pinch: UIPinchGestureRecognizer) {
        
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

