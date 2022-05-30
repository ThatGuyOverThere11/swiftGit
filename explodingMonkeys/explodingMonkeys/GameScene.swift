//
//  GameScene.swift
//  explodingMonkeys
//
//  Created by IACD-06 on 2022/05/30.
//

import SpriteKit

enum collisionTypes : UInt32{
    case banana = 1
    case building = 2
    case player = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var buildings = [BuikdingNode]()
    weak var viewController: GameViewController?
    
    var playerOne : SKSpriteNode!
    var playerTwo : SKSpriteNode!
    var banana : SKSpriteNode!
    var currentPlayer = 1
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.699, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        physicsWorld.contactDelegate = self
    }
    
    func createBuildings(){
        var currentX: CGFloat = -15
        
        while currentX < 1024 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            let building = BuikdingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            buildings.append(building)
        }
    }
    
    func launch (angle: Int, velocity: Int) {
        let speed = Double(velocity) / 10
        let radians = deg2rad(degrees: angle)
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width/2)
        banana.physicsBody?.categoryBitMask = collisionTypes.banana.rawValue
        banana.physicsBody?.collisionBitMask = collisionTypes.building.rawValue | collisionTypes.player.rawValue
        banana.physicsBody?.contactTestBitMask = collisionTypes.building.rawValue | collisionTypes.player.rawValue
        banana.physicsBody?.usesPreciseCollisionDetection = true
        addChild(banana)
        
        if currentPlayer == 1 {
            banana.position = CGPoint(x: playerOne.position.x - 30, y: playerOne.position.y + 40)
            banana.physicsBody?.angularVelocity = -20

            let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player1Throw"))
            let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
            let pause = SKAction.wait(forDuration: 0.15)
            let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
            playerOne.run(sequence)
                
            let impulse = CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed)
            banana.physicsBody?.applyImpulse(impulse)
            } else {
                banana.position = CGPoint(x: playerTwo.position.x + 30, y: playerTwo.position.y + 40)
                banana.physicsBody?.angularVelocity = 20

                let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player2Throw"))
                let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "player"))
                let pause = SKAction.wait(forDuration: 0.15)
                let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
                playerTwo.run(sequence)

                let impulse = CGVector(dx: cos(radians) * -speed, dy: sin(radians) * speed)
                banana.physicsBody?.applyImpulse(impulse)
            }
    }
    
    func deg2rad (degrees: Int) -> Double {
        return Double(degrees) * .pi / 180
    }
    
    func createPlayers(){
        playerOne = SKSpriteNode(imageNamed: "player")
        playerOne.name = "Player 1"
        playerOne.physicsBody = SKPhysicsBody(circleOfRadius:  playerOne.size.width/2)
        playerOne.physicsBody?.categoryBitMask = collisionTypes.player.rawValue
        playerOne.physicsBody?.collisionBitMask = collisionTypes.banana.rawValue
        playerOne.physicsBody?.contactTestBitMask = collisionTypes.banana.rawValue
        playerOne.physicsBody?.isDynamic = false
        
        let playerOneBuilding = buildings[1]
        playerOne.position = CGPoint(x: playerOneBuilding.position.x, y: playerOneBuilding.position.y + ((playerOneBuilding.size.height + playerOne.size.height) / 2))
        
        addChild(playerOne)
        
        playerTwo = SKSpriteNode(imageNamed: "player")
        playerTwo.name = "Player 1"
        playerTwo.physicsBody = SKPhysicsBody(circleOfRadius:  playerTwo.size.width/2)
        playerTwo.physicsBody?.categoryBitMask = collisionTypes.player.rawValue
        playerTwo.physicsBody?.collisionBitMask = collisionTypes.banana.rawValue
        playerTwo.physicsBody?.contactTestBitMask = collisionTypes.banana.rawValue
        playerTwo.physicsBody?.isDynamic = false
        
        let playerTwoBuilding = buildings[buildings.count - 2]
        playerTwo.position = CGPoint(x: playerTwoBuilding.position.x, y: playerTwoBuilding.position.y + ((playerTwoBuilding.size.height + playerTwo.size.height) / 2))
        
        addChild(playerTwo)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        guard let firstNode = firstBody.node else {return}
        guard let secondNode = secondBody.node else {return}
        
        if firstNode.name == "banana" && secondNode.name == "building"{
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1"{
            destroy(player: playerOne)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2"{
            destroy(player: playerTwo)
        }
    }
    
    func destroy (player: SKSpriteNode){
        if let explosion = SKEmitterNode(fileNamed: "hitPlayer"){
            explosion.position = player.position
            addChild(explosion)
        }
        player.removeFromParent()
        banana.removeFromParent()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            let newGame = GameScene(size: self.size)
            newGame.viewController = self.viewController
            self.viewController?.currentGame = newGame
            
            self.changePlayer()
            newGame.currentPlayer = self.currentPlayer
            
            let transitions = SKTransition.doorway(withDuration: 1.5)
            self.view?.presentScene(newGame, transition: transitions)
        }
        
    }
    
    func changePlayer (){
        if currentPlayer == 1 {
            currentPlayer = 2
        }else {
            currentPlayer = 1
        }
        viewController?.activatePlayer(number: currentPlayer)
    }
    
    func bananaHit (building: SKNode, atPoint contactpoint: CGPoint){
        guard let building = building as? BuikdingNode else {return}
        let buildingLocation = convert(contactpoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "hitBuilding"){
            explosion.position = contactpoint
            addChild(explosion)
        }
        
        banana.name = ""
        banana.removeFromParent()
        banana = nil
        changePlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else {return}
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }
    }
}
