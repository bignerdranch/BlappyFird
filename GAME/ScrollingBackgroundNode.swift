//
//  ScrollingBackgroundScene.swift
//  BlappyFird
//
//  Created by Steve Sparks on 7/2/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

class ScrollingNode: SKEffectNode {
    var imageName : String?
    var rightToCenterSprite = SKSpriteNode(imageNamed: "layer-1")
    var centerToLeftSprite = SKSpriteNode(imageNamed: "layer-1")

    var durationOfScroll = Double(20)

    var overlap = CGFloat(2.0);

    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        if(centerToLeftSprite.parent == nil) {
            centerToLeftSprite.position = center()
            centerToLeftSprite.zPosition = self.zPosition

            var pos = center()
            pos.x = pos.x + rightToCenterSprite.size.width
            rightToCenterSprite.position = pos
            rightToCenterSprite.zPosition = self.zPosition

            let scale = CGFloat(UIScreen.main().bounds.size.height/centerToLeftSprite.texture!.size().height)
            centerToLeftSprite.setScale(scale)
            rightToCenterSprite.setScale(scale)

            addChild(rightToCenterSprite)
            addChild(centerToLeftSprite)
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
        let width = rightToCenterSprite.size.width

        let duration = Double(self.durationOfScroll)

        let act = SKAction.customAction(withDuration: duration, actionBlock: {(node: SKNode, elapsedTime: CGFloat) -> Void in
            let pctComplete = elapsedTime / CGFloat(duration)
            var pos = node.position
            pos.x = ctr.x - CGFloat(width * pctComplete)
            node.position = pos

        })
        return act
    }
    
    func rightCenterAction() -> SKAction {
        let ctr = center()
        let width = rightToCenterSprite.size.width

        let duration = Double(self.durationOfScroll)

        let act = SKAction.customAction(withDuration: duration, actionBlock: {(node: SKNode, elapsedTime: CGFloat) -> Void in
            let pctComplete = elapsedTime / CGFloat(duration)
            var pos = node.position
            pos.x = ctr.x + CGFloat(width * (1-pctComplete)) - self.overlap
            node.position = pos
        })
        return act
    }
    
    func center() -> CGPoint {
        if let screenSize = self.scene?.size {
            return CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        }
        return CGPoint(x: 10, y: 10)
    }

    func setTexture(texture : SKTexture) {
        rightToCenterSprite.texture = texture
        centerToLeftSprite.texture = texture
    }
}
