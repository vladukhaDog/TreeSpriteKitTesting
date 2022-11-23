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
            
                ZStack{
                    
                    SpriteView(scene: vm.backgroundScene, options: [.allowsTransparency])
                                .transition(.opacity)
//                                .ignoresSafeArea(.container, edges: .top)
                                .background(GeometryReader{geo in
                                    Color.clear
                                        .onAppear{
                                            vm.backgroundScene.size = geo.size
                                        }
                                })
                                .blur(radius: 1)
                                .ignoresSafeArea(.container, edges: .top)
                    VStack(spacing: 0){
                        Image("tree")
                            .resizable()
                            .scaledToFit()
                            .zIndex(2)
                            .offset(x: 0, y: 10)
                        Color(UIColor.brown)
                            .frame(height: 200)
                            .overlay(Image("grass").resizable().scaledToFill())
                            .clipped()
                            .offset(x: 0, y: -10)
                            .zIndex(1)
                    }.offset(x: 0, y: 20)
                  
                    if vm.selectedParticle != nil{
                        SpriteView(scene: vm.scene, options: [.allowsTransparency])
                                    .transition(.opacity)
                                    .background(GeometryReader{geo in
                                        Color.clear
                                            .onAppear{
                                                vm.scene.size = geo.size
                                            }
                                    })
                    }
                            
                }
                .overlay(overlayControls)
                .background(
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .blur(radius: 4)
                )
            
            
        }
    
    private var overlayControls: some View{
        VStack{
            HStack{
                backgroundParticlesSelection

                Spacer()
                activeStatuses
                
            }
            .animation(.default, value: vm.stats)
            .padding()
            Spacer()
            touchParticleSelector
        }
    }
    
    private var backgroundParticlesSelection: some View{
        HStack{
            ForEach(backgroundParticles, id: \.id){particle in
                Group{
                    let selected = particle.sprite == vm.backgroundFallingParticle.sprite
                        Button {
                            vm.backgroundFallingParticle = particle
                        } label: {
                            Image(particle.sprite)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .frame(width: 40, height: 40)
                                .padding(5)
                                .overlay(
                                    Group{
                                        if selected{
                                            Circle().stroke(Color.yellow, lineWidth: 3)
                                        }
                                    }
                                )
                        }
                }
                    
            }
        }
    }
    
    private var activeStatuses: some View{
        HStack{
            ForEach(vm.stats.map({$0.key}), id: \.self){key in
                if let value = vm.stats[key],
                    let particle = allParticles.first(where: {$0.id == key}){
                    HStack{
                        ZStack{
                            Circle()
                                .stroke(
                                    particle.barColor.opacity(0.2),
                                    lineWidth: 5
                                )
                            Circle()
                                .trim(from: 0, to: value/100)
                                .stroke(
                                    particle.barColor,
                                    lineWidth: 5
                                )
                                .rotationEffect(.degrees(-90))
                        }
                            .overlay(
                                Image(particle.sprite)
                                    .resizable()
                                    .scaledToFit()
                                    .padding(5)
                            )
                    }
                    .frame(height: 40)
                }
            }
        }
    }
    
    private var touchParticleSelector: some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(allParticles, id: \.id){particle in
                    Group{
                        let selected = particle.sprite == vm.selectedParticle?.sprite
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
                    }
                        
                }
            }
            .padding(10)
        }
        .frame(maxHeight: 100)
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
