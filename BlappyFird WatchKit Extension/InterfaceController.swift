//
//  InterfaceController.swift
//  BlappyFird WatchKit Extension
//
//  Created by Steve Sparks on 6/21/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WKCrownDelegate {

    @IBOutlet var scene: WKInterfaceSKScene!

    let skScene = GameScene(size: WKInterfaceDevice.current().screenBounds.size)

    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        skScene.pipe_spacing = 80
        skScene.fontSize = 32
        scene.presentScene(skScene)
    }

    override func willActivate() {
        crownSequencer.delegate = self
        crownSequencer.focus()
        skScene.start()
        super.willActivate()
    }

    override func didDeactivate() {
        skScene.stop()
        super.didDeactivate()
    }

    @IBAction func didTapScene(_ sender: AnyObject) {
        skScene.tap()
    }

    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        skScene.bird_velocity += CGFloat(rotationalDelta * 20.0)
    }
}
