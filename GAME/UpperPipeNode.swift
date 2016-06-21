//
//  UpperPipeNode.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/20/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class UpperPipeNode: PipeNode {
    init() {
        let txt = SKTexture(imageNamed: "upper_pipe")
        super.init(texture: txt, color: UIColor.clear(), size: txt.size())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
