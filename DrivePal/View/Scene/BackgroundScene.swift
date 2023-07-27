//
//  BackgroundScene.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SpriteKit
import GameplayKit

final class BackgroundScene: SKScene {
    enum BackgroundImageNamed: String {
        case blueSky, redSky, startRunway, finishAirport
    }
    var backgroundImageNamed: BackgroundImageNamed = .blueSky
    
    private var lastTime: TimeInterval = 0
    private var deltaTime: TimeInterval = 0 /// The time in seconds it took to complete the last frame
    private let movePerSecond: CGFloat = 0.7 /// 배경 움직이는 속도 조절
    
    override func didMove(to view: SKView) {
        // game scene
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // background
        for index in 0...1 {
            let background = SKSpriteNode(imageNamed: backgroundImageNamed.rawValue)
            background.size = CGSize(width: self.size.width + 5, height: self.size.height)
            background.anchorPoint = CGPoint(x: 0, y: 0.5)
            background.position = CGPoint(x: self.size.width * CGFloat(index), y: self.size.height / 2)
            background.zPosition = 0
            background.name = "background"
            self.addChild(background)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.backgroundImageNamed = backgroundImageNamed == .blueSky ? .redSky : .blueSky
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        deltaTime = lastTime == 0 ? deltaTime : currentTime - lastTime
        lastTime = currentTime
        
        let moveBackground = movePerSecond * CGFloat(deltaTime)
        self.enumerateChildNodes(withName: "background") { background, _ in
            
            background.position.x -= moveBackground
            // send back to leading
            if background.position.x < -(self.size.width + 5) {
                background.position.x += self.size.width * 2 + 5
            }
        }
    }
}
