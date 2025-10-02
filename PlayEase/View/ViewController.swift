//
//  ViewController.swift
//  PlayEase
//
//  Created by sudhanshu kumar on 04/09/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("head")
        // Do any additional setup after loading the view.
    }


}



//import SpriteKit
//
//final class GameScene: SKScene, SKPhysicsContactDelegate {
//    
//    // MARK: - Physics Categories
//    struct PhysicsCategory {
//        static let projectile: UInt32 = 1 << 0
//        static let target:     UInt32 = 1 << 1
//        static let wall:       UInt32 = 1 << 2
//        static let ground:     UInt32 = 1 << 3
//    }
//    
//    // MARK: - Nodes
//    private var scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//    private var timeLabel  = SKLabelNode(fontNamed: "AvenirNext-Bold")
//    private var levelLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//    private let cannon = SKSpriteNode(imageNamed: "cannon")
//    
//    // Textures by name (so names match in collisions)
//    private var ballTextures: [String: SKTexture] = [:]
//    
//    // MARK: - State
//    private var score = 0 { didSet { scoreLabel.text = "SCORE: \(score)" } }
//    private var level = 1 { didSet { levelLabel.text = "LEVEL: \(level)" } }
//    private var timeLeft = 60 {
//        didSet {
//            let minutes = Int(timeLeft) / 60
//            let seconds = Int(timeLeft) % 60
//            timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
//        }
//    }
//    private var gameActive = true
//    
//    private var ballQueue: [SKSpriteNode] = []
//    private let queueSize = 3
//    
//    // MARK: - Lifecycle
//    override func didMove(to view: SKView) {
//        backgroundColor = .clear
//        physicsWorld.contactDelegate = self
//        
//        loadTextures()
//        setupUI()
//        setupBounds()
//        layoutUI()
//        spawnBalls()
//        setupBallQueue()
//        startTimer()
//    }
//    
//    override func didChangeSize(_ oldSize: CGSize) {
//        super.didChangeSize(oldSize)
//        layoutUI()
//        rebuildBounds()
//    }
//    
//    // MARK: - Setup
//    private func loadTextures() {
//        let names = ["soccer", "basketball", "baseball", "tennis", "football", "eightball"]
//        for n in names {
//            ballTextures[n] = SKTexture(imageNamed: n)
//        }
//    }
//    
//    private func setupUI() {
//        addChild(cannon)
//        
//        scoreLabel.fontSize = 20; scoreLabel.fontColor = .green; addChild(scoreLabel)
//        timeLabel.fontSize  = 20; timeLabel .fontColor = .green; addChild(timeLabel)
//        levelLabel.fontSize = 20; levelLabel.fontColor = .green; addChild(levelLabel)
//        
//        score = 0
//        level = 1
//        timeLeft = 60
//    }
//    
//    private func layoutUI() {
//        cannon.position = CGPoint(x: size.width / 2, y: 60)
//        cannon.setScale(0.5)
//        
//        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 40)
//        timeLabel.position  = CGPoint(x: 80,             y: size.height - 40)
//        levelLabel.position = CGPoint(x: size.width - 80, y: size.height - 40)
//    }
//    
//    // MARK: - Bounds
//    private func setupBounds() {
//        childNode(withName: "edge_top")?.removeFromParent()
//        childNode(withName: "edge_left")?.removeFromParent()
//        childNode(withName: "edge_right")?.removeFromParent()
//        childNode(withName: "ground")?.removeFromParent()
//        
//        let top = SKNode()
//        top.name = "edge_top"
//        top.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: size.height),
//                                        to: CGPoint(x: size.width, y: size.height))
//        top.physicsBody?.categoryBitMask = PhysicsCategory.wall
//        top.physicsBody?.collisionBitMask = PhysicsCategory.projectile
//        addChild(top)
//        
//        let left = SKNode()
//        left.name = "edge_left"
//        left.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0),
//                                         to: CGPoint(x: 0, y: size.height))
//        left.physicsBody?.categoryBitMask = PhysicsCategory.wall
//        left.physicsBody?.collisionBitMask = PhysicsCategory.projectile
//        addChild(left)
//        
//        let right = SKNode()
//        right.name = "edge_right"
//        right.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: size.width, y: 0),
//                                          to: CGPoint(x: size.width, y: size.height))
//        right.physicsBody?.categoryBitMask = PhysicsCategory.wall
//        right.physicsBody?.collisionBitMask = PhysicsCategory.projectile
//        addChild(right)
//        
//        let ground = SKNode()
//        ground.name = "ground"
//        ground.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0),
//                                           to: CGPoint(x: size.width, y: 0))
//        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
//        ground.physicsBody?.collisionBitMask = 0
//        ground.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
//        addChild(ground)
//    }
//    
//    private func rebuildBounds() { setupBounds() }
//    
//    // MARK: - Spawn Grid
//    private func spawnBalls() {
//        guard size.width > 0, size.height > 0 else {
//            run(.sequence([.wait(forDuration: 0.01), .run { [weak self] in self?.spawnBalls() }]))
//            return
//        }
//        
//        let rows = 10
//        let cols = 10
//        let ballSize: CGFloat = 30
//        let xPadding: CGFloat = 10
//        let yPadding: CGFloat = 10
//        
//        let totalGridWidth  = CGFloat(cols) * ballSize + CGFloat(cols - 1) * xPadding
//        let startX = (size.width - totalGridWidth) / 2
//        let topMargin: CGFloat = 100
//        let startY = size.height - topMargin
//        
//        for row in 0..<rows {
//            for col in 0..<cols {
//                guard let type = ballTextures.keys.randomElement(),
//                      let tex  = ballTextures[type] else { continue }
//                
//                let ball = SKSpriteNode(texture: tex)
//                ball.size = CGSize(width: ballSize, height: ballSize)
//                ball.position = CGPoint(
//                    x: startX + CGFloat(col) * (ballSize + xPadding) + ballSize / 2,
//                    y: startY - CGFloat(row) * (ballSize + yPadding) - ballSize / 2
//                )
//                ball.zPosition = 5
//                ball.name = type
//                
//                let body = SKPhysicsBody(circleOfRadius: ballSize / 2)
//                body.isDynamic = false
//                body.categoryBitMask = PhysicsCategory.target
//                body.contactTestBitMask = PhysicsCategory.projectile
//                ball.physicsBody = body
//                
//                addChild(ball)
//            }
//        }
//    }
//    
//    // MARK: - Ball Queue
//    private func setupBallQueue() {
//        enumerateChildNodes(withName: "queueBall") { node, _ in
//            node.removeFromParent()
//        }
//        ballQueue.removeAll()
//        
//        for i in 0..<queueSize {
//            guard let type = ballTextures.keys.randomElement(),
//                  let tex  = ballTextures[type] else { continue }
//            
//            let ball = SKSpriteNode(texture: tex)
//            ball.size = CGSize(width: 30, height: 30)
//            ball.name = type
//            ball.userData = ["queue": true]
//            
//            let padding: CGFloat = 40
//            ball.position = CGPoint(
//                x: size.width - 40,
//                y: 100 + CGFloat(i) * padding
//            )
//            ball.zPosition = 10
//            ball.name = "queueBall"
//            
//            addChild(ball)
//            ballQueue.append(ball)
//        }
//    }
//    
//    private func addNewBallToQueue() {
//        guard let type = ballTextures.keys.randomElement(),
//              let tex  = ballTextures[type] else { return }
//        
//        let ball = SKSpriteNode(texture: tex)
//        ball.size = CGSize(width: 30, height: 30)
//        ball.name = type
//        ball.userData = ["queue": true]
//        
//        let padding: CGFloat = 40
//        ball.position = CGPoint(
//            x: size.width - 40,
//            y: 100 + CGFloat(ballQueue.count) * padding
//        )
//        ball.zPosition = 10
//        ball.name = "queueBall"
//        
//        addChild(ball)
//        ballQueue.append(ball)
//    }
//    
//    // MARK: - Shooting
//    private func shootBall(towards location: CGPoint) {
//        guard !ballQueue.isEmpty else { return }
//        
//        let queuedBall = ballQueue.removeFirst()
//        let type = queuedBall.name ?? ""
//        let tex = queuedBall.texture
//        queuedBall.removeFromParent()
//        
//        let ball = SKSpriteNode(texture: tex)
//        ball.size = CGSize(width: 30, height: 30)
//        ball.position = cannon.position
//        ball.zPosition = 6
//        ball.name = type
//        
//        let body = SKPhysicsBody(circleOfRadius: 20)
//        body.isDynamic = true
//        body.usesPreciseCollisionDetection = true
//        body.categoryBitMask = PhysicsCategory.projectile
//        body.collisionBitMask = PhysicsCategory.wall
//        body.contactTestBitMask = PhysicsCategory.target | PhysicsCategory.ground
//        ball.physicsBody = body
//        
//        addChild(ball)
//        
//        let dx = location.x - cannon.position.x
//        let dy = location.y - cannon.position.y
//        let mag = max(0.001, sqrt(dx*dx + dy*dy))
//        let speed: CGFloat = 120.0
//        let impulse = CGVector(dx: (dx / mag) * speed, dy: (dy / mag) * speed)
//        body.applyImpulse(impulse)
//        
//        // Shift queue positions up
//        for (i, b) in ballQueue.enumerated() {
//            let padding: CGFloat = 40
//            let newPos = CGPoint(x: size.width - 40, y: 100 + CGFloat(i) * padding)
//            b.run(SKAction.move(to: newPos, duration: 0.2))
//        }
//        
//        // Add new ball at end
//        addNewBallToQueue()
//    }
//    
//    // MARK: - Touch
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let node = atPoint(location)
//        
//        if node.name == "restartButton" {
//            restartGame()
//            return
//        }
//        
//        if gameActive {
//            let dx = location.x - cannon.position.x
//            let dy = location.y - cannon.position.y
//            let angle = atan2(dy, dx) - .pi / 2
//            
//            let rotate = SKAction.rotate(toAngle: angle, duration: 0.15, shortestUnitArc: true)
//            cannon.run(rotate) {
//                self.shootBall(towards: location)
//            }
//        }
//    }
//    
//    // MARK: - Contacts
//    func didBegin(_ contact: SKPhysicsContact) {
//        let a = contact.bodyA
//        let b = contact.bodyB
//        func node(_ body: SKPhysicsBody) -> SKNode? { body.node }
//        
//        if (a.categoryBitMask & PhysicsCategory.ground) != 0,
//            (b.categoryBitMask & PhysicsCategory.projectile) != 0 {
//            node(b)?.removeFromParent()
//            return
//        }
//        if (b.categoryBitMask & PhysicsCategory.ground) != 0,
//            (a.categoryBitMask & PhysicsCategory.projectile) != 0 {
//            node(a)?.removeFromParent()
//            return
//        }
//        
//        let isProjA = (a.categoryBitMask & PhysicsCategory.projectile) != 0
//        let isProjB = (b.categoryBitMask & PhysicsCategory.projectile) != 0
//        let isTgtA  = (a.categoryBitMask & PhysicsCategory.target) != 0
//        let isTgtB  = (b.categoryBitMask & PhysicsCategory.target) != 0
//        
//        if (isProjA && isTgtB) || (isProjB && isTgtA) {
//            guard let proj = node(isProjA ? a : b) as? SKSpriteNode,
//                  let tgt  = node(isTgtA  ? a : b) as? SKSpriteNode else { return }
//            
//            if proj.name == tgt.name {
//                proj.removeFromParent()
//                tgt.removeFromParent()
//                score += 10
//            } else {
//                proj.removeFromParent()
//            }
//        }
//    }
//    
//    // MARK: - Timer
//    private func startTimer() {
//        let wait = SKAction.wait(forDuration: 1)
//        let tick = SKAction.run { [weak self] in
//            guard let self = self else { return }
//            self.timeLeft -= 1
//            if self.timeLeft <= 0 { self.gameOver() }
//        }
//        run(.repeatForever(.sequence([wait, tick])), withKey: "timer")
//    }
//    
//    // MARK: - Game Over
//    private func gameOver() {
//        removeAction(forKey: "timer")
//        gameActive = false
//        
//        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
//        if score > highScore {
//            UserDefaults.standard.set(score, forKey: "HighScore")
//        }
//        let best = max(score, highScore)
//        
//        let overlay = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.5), cornerRadius: 20)
//        overlay.fillColor = .black.withAlphaComponent(0.7)
//        overlay.strokeColor = .white
//        overlay.lineWidth = 3
//        overlay.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        overlay.zPosition = 100
//        overlay.name = "gameOverOverlay"
//        overlay.isUserInteractionEnabled = false
//        addChild(overlay)
//        
//        let title = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        title.text = "GAME OVER"
//        title.fontSize = 36
//        title.fontColor = .red
//        title.position = CGPoint(x: 0, y: 80)
//        overlay.addChild(title)
//        
//        let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        scoreLabel.text = "Score: \(score)"
//        scoreLabel.fontSize = 28
//        scoreLabel.fontColor = .white
//        scoreLabel.position = CGPoint(x: 0, y: 30)
//        overlay.addChild(scoreLabel)
//        
//        let recordLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        recordLabel.text = "Best: \(best)"
//        recordLabel.fontSize = 24
//        recordLabel.fontColor = .yellow
//        recordLabel.position = CGPoint(x: 0, y: -10)
//        overlay.addChild(recordLabel)
//        
//        let restartButton = SKLabelNode(fontNamed: "AvenirNext-Bold")
//        restartButton.text = "Restart"
//        restartButton.fontSize = 28
//        restartButton.fontColor = .green
//        restartButton.position = CGPoint(x: 0, y: -80)
//        restartButton.name = "restartButton"
//        restartButton.zPosition = overlay.zPosition + 1
//        overlay.addChild(restartButton)
//    }
//    
//    // MARK: - Restart
//    private func restartGame() {
//        removeAction(forKey: "timer")
//        gameActive = true
//        
//        enumerateChildNodes(withName: "gameOverOverlay") { node, _ in
//            node.removeFromParent()
//        }
//        enumerateChildNodes(withName: "//*") { node, _ in
//            if node.name?.contains("ball") == true {
//                node.removeFromParent()
//            }
//        }
//        
//        score = 0
//        timeLeft = 60
//        level = 1
//        
//        layoutUI()
//        setupBounds()
//        spawnBalls()
//        setupBallQueue()
//        startTimer()
//    }
//}
