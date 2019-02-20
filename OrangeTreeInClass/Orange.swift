//
//  Orange.swift
//  OrangeTreeInClass
//
//  Created by MacStudent on 2019-02-20.
//  Copyright © 2019 MacStudent. All rights reserved.
//


import SpriteKit
class Orange:SKSpriteNode {
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        // load an orange image & do some config
        // ---------------------------------------
        
        // 1. load the orange image
        let texture = SKTexture(imageNamed:"Orange")
        // 2. set the size of the image
        let size = texture.size()
        // 3. set up the transparency
        let color = UIColor.clear
        
        // 4. call the super() function with the image
        super.init(texture: texture, color: color, size: size)
        
        // 5. add physics to the Orange
        // - use a circular hitbox
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        
       //s self.physicsBody?.affectedByGravity = false
        // by default: all physicsbodies are
        // - affected by gravity
        // - they will respond to collisions (SHOW)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
