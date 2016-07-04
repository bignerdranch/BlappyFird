//
//  ViewController.swift
//  Blappy Fird
//
//  Created by Steve Sparks on 6/24/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit
import SpriteKit
class TVViewController: UIViewController {
    let scene = GameScene(size: UIScreen.main().bounds.size)


    override func viewDidLoad() {
        super.viewDidLoad()

        let v = view as! SKView
        v.presentScene(scene)
        scene.pipe_spacing = 450

        let tap = UITapGestureRecognizer(target: self, action: #selector(TVViewController.didTap))

        tap.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)];
        tap.allowedTouchTypes = [NSNumber(value: UITouchType.direct.rawValue)];

        v.addGestureRecognizer(tap);
        v.isUserInteractionEnabled = true
        
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
    
    @IBAction func didTap() {
        scene.tap();
    }
    
    
}

