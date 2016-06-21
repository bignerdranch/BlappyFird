//
//  PipeNode.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/18/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class PipeNode: SKSpriteNode {
    var pairedNode : SKSpriteNode?

    internal override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        if let txt = texture {
            let body = SKPhysicsBody(rectangleOf: txt.size());
            body.isDynamic = true;
            body.categoryBitMask = GameScene.Category.Pipe.rawValue;
            body.contactTestBitMask = GameScene.Category.Bird.rawValue;
            body.collisionBitMask = GameScene.Category.Nothing.rawValue;
            body.usesPreciseCollisionDetection = true;
            self.physicsBody = body;
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
