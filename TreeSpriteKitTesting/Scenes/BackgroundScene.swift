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
class BackgroundScene: SKScene{
    ///константные настройки
    let particleLimitOnScreen = 120
    let leafCategory  : UInt32 = 0x1 << 1
    let wallCategory: UInt32 = 0x1 << 2
    
    
    ///каким партиклом рисовать
    var particle: Particle?
    
    ///Частица которая расталкивает другие под пальцем
    var touchingNode: SKShapeNode!
    
    ///каждый кадр проверяем, нет ли перерасхода частиц на экране
    override func update(_ currentTime: TimeInterval) {
        ///Если у нас слишком много частиц
        if self.children.count > particleLimitOnScreen{
            ///выбираем какое число удалить от 5 до 10
            let amountToDelete = (5...10).randomElement() ?? 1
            ///Находим самые нижние частицы на экране
            let nodesAtTheBottom = self.children.sorted(by: {$0.position.y < $1.position.y}).prefix(amountToDelete)
            for node in nodesAtTheBottom{
                ///Каждой частице:
                ///Выбираем скорость исчезновения
                let fadeDuration = Array(stride(from: 1, to: 2.0, by: 0.1)).randomElement() ?? 1.0
                ///Выбираем задержку перед исчезновением
                let delayDuration = Array(stride(from: 0.1, to: 2.0, by: 0.5)).randomElement() ?? 0.0
                ///Выключаем физику частице
                node.physicsBody?.collisionBitMask = 0
                ///создаем экшн на исчезновение и задержку перед ним
                let fadeOut = SKAction.fadeOut(withDuration: fadeDuration)
                let delay = SKAction.wait(forDuration: delayDuration)
                ///Запускаем задержку и исчезновение и удаляем частицу по окончанию
                node.run(.sequence([delay, fadeOut])) {
                    node.removeFromParent()
                }
            }
        }
    }
    
    ///начальная настройка сцены
    override func didMove(to view: SKView) {
        ///настройка частицы пальца
        self.touchingNode = SKShapeNode(circleOfRadius: 40)
        self.touchingNode.fillColor = .clear
        self.touchingNode.strokeColor = .clear
        self.touchingNode.position = .init(x: frame.width/2, y: frame.height/2)
        
        addChild(touchingNode)
        self.backgroundColor = .clear
        var origin: CGPoint = frame.origin
        origin.x -= 200
        var size: CGSize = frame.size
        size.height += 60
        size.width += 400
        let rect: CGRect = .init(origin: origin, size: size)
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        physicsBody?.isDynamic = true
        physicsBody?.contactTestBitMask = leafCategory
        physicsBody?.categoryBitMask = wallCategory
        self.name = "border"
        self.physicsWorld.gravity.dy = -0.2
        self.particle = LeafParticle() //SnowParticle()
        let wait = SKAction.wait(forDuration: 1)
        let create = SKAction.run {[weak self] in
            self?.create()
            self?.create()
        }
        self.run(.repeatForever(.sequence([wait, create])))
    }
    
    
    
    ///Движение шара под пальцем
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ///добавляем физику и двигаем под палец
        guard let touch = touches.first else {return}
        touchingNode.position = touch.location(in: self)
        self.touchingNode.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        self.touchingNode.physicsBody?.isDynamic = false
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        touchingNode.position = touch.location(in: self)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ///Убиваем физику
        touchingNode.physicsBody?.isDynamic = false
        touchingNode.physicsBody = nil
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
            box.name = "leaf"
            ///ставим ему отображаемый размер
            box.size = particle.size
            ///распыляем по горизонтали
            let x = CGFloat((0...Int(self.size.width)).randomElement() ?? 0)
            let y = self.size.height + 10
            box.position = .init(x: x, y: y)
            ///рандомно разворачиваем
            box.zRotation = CGFloat((0...360).randomElement() ?? 0)
            ///Создаем физические свойства
            
            ///Назначаем размер физического тела
            var physSize = box.size
            ///В зависимости от настроек, уменьшаем или увеличиваем размер физического тела по сравнению с отображаемым
            physSize.height = physSize.height * particle.physicsSizeMultiplier
            physSize.width = physSize.width * particle.physicsSizeMultiplier
            box.physicsBody = SKPhysicsBody(rectangleOf: physSize)
            box.physicsBody?.categoryBitMask = leafCategory
            box.physicsBody?.contactTestBitMask = wallCategory
            ///В зависимости от настроек ставим прыгучесть
            box.physicsBody?.restitution = particle.restitution
            box.physicsBody?.isDynamic = true
            
            
            ///распыляем по горизонтали во время движения
            let left = Bool.random()
            let move = SKAction.applyImpulse(.init(dx: left ? 1 : -1, dy: 0), duration: 0.2)
            let stop = SKAction.applyImpulse(.init(dx: left ? -1 : 1, dy: 0), duration: 0.4)
            let startRotation = SKAction.rotate(byAngle: left ? -5 : 5, duration: 8)
            let wait = SKAction.wait(forDuration: Double.random(in: 1...3))
            box.run(startRotation)
            let sequence = SKAction.sequence([move, wait, stop, wait])
            box.run(sequence)
            box.run(.fadeIn(withDuration: 0.2))
            ///Добавляем объект в сцену
            
            addChild(box)
            
        }
    }
    
    
}

