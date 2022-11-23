//
//  BackgroundScene.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 23.11.2022.
//

import Foundation
import SpriteKit
import Combine
///Игровая сцена, которая рисует партиклы на фоне
class BackgroundScene: SKScene {
    private var cancellable = Set<AnyCancellable>()
    ///каким партиклом рисовать
    var particle: Particle?
    
    
    ///начальная настройка сцены
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsWorld.gravity.dy = -0.2
        self.particle = LeafParticle() //SnowParticle()
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                self?.create()
                self?.create()
            }
            .store(in: &cancellable)
    }
    
    deinit{
        cancellable.removeAll()
    }
    
    
    //MARK: - Логика рисовки
    ///рисует партикл на экране
    func create(){
        ///проверяем, что у нас всё есть для дальнейшей работы
        guard let particle else {return }
        
        ///рисуем столько партиклов за один раз, сколько указано в настройках
        for _ in 0..<particle.maxAmount{
            
            ///Создаем спрайт
            let box = SKSpriteNode(imageNamed: particle.sprite)
            ///ставим ему отображаемый размер
            box.size = particle.size
            
            let x = CGFloat((0...Int(self.size.width)).randomElement() ?? 0)
            let y = self.size.height + CGFloat((80...120).randomElement() ?? 0)
            box.position = .init(x: x, y: y)
            box.zRotation = CGFloat((0...360).randomElement() ?? 0)
            ///Создаем физические свойства
            
            ///Назначаем размер физического тела
            var physSize = box.size
            ///В зависимости от настроек, уменьшаем или увеличиваем размер физического тела по сравнению с отображаемым
            physSize.height = physSize.height * particle.physicsSizeMultiplier
            physSize.width = physSize.width * particle.physicsSizeMultiplier
            box.physicsBody = SKPhysicsBody(rectangleOf: physSize)
            
            ///В зависимости от настроек ставим прыгучесть
            box.physicsBody?.restitution = particle.restitution
            
            box.physicsBody?.isDynamic = true
            if !particle.collidesWithOtherParticles{
                box.physicsBody?.collisionBitMask = 0
            }
            let left = Bool.random()
            let move = SKAction.applyImpulse(.init(dx: left ? 1 : -1, dy: 0), duration: 0.2)//applyForce(.init(dx: Bool.random() ? 1 : -1, dy: 0), duration: 1)
            let stop = SKAction.applyImpulse(.init(dx: left ? -1 : 1, dy: 0), duration: 0.4)
            let wait = SKAction.wait(forDuration: Double.random(in: 1...3))
            
            let sequence = SKAction.sequence([move, wait, stop, wait])
            box.run(sequence)
            ///Добавляем объект в сцену
            addChild(box)
            ///В зависимости от настроек, вызываем пропадание объекта из сцены
            DispatchQueue.main.asyncAfter(deadline: .now() + particle.secondsToDissapear) {[box] in
                box.run(.fadeOut(withDuration: 1)) {
                    box.removeFromParent()
                }
            }
        }
    }
    
    
}

