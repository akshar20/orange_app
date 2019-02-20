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
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
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
    
    func gameOver(){
        
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
