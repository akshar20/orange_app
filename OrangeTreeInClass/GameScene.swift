//
//  GameScene.swift
//  OrangeTreeInClass
//
//  Created by MacStudent on 2019-02-20.
//  Copyright © 2019 MacStudent. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
   
    // MARK: sprite variables
    var orange:Orange?
    
    // MARK: Variables for aiming the orange
    var mouseStartingPosition:CGPoint = CGPoint(x:0, y:0)
    var lineNode = SKShapeNode()
    
    
    var levelComplete = false
    var currentLevel = 1
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        if(levelComplete == true){
            return
        }
        
        
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if(nodeA?.name == "skull"){
            // Check that the bodies collided hard enough
            if (contact.collisionImpulse) > 15 {
                print("Collision impact: \(contact.collisionImpulse)")
                
                
                // Animate and remove the skull
                let reduceImageSize = SKAction.scale(by: 0.8, duration: 0.5)
                let removeNode = SKAction.removeFromParent()
                
                let seq = SKAction.sequence([reduceImageSize, removeNode])
                nodeA?.run(seq)
                self.gameOver()
            }
            
        }else if(nodeB?.name == "skull"){
            // Check that the bodies collided hard enough
            if (contact.collisionImpulse) > 15 {
                print("Collision impact: \(contact.collisionImpulse)")
                
                
                // Animate and remove the skull
                let reduceImageSize = SKAction.scale(by: 0.8, duration: 0.5)
                let removeNode = SKAction.removeFromParent()
                
                let seq = SKAction.sequence([reduceImageSize, removeNode])
                nodeB?.run(seq)
                self.gameOver()
            }
        }
    }
    
    
    func setLevel(levelNumber:Int) {
        self.currentLevel = levelNumber
    }
    
    
    func gameOver(){
        self.levelComplete = true
        
        let message = SKLabelNode(text:"YOU WIN!")
        message.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        message.fontColor = UIColor.magenta
        message.fontSize = 100
        message.fontName = "AvenirNext-Bold"
        
        addChild(message)
        
        
        // load the next level
        self.currentLevel = self.currentLevel + 1

        
        
        guard let nextLevelScene = GameScene.jumpToNextLevel(levelNumber: self.currentLevel) else{
            print("Error while loading next level")
            return
        }
        
        let waitAction = SKAction.wait(forDuration: 1)
        
        let showNextLevelAction = SKAction.run {
            nextLevelScene.setLevel(levelNumber: self.currentLevel)
            let transition = SKTransition.flipVertical(withDuration: 2)
            nextLevelScene.scaleMode = .aspectFill
            self.scene?.view?.presentScene(nextLevelScene, transition:transition)
        }
        
        let sequence = SKAction.sequence([waitAction, showNextLevelAction])
        
        self.run(sequence)
        // restart the game after 3 seconds
       // perform(#selector(GameScene.restartGame), with: nil, afterDelay: 3)

    }
    
    
    // RESTART GAME
    @objc func restartGame() {
        
            let scene = GameScene(fileNamed:"GameScene")
            scene!.scaleMode = scaleMode
            view?.presentScene(scene)
        
    }
    
    
    // JUMP TO NEXT LEVEL
    class func jumpToNextLevel(levelNumber:Int) -> GameScene?{
        
        let fileName = "GameScene\(levelNumber)"
        
        // DEBUG nonsense
        print("Trying to load file: \(levelNumber).sks")
    
        guard let scene = GameScene(fileNamed: fileName) else {
            print("Cannot find level named: GameScene\(levelNumber).sks")
            return nil
        }
        
        scene.scaleMode = .aspectFill
        return scene
    }


    override func didMove(to view: SKView) {
        
        // add a boundary around the scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // initialize the delegate
        self.physicsWorld.contactDelegate = self
        
        // configure the line
        self.lineNode.lineWidth = 20
        self.lineNode.lineCap = .round
        self.lineNode.strokeColor = UIColor.magenta
        addChild(lineNode)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first  else {
            return
        }

        let mouseLocation = touch.location(in: self)
        print("Finger starting position: \(mouseLocation)")

        // detect what sprite was touched
        let spriteTouched = self.atPoint(mouseLocation)
        
        if (spriteTouched.name == "tree") {
            //print("YOU CLICKED THE TREE")
            // add an orange where the person clicked
            self.orange = Orange()
            orange?.position = mouseLocation
            addChild(self.orange!)
            
            self.orange?.physicsBody?.isDynamic = false
            
            // set the starting position of the finger
            self.mouseStartingPosition = mouseLocation
            
            
        }

    }
    
    
    
    
    // add some more touch functions here
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1. get the touch
        guard let touch = touches.first  else {
            return
        }
        
        // 2. get the location
        let mouseLocation = touch.location(in: self)
        
        // 3. update the position of the orange to match the finger
        self.orange?.position = mouseLocation
        
        // 4. draw a line
        let path = UIBezierPath()
        path.move(to:self.mouseStartingPosition)
        path.addLine(to:mouseLocation)
        self.lineNode.path = path.cgPath
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first  else {
            return
        }
        
        let mouseLocation = touch.location(in: self)
        print("Finger ending position: \(mouseLocation)")

        // 1. get the ending position of the finger
        let orangeEndingPosition = mouseLocation
        
        // 2. get the difference between finger start & end
        let diffX = orangeEndingPosition.x - self.mouseStartingPosition.x
        let diffY = orangeEndingPosition.y - self.mouseStartingPosition.y
        
        // 3. throw the orange based on that direction
        let direction = CGVector(dx: diffX, dy: diffY)
        self.orange?.physicsBody?.isDynamic = true
        self.orange?.physicsBody?.applyImpulse(direction)

        
        // 5. remove the line form the drawing
        self.lineNode.path = nil
        
    }
    
}
