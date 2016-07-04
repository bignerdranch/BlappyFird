//
//  BackgroundScroller.swift
//  BlappyFird
//
//  Created by Steve Sparks on 7/3/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class BackgroundScroller: NSObject {
    var scene: SKScene

    var imageName : String?
    var rightToCenterSprite : SKSpriteNode
    var centerToLeftSprite : SKSpriteNode

    var durationOfScroll = Double(20)
    var zPosition : CGFloat

    var overlap = CGFloat(2.0);

    init(scene: SKScene, imageName: String) {
        self.scene = scene
        self.imageName = imageName
        self.rightToCenterSprite = SKSpriteNode(imageNamed: imageName)
        self.centerToLeftSprite = SKSpriteNode(imageNamed: imageName)
        self.zPosition = 0.0;
        super.init()
    }

    func setup() {
        if(centerToLeftSprite.parent == nil) {
            centerToLeftSprite.position = center()
            centerToLeftSprite.zPosition = self.zPosition

            var pos = center()
            pos.x = pos.x + rightToCenterSprite.size.width
            rightToCenterSprite.position = pos
            rightToCenterSprite.zPosition = self.zPosition

            let scale = CGFloat(scene.size.height/centerToLeftSprite.texture!.size().height)
            centerToLeftSprite.setScale(scale)
            rightToCenterSprite.setScale(scale)

            scene.addChild(rightToCenterSprite)
            scene.addChild(centerToLeftSprite)
        }
    }

    func stopBackground() {
        centerToLeftSprite.removeAllActions()
        rightToCenterSprite.removeAllActions()
    }

    func moveBackground() {
        if (!centerToLeftSprite.hasActions()) {
            nextBackground()
        }
    }

    func nextBackground() {
        centerToLeftSprite.position = center()
        var pos = center()
        pos.x = pos.x + rightToCenterSprite.size.width
        rightToCenterSprite.position = pos

        let completion = {() -> Void in
            self.nextBackground()
        }

        centerToLeftSprite.run(centerLeftAction(), completion: completion)
        rightToCenterSprite.run(rightCenterAction())
    }

    func centerLeftAction() -> SKAction {
        let ctr = center()
        let width = centerToLeftSprite.size.width

        let duration = CGFloat(self.durationOfScroll)

        let act = SKAction.customAction(withDuration: Double(duration), actionBlock: {(node: SKNode, elapsedTime: CGFloat) -> Void in
            let pctComplete = elapsedTime / duration
            var pos = node.position
            pos.x = ctr.x - width * pctComplete
            node.position = pos
        })
        return act
    }

    func rightCenterAction() -> SKAction {
        let ctr = center()
        let width = rightToCenterSprite.size.width

        let duration = CGFloat(self.durationOfScroll)

        let act = SKAction.customAction(withDuration: Double(duration), actionBlock: {(node: SKNode, elapsedTime: CGFloat) -> Void in
            let pctComplete = elapsedTime / duration
            var pos = node.position
            pos.x = ctr.x + width * (1-pctComplete) - self.overlap
            node.position = pos
        })
        return act
    }

    func center() -> CGPoint {
        let screenSize = self.scene.size
        return CGPoint(x: screenSize.width/2, y: screenSize.height/2)
    }

    func setTexture(texture : SKTexture) {
        rightToCenterSprite.texture = texture
        centerToLeftSprite.texture = texture
    }

    func physicsBody() -> SKPhysicsBody {
        let body = SKPhysicsBody(rectangleOf: scene.size);
        body.isDynamic = true;
        body.categoryBitMask = GameScene.Category.Pipe.rawValue;
        body.contactTestBitMask = GameScene.Category.Bird.rawValue;
        body.collisionBitMask = GameScene.Category.Nothing.rawValue;
        body.usesPreciseCollisionDetection = true;
        return body;
    }
}
