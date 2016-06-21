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

        let gr = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        view.addGestureRecognizer(gr)

        let v = view as! SKView
        v.presentScene(scene)
        scene.pipe_spacing = 250

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scene.start()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scene.stop()
    }

    func didTap() {
        scene.tap();
    }
}

