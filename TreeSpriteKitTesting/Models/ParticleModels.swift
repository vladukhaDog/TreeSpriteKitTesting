//
//  ParticleModels.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import Foundation
import SwiftUI

struct WaterParticle: Particle{
    var percentToAddPerParticle: Double = 0.1
    
    var percentToRemovePerSecond: Double = 8
    
    var maxPercentToUse: Double = 30
    var id: String = "1"
    var size: CGSize = .init(width: 20, height: 20)
    var barColor: Color = .blue
    
    var delayBeforePhysics: Double = 0
    
    var sprite: String = "waterDrop"
    var restitution: CGFloat = 0.6
    var hasPhysics: Bool = true
    var secondsToDissapear: Double = 0.1
    var spreadMultiplier: Int = 3
    var maxAmount: Int = 4
    var shouldMoveWithFingerVector: Bool = true
}
struct FertilizeParticle: Particle{
    var percentToAddPerParticle: Double = 0.5
    var maxPercentToUse: Double = 10
    var percentToRemovePerSecond: Double = 5
    
    var id: String = "2"
    var size: CGSize = .init(width: 40, height: 40)
    var delayBeforePhysics: Double = 0.2
    var barColor: Color = Color(UIColor.brown)
    var sprite: String = "fert"
    var restitution: CGFloat = 0
    var hasPhysics: Bool = true
    var secondsToDissapear: Double = 0.35
    var spreadMultiplier: Int = 3
    var collidesWithOtherParticles: Bool = false
}

struct LeafParticle: Particle{
    var id: String = "3"
    
    var sprite: String = "leaf"
    
    var hasPhysics: Bool = true
    
    var secondsToDissapear: Double = 7
    
    var delayBeforePhysics: Double = 0
    
    var size: CGSize = .init(width: 30, height: 30)
    
    var barColor: Color = .clear
    
    var percentToAddPerParticle: Double = 0.0
    var maxAmount: Int = 1
    var percentToRemovePerSecond: Double = 0.0
    var collidesWithOtherParticles: Bool = false
    
}

struct SnowParticle: Particle{
    var id: String = "4"
    
    var sprite: String = "snowflake"
    
    var hasPhysics: Bool = true
    
    var secondsToDissapear: Double = 7
    
    var delayBeforePhysics: Double = 0
    
    var size: CGSize = .init(width: 30, height: 30)
    
    var barColor: Color = .clear
    
    var percentToAddPerParticle: Double = 0.0
    
    var percentToRemovePerSecond: Double = 0.0
    var collidesWithOtherParticles: Bool = false
    
}
