//
//  ContentView.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject private var vm = GameViewModel()
    

        var body: some View {
            VStack{
                ZStack{
                    Image("tree")
                        .resizable()
                        .scaledToFit()
                  
                    if vm.selectedParticle != nil{
                        SpriteView(scene: vm.scene, options: [.allowsTransparency])
                                    .frame(width: 400, height: 700)
                                    .transition(.opacity)
                                    .background(GeometryReader{geo in
                                        Color.clear
                                            .onAppear{
                                                vm.scene.size = geo.size
                                            }
                                    })
                    }
                            
                }
                .overlay(VStack{
                    VStack{
                        ForEach(vm.stats.map({$0.key}), id: \.self){key in
                            if let value = vm.stats[key],
                                let particle = allParticles.first(where: {$0.id == key}){
                                HStack{
                                    Image(particle.sprite)
                                    
                                    GeometryReader{geo in
                                        HStack{
                                            particle.barColor
                                                .frame(width: max(geo.size.width * (value / 100), 0.01))
                                                .clipShape(Capsule())
                                            Spacer()
                                        }
                                    }
                                        .frame(height: 30)
                                    
                                }
                            }
                        }
                    }
                    .animation(.default, value: vm.stats)
                    Spacer()
                })
                ScrollView(.horizontal){
                    HStack{
                        ForEach(allParticles, id: \.id){particle in
                            Group{
                                let selected = particle.sprite == vm.selectedParticle?.sprite
//                                let amountAlreadyAdded = vm.stats[particle.id] ?? 0
//                                let canSelect = amountAlreadyAdded <= particle.maxPercentToUse
                                    Button {
                                        vm.selectedParticle = particle
                                    } label: {
                                        Circle().foregroundColor(.gray)
                                            .overlay(Image(particle.sprite))
                                            .overlay(
                                                Group{
                                                    if selected{
                                                        Circle().stroke(Color.yellow, lineWidth: 3)
                                                    }
                                                }
                                            )
                                    }
//                                    .disabled(canSelect)
//                                    .opacity(canSelect ? 0.7 : 1)
                            }
                                
                        }
                    }
                    .padding(10)
                }
                .frame(height: 100)
            }
            
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Double{
    var clean: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesSignificantDigits = false
        numberFormatter.groupingSeparator = ""
        // Rounding down drops the extra digits without rounding.
        numberFormatter.roundingMode = .down
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""//String(format: "%.2f", )// self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(self)
        }
}
