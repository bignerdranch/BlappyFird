//
//  GameScene.swift
//  BlappyFird
//
//  Created by Steve Sparks on 6/18/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, PipePairDelegate {

    enum Category: UInt32 {
        case Bird = 0x01
        case Pipe = 0x02
        case Nothing = 0x00
    }

    var foreground : BackgroundScroller?
    var background : BackgroundScroller?

    var bird = PlayerNode()
    var score : Int = 0
    var fontSize : CGFloat = 96

    var bird_velocity = CGFloat(0.0)
    var birdY = CGFloat(100.0)


    // bird behavior constants
    var gravity = CGFloat(-1.0)
    let springiness = CGFloat(0.8)
    let floor = CGFloat(10.0)

    var timer : Timer?
    var pipetimer : Timer?

    var pipeSpacing = CGFloat(200)
    var pipeOnscreenDuration : CGFloat = 4.0
    var pipeSecondsBetweenLaunches : CGFloat = 5.0

    override init(size: CGSize) {
        super.init(size: size)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        gravity = -2.0
        background = BackgroundScroller(scene: self, imageName: "layer-1")
        foreground = BackgroundScroller(scene: self, imageName: "layer-2")

        if let bg = background {
            bg.durationOfScroll = 20
            bg.zPosition = -100
            bg.overlap = 10.0
            bg.setup()
        }

        if let fg = foreground {
            fg.durationOfScroll = 6
            fg.zPosition = 100
            fg.overlap = 38.0
            fg.setup()
        }

        bird.zPosition = 0
        physicsWorld.contactDelegate = self

        addChild(bird)
        updateBirdPosition()
    }

    var currentPair : PipePair?

    func birdPosition() -> CGPoint {
        return CGPoint(x: self.size.width / 2, y: birdY)
    }

    func updateBirdPosition() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        bird_velocity += gravity
        // check for a bounce
        var newPos = birdY + bird_velocity
        if newPos < floor {
            bird_velocity = 0 - (bird_velocity * springiness)
            newPos = floor
        }
        birdY = newPos
        bird.position = birdPosition()
        bird.zRotation = (bird_velocity / 75)
    }

    func newPipe() {
        let ctr = center()
        let y = CGFloat(arc4random() % 100) + CGFloat(ctr.y) - 50.0
        let startingPoint = CGPoint(x: CGFloat(ctr.x * 2.25), y: y)
        let pair = PipePair(position: startingPoint, gapWidth: pipeSpacing )
        pair.pipeOnscreenDuration = pipeOnscreenDuration

        let upper = pair.upper
        let lower = pair.lower
        self.addChild(upper)
        self.addChild(lower)
        pair.delegate = self
        currentPair = pair
        pair.go()
    }

    func start() {
        bird_velocity = 0.0
        
        birdY = center().y
        bird.position = birdPosition()
        bird.startFlapping()

        timer = Timer.scheduledTimer(timeInterval: (1/15.0), target: self, selector: #selector(GameScene.updateBirdPosition), userInfo: nil, repeats: true)

        pipetimer = Timer.scheduledTimer(timeInterval: TimeInterval(pipeSecondsBetweenLaunches), target: self, selector: #selector(GameScene.newPipe), userInfo: nil, repeats: true)

        if let bg = background {
            bg.moveBackground()
        }
        if let fg = foreground {
            fg.moveBackground()
        }
    }

    func stop() {
        // shut down the timers
        if let t = timer {
            t.invalidate()
            timer = nil
        }
        if let t = pipetimer {
            t.invalidate()
            pipetimer = nil
        }
        if let bg = background {
            bg.stopBackground()
        }
        if let fg = foreground {
            fg.stopBackground()
        }
        bird.stopFlapping()
        if let pair = currentPair {
            pair.close()
        }
    }

    // handling the bird/pipe collision

    func didBegin(_ contact: SKPhysicsContact) {
        var bird = contact.bodyA
        var pipe = contact.bodyB

        if(bird.categoryBitMask == Category.Pipe.rawValue) { // reversed
            let t = bird
            bird = pipe
            pipe = t
        }

        if(bird.categoryBitMask == Category.Bird.rawValue &&
            pipe.categoryBitMask == 0x02) {

            if let pair = currentPair {
                crash(bird: bird, pipe: pipe, pair: pair)
            }
        }
    }

    func crash(bird: SKPhysicsBody, pipe: SKPhysicsBody, pair: PipePair) {
        score = 0
        announce()
        pair.close()
    }

    // utilities

    func tap() {
        bird_velocity = 14
    }

    func didFinish() {
        score += 1
        announce()
    }

    func announce() {
        let node = SKLabelNode(text: "\(score)")
        node.position = center()
        node.fontColor = UIColor.black()
        node.fontName = "Helvetica"
        node.fontSize = fontSize

        addChild(node)

        let scaleAction = SKAction.fadeAlpha(to: 0, duration: 1)
        let moveAction = SKAction.moveTo(y: self.size.height, duration: 1)
        let action = SKAction.group([scaleAction, moveAction])

        node.run(action, completion: {(Void) -> Void in
            node.removeFromParent()
        })
    }

    func center() -> CGPoint {
        let screenSize = self.size
        return CGPoint(x: screenSize.width/2, y: screenSize.height/2)
    }
}
