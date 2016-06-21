//
//  PlayerNode.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/18/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    let bird1 = SKTexture(imageNamed: "bird1")
    let bird2 = SKTexture(imageNamed: "bird2")
    let bird3 = SKTexture(imageNamed: "bird3")

    var tileIndex = 0

    var timer : Timer?

    init() {
        let txt = bird1
        super.init(texture: txt, color: UIColor.clear(), size: txt.size())
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        if let txt = self.texture {
            let body = SKPhysicsBody(rectangleOf: txt.size())
            body.isDynamic = true
            body.categoryBitMask = GameScene.Category.Bird.rawValue;
            body.contactTestBitMask = GameScene.Category.Pipe.rawValue;
            body.collisionBitMask = GameScene.Category.Nothing.rawValue;
            body.usesPreciseCollisionDetection = true
            self.physicsBody = body;
        }
    }

    func startFlapping() {
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(PlayerNode.flap), userInfo: nil, repeats: true)
    }

    func stopFlapping() {
        if let t = timer {
            t.invalidate()
        }
    }

    func flap() {
        tileIndex += 1
        if (tileIndex >= 4) {
            tileIndex = 0
        }

        switch tileIndex {
        case 0:
            self.texture = bird1
            break
        case 1, 3:
            self.texture = bird2
            break
        case 2:
            self.texture = bird3
            break
        default:
            break
        }
    }
}

