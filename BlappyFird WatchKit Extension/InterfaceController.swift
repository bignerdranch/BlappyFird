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
    }

    func setupScene () {
        skScene.pipeSpacing = 175
        skScene.fontSize = 32
        skScene.gravity = -0.01
        scene.presentScene(skScene)
    }

    override func willActivate() {
        super.willActivate()
        setupScene()
        crownSequencer.delegate = self
        crownSequencer.focus()
        skScene.start()
    }

    override func didDeactivate() {
        super.didDeactivate()
        skScene.stop()
    }

    @IBAction func didTapScene(sender: AnyObject) {
        skScene.tap()
    }

    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        let input = CGFloat(rotationalDelta * 20.0) + skScene.bird_velocity
        if (input < 20.0) {
            skScene.bird_velocity = input
        } else {
            skScene.bird_velocity = 20.0
        }
    }
}
