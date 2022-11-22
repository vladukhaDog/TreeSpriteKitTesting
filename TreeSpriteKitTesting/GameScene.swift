//
//  GameScene.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    var particle: Particle?
    var addedParticleCompletionHandler: ((Particle) -> ())?
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        physicsBody = SKPhysicsBody()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        create(touches)
    }
    func create(_ touches: Set<UITouch>){
        guard let particle else {return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for _ in 0..<particle.maxAmount{
            
            let box = SKSpriteNode(imageNamed: particle.sprite)
            box.size = particle.size
            var loc = location
            loc.x += CGFloat(((particle.spreadRange).randomElement() ?? 0) * particle.spreadMultiplier)
            loc.y += CGFloat(((particle.spreadRange).randomElement() ?? 0) * particle.spreadMultiplier)
            box.position = loc
            var physSize = box.size
            physSize.height = physSize.height * particle.physicsSizeMultiplier
            physSize.width = physSize.width * particle.physicsSizeMultiplier
            box.physicsBody = SKPhysicsBody(rectangleOf: physSize)
            box.physicsBody?.restitution = particle.restitution
            box.physicsBody?.isDynamic =  false
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + particle.delayBeforePhysics) {[box] in
                box.physicsBody?.isDynamic = particle.hasPhysics
                if !particle.collidesWithOtherParticles{
                    box.physicsBody?.collisionBitMask = 0
                }
                if particle.shouldMoveWithFingerVector{
                    let prev = touch.previousLocation(in: self)
                    let moveX = location.x - prev.x
                    let moveY = location.y - prev.y
                    
                    box.physicsBody?.applyForce(.init(dx: moveX * 5, dy: moveY * 5))
                }
            }
            addChild(box)
            DispatchQueue.main.asyncAfter(deadline: .now() + particle.secondsToDissapear) {[box] in
                box.run(.fadeOut(withDuration: 0.2)) {
                    box.removeFromParent()
                    (self.addedParticleCompletionHandler ?? {_ in})(particle)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        create(touches)
    }
}
