//
//  GameViewModel.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import Foundation
import SwiftUI
import Combine

let allParticles: [Particle] = [WaterParticle(), FertilizeParticle()]

class GameViewModel: ObservableObject{
    @Published var selectedParticle: (Particle)? = WaterParticle()
    @Published var stats: [String: Double] = [:]
    private var cancellable = Set<AnyCancellable>()
    var scene: GameScene = {
        let scene = GameScene()
        
        scene.scaleMode = .aspectFit
        
        return scene
    }()
    
    init(){
        self.$selectedParticle
            .sink { [weak self] _ in
                self?.update()
            }
            .store(in: &cancellable)
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink {[weak self] _ in
                self?.decrease()
            }
            .store(in: &cancellable)
        
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
    
    func decrease(){
        for i in stats.map({$0.key}){
            if (stats[i] ?? 0.0) > 0, let particle = allParticles.first(where: {$0.id == i}){
                stats[i] = (stats[i] ?? 0.0) - particle.percentToRemovePerSecond
            }else if let index = stats.index(forKey: i){
                stats.remove(at: index)
            }
        }
    }
    
    
    func particleWasAdded(_ particle: Particle){
        if (stats[particle.id] ?? 0.0) < 100{
            stats[particle.id] = (stats[particle.id] ?? 0.0) + particle.percentToAddPerParticle
        }else{
            stats[particle.id] = 100
        }
    }
    
    func update(){
        DispatchQueue.main.async {
            self.scene.particle = self.selectedParticle
            self.scene.addedParticleCompletionHandler = self.particleWasAdded(_:)
        }
        
    }
}
