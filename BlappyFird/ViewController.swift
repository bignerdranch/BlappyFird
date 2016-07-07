//
//  ViewController.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/21/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    let scene = GameScene(size: UIScreen.main().bounds.size)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupForDevice()

        let v = view as! SKView
        v.presentScene(scene)
    }

    func setupForDevice() {
        scene.pipeSpacing = 225
        scene.fontSize = 80

        scene.pipeOnscreenDuration = 5
        scene.pipeSecondsBetweenLaunches = 4

        if let foreground = scene.foreground {
            foreground.durationOfScroll = 15
            foreground.overlap = 50
        } else {
            print("No go on foreground")
        }
        if let background = scene.background {
            background.durationOfScroll = 40
            background.overlap = 12
        }
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scene.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene.stop()
    }

    @IBAction func didTap() {
        scene.tap()
    }
}

