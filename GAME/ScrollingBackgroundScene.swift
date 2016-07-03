//
//  ScrollingBackgroundScene.swift
//  BlappyFird
//
//  Created by Steve Sparks on 7/2/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class ScrollingBackgroundScene: SKScene {
    var backgroundImageName : String?
    var rightToCenterSprite = SKSpriteNode(imageNamed: "layer-1")
    var centerToLeftSprite = SKSpriteNode(imageNamed: "layer-1")

    var durationOfBackgroundScroll = Double(20)

    var backgroundZPosition = CGFloat(-100);

    override init(size: CGSize) {
        super.init(size: size)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setup() {
        if(centerToLeftSprite.parent == nil) {
            centerToLeftSprite.position = center()
            centerToLeftSprite.zPosition = backgroundZPosition

            var pos = center()
            pos.x = pos.x + rightToCenterSprite.size.width
            rightToCenterSprite.position = pos
            rightToCenterSprite.zPosition = backgroundZPosition

            let scale = CGFloat(self.size.height/centerToLeftSprite.texture!.size().height)
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

        let duration = Double(self.durationOfBackgroundScroll)

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

        let duration = Double(self.durationOfBackgroundScroll)

        let act = SKAction.customAction(withDuration: duration, actionBlock: {(node: SKNode, elapsedTime: CGFloat) -> Void in
            let pctComplete = elapsedTime / CGFloat(duration)
            var pos = node.position
            pos.x = ctr.x + CGFloat(width * (1-pctComplete)) - 2
            node.position = pos
        })
        return act
    }
    
    func center() -> CGPoint {
        let screenSize = self.size
        return CGPoint(x: screenSize.width/2, y: screenSize.height/2)
    }
}
