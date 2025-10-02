//
//  GameViewController.swift
//  PlayEase
//
//  Created by sudhanshu kumar on 04/09/25.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var skView: SKView!
    var startView: UIView!
    var ballImageView: UIImageView!
    
    let ballNames = ["soccer", "basketball", "baseball", "tennis", "football", "eightball"]
    var currentBallIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("New print line")
        
        print("New print line")
        print("New print line")

        
        print("New print line")
        print("New print line")
        print("New print line")
        print("New print line")
        // SKView behind start menu
        skView = SKView()
        skView.allowsTransparency = true
        skView.backgroundColor = .clear
        skView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skView)
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            skView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            skView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        // Start menu overlay (half screen height)
        startView = UIView()
        startView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.9)
        startView.layer.cornerRadius = 20
        startView.clipsToBounds = true
        startView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startView)
        NSLayoutConstraint.activate([
            startView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            startView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45)
        ])

        // Animated ball image
        ballImageView = UIImageView()
        ballImageView.contentMode = .scaleAspectFit
        ballImageView.translatesAutoresizingMaskIntoConstraints = false
        startView.addSubview(ballImageView)
        NSLayoutConstraint.activate([
            ballImageView.topAnchor.constraint(equalTo: startView.topAnchor, constant: 80),
            ballImageView.centerXAnchor.constraint(equalTo: startView.centerXAnchor),
            ballImageView.widthAnchor.constraint(equalToConstant: 60),
            ballImageView.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = "Ball Shooter"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        startView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: ballImageView.bottomAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: startView.centerXAnchor)
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = "PlayEase"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        startView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: startView.centerXAnchor)
        ])

        // Play button
        let playButton = UIButton(type: .system)
        playButton.setTitle("PLAY", for: .normal)
        playButton.setTitleColor(.white, for: .normal)
        playButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        playButton.backgroundColor = UIColor.systemGreen
        playButton.layer.cornerRadius = 15
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startView.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: startView.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: startView.bottomAnchor, constant: -60),
            playButton.widthAnchor.constraint(equalToConstant: 180),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Start bounce + image animation
        startBounceAnimation()
    }

    // MARK: - Bounce + change ball animation
    func startBounceAnimation() {
        changeBallImage() // first image
        animateBounce()
    }

    private func changeBallImage() {
        let imageName = ballNames[currentBallIndex]
        ballImageView.image = UIImage(named: imageName)
        currentBallIndex = (currentBallIndex + 1) % ballNames.count
    }

    private func animateBounce() {
        ballImageView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2) // start small
        UIView.animate(withDuration: 0.3, animations: {
            self.ballImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // grow big
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.ballImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0) // back to normal
            }, completion: { _ in
                self.changeBallImage()
                self.animateBounce() // repeat
            })
        })
    }

    @objc func startGame() {
        startView.removeFromSuperview()
        let scene = GameScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool { true }
}
