//
//  InterfaceController.swift
//  BlappyFird WatchKit Extension
//
//  Created by Steve Sparks on 6/21/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var scene: WKInterfaceSKScene!

    let skScene = GameScene(size: WKInterfaceDevice.current().screenBounds.size)

    override func awake(withContext context: AnyObject?) {
        super.awake(withContext: context)
        skScene.pipe_spacing = 140
        scene.presentScene(skScene)
    }

    override func willActivate() {
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
}
