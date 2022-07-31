//
//  GameScene.swift
//  Project11
//
//  Created by Juliano Santos on 28/7/22.
//


import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var editLabel: SKLabelNode!
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Bars:Yes"
            } else {
                editLabel.text = "Bars:No"
            }
        }
    }

    var randomColorBallLabel: SKLabelNode!
    var randomColorBall: Bool = false {
        didSet {
            if randomColorBall {
                randomColorBallLabel.text = "R.Color:Yes"
            } else {
                randomColorBallLabel.text = "R.Color:No"
            }
        }
    }

    var numberBallLabel: SKLabelNode!
    var numberBall = 5 {
        didSet {
            numberBallLabel.text = "N. Balls: \(numberBall)"
        }
    }

    var turboModeLabel: SKLabelNode!
    var turboMode: Bool = false {
        didSet {
            if turboMode {
                turboModeLabel.text = "Turbo:Yes"
            } else {
                turboModeLabel.text = "Turbo:No"
            }
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y:0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))

        let scaleLabelHight = 730
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 990, y: scaleLabelHight)
        addChild(scoreLabel)

        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Bars:No"
        editLabel.position = CGPoint(x: 70, y: scaleLabelHight)
        addChild(editLabel)
        
        randomColorBallLabel = SKLabelNode(fontNamed: "Chalkduster")
        randomColorBallLabel.text = "R. Color: No"
        randomColorBallLabel.position = CGPoint(x: 280, y: scaleLabelHight)
        addChild(randomColorBallLabel)
        
        numberBallLabel = SKLabelNode(fontNamed: "Chalkduster")
        numberBallLabel.text = "N. Balls: 5"
        numberBallLabel.position = CGPoint(x: 715, y: scaleLabelHight)
        addChild(numberBallLabel)
        
        turboModeLabel = SKLabelNode(fontNamed: "Chalkduster")
        turboModeLabel.text = "Turbo:No"
        turboModeLabel.position = CGPoint(x: 500, y: scaleLabelHight)
        addChild(turboModeLabel)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let objects = nodes(at: location)

            if objects.contains(editLabel) {
                editingMode = !editingMode
            } else if objects.contains(randomColorBallLabel) {
                randomColorBall = !randomColorBall
            } else if objects.contains(turboModeLabel) {
                turboMode = !turboMode
            } else {
                if editingMode {
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location

                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false

                    addChild(box)
                } else {
                    
                    // location limit for create ball
                    if turboMode && (location.y < 580 || location.y > 700) { return }
                    
                    //Enable random ball color
                    var ballColor = "ballBlue"
                    if randomColorBall {
                        let listBall = ["ballRed","ballYellow","ballPurple","ballGrey","ballGreen","ballCyan","ballBlue"]
                        ballColor = listBall[Int.random(in: 0..<listBall.count)]
                    }
                    
                    let ball = SKSpriteNode(imageNamed: ballColor)
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position = location
                    ball.name = "ball"
                    addChild(ball)
                    
                    if turboMode {
                        numberBall -= 1
                    }
                }
            }
        }
    }

    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        bouncer.name = "bouncer"
        addChild(bouncer)
    }

    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotGlow.position = position

        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false

        addChild(slotBase)
        addChild(slotGlow)

        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }

    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball, object: object)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball, object: object)
            score -= 1
        }
        
        if turboMode && object.name == "bouncer" {
            destroy(ball: object, object: object)
        }
    }

    func destroy(ball: SKNode, object: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        if turboMode && object.name == "good" {
            numberBall += 1
        }
        ball.removeFromParent()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
}
