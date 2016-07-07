//
//  PipePair.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/20/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

protocol PipePairDelegate {
    func didFinish()
}

class PipePair: NSObject {
    var upper = UpperPipeNode()
    var lower = LowerPipeNode()

    var delegate : PipePairDelegate?

    var gapWidth : CGFloat = 120.0
    var gapPosition : CGFloat = 0.0

    var scale : CGFloat = 1.0

    var startingPoint : CGFloat = 500.0

    var pipeOnscreenDuration : CGFloat = 12.0

    init(position: CGPoint, gapWidth: CGFloat) {
        super.init()
        self.gapWidth = gapWidth
        gapPosition = position.y
        startingPoint = position.x
    }

    func go() {
        upper.position = CGPoint(x: startingPoint, y: CGFloat(gapPosition.adding(gapWidth)))
        lower.position = CGPoint(x: startingPoint, y: CGFloat(gapPosition.subtracting(gapWidth)))

        upper.zPosition = 0
        lower.zPosition = 0

        upper.setScale(scale)
        lower.setScale(scale)

        let duration = pipeOnscreenDuration

        var alreadyScored : Bool = false

        let move = SKAction.customAction(withDuration: TimeInterval(duration), actionBlock: {(node: SKNode, elapsedTime: CGFloat) -> Void in
            var pos = node.position
            let pctComplete = CGFloat(elapsedTime / duration)
            pos.x = self.startingPoint - (pctComplete * self.startingPoint)
            node.position = pos
            if(pctComplete > 0.6 && !alreadyScored) {
                alreadyScored = true
                self.scored()
            }
        })
        upper.run(move, completion: {() -> Void in
            self.upper.removeFromParent()
        })
        lower.run(move, completion: {() -> Void in
            self.lower.removeFromParent()
        })
    }

    func children() -> Array<SKNode> {
        return [upper, lower]
    }

    func close() {
        upper.removeAllActions()
        upper.removeFromParent()
        
        lower.removeAllActions()
        lower.removeFromParent()
    }

    func scored() {
        if let del = delegate {
            del.didFinish()
        }
    }
}
