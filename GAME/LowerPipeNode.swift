//
//  LowerPipeNode.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/20/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class LowerPipeNode: PipeNode {
    init() {
        let txt = SKTexture(imageNamed: "lower_pipe")
        super.init(texture: txt, color: UIColor.clear(), size: txt.size())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
