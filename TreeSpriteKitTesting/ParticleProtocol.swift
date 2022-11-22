//
//  ParticleProtocol.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import Foundation
import SwiftUI
protocol Particle{
    var id: String {get set}
    var sprite: String {get set}
    var restitution: CGFloat {get set}
    var hasPhysics: Bool {get set}
    var spreadMultiplier: Int {get set}
    var spreadRange: ClosedRange<Int> {get set}
    var physicsSizeMultiplier: Double {get set}
    var maxAmount: Int {get set}
    var secondsToDissapear: Double {get set}
    var delayBeforePhysics: Double {get set}
    var collidesWithOtherParticles: Bool {get set}
    var size: CGSize {get set}
    var shouldMoveWithFingerVector: Bool {get set}
    var barColor: Color {get set}
    var percentToAddPerParticle: Double {get set}
    var percentToRemovePerSecond: Double {get set}
    var maxPercentToUse: Double {get set}
}

extension Particle{
    var physicsSizeMultiplier: Double{
        get{
            return 0.7
        }
        set {}
    }
    var shouldMoveWithFingerVector: Bool{
        get{
            return false
        }
        set {}
    }
    var spreadMultiplier: Int{
        get{
            return 5
        }
        set{ }
    }
    var spreadRange: ClosedRange<Int>{
        get{
            return (-5...4)
        }
        set {}
    }
    var maxAmount: Int{
        get{
            return (2...4).randomElement() ?? 2
        }
        set {}
    }
    var collidesWithOtherParticles: Bool{
        get{
            return true
        }
        set {}
    }
}

