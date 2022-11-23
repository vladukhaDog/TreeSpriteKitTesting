//
//  GameViewModel.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import Foundation
import SwiftUI
import Combine
///Список всех партиклов
let allParticles: [Particle] = [WaterParticle(), FertilizeParticle()]
let backgroundParticles: [Particle] = [LeafParticle(), SnowParticle()]
class GameViewModel: ObservableObject{
    ///Выбранный партикл
    @Published var selectedParticle: (Particle)? = WaterParticle()
    ///список активных статусов и их оставшийся процент
    @Published var stats: [String: Double] = [:]
    
    ///Падающий на фоне партикл
    @Published var backgroundFallingParticle: Particle = LeafParticle()
    private var cancellable = Set<AnyCancellable>()
    
    ///игровая сцена
    var scene: GameScene = {
        let scene = GameScene()
        
        scene.scaleMode = .aspectFit
        
        return scene
    }()
    
    ///игровая сцена
    var backgroundScene: BackgroundScene = {
        let scene = BackgroundScene()
        
        scene.scaleMode = .aspectFit
        
        return scene
    }()
    
    init(){
        //при выборе партикла вызываем апдейт сцены
        self.$selectedParticle
            .sink { [weak self] _ in
                self?.update()
            }
            .store(in: &cancellable)
        self.$backgroundFallingParticle
            .sink { [weak self] _ in
                self?.updateBackground()
            }
            .store(in: &cancellable)
        
        //создаем таймер который влияет на статистику
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                self?.decrease()
            }
            .store(in: &cancellable)
        
        //что делать при смене статистики
        self.$stats
            .sink { _ in
                self.checkIfNeedUnselect()
            }
            
            .store(in: &cancellable)
    }
    
    func checkIfNeedUnselect(){
//        for i in stats.map({$0.key}){
//            let value = (stats[i] ?? 0.0)
//            if let particle = allParticles.first(where: {$0.id == i}){
//                if selectedParticle?.id == particle.id, value > particle.maxPercentToUse{
//                    selectedParticle = nil
//                }
//            }
//        }
    }
    
    ///уменьшает значение статуса
    func decrease(){
        for i in stats.map({$0.key}){
            if (stats[i] ?? 0.0) > 0, let particle = allParticles.first(where: {$0.id == i}){
                stats[i] = (stats[i] ?? 0.0) - particle.percentToRemovePerSecond
            }else if let index = stats.index(forKey: i){
                stats.remove(at: index)
            }
        }
    }
    
    ///при применении партикла добавляет нужное количество процентов в статусы
    func particleWasAdded(_ particle: Particle){
        if (stats[particle.id] ?? 0.0) < 100{
            stats[particle.id] = (stats[particle.id] ?? 0.0) + particle.percentToAddPerParticle
        }else{
            stats[particle.id] = 100
        }
    }
    
    ///обновляет сцену под новые данные(партиклы)
    func update(){
        DispatchQueue.main.async {
            self.scene.particle = self.selectedParticle
            self.scene.addedParticleCompletionHandler = self.particleWasAdded(_:)
        }
        
    }
    
    ///обновляет сцену под новые данные(партиклы)
    func updateBackground(){
        DispatchQueue.main.async {
            self.backgroundScene.particle = self.backgroundFallingParticle
        }
        
    }
}
