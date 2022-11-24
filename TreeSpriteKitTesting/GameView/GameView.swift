//
//  ContentView.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 22.11.2022.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                 Color(UIColor.brown)
                     .frame(height: 200)
                     .overlay(Image("grass").resizable().scaledToFill())
                     .clipped()
                     .offset(x: 0, y: -10)
                     .zIndex(1)
                     .ignoresSafeArea(.container, edges: .bottom)
            }
            backgroundScene
            tree
                .allowsHitTesting(false)
            interactiveScene
                .ignoresSafeArea(.container, edges: .top)
                .allowsHitTesting(vm.selectedParticle != nil)
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
    
    private var backgroundScene: some View{
        SpriteView(scene: vm.backgroundScene, options: [.allowsTransparency])
            .transition(.opacity)
            .background(GeometryReader{geo in
                Color.clear
                    .onAppear{
                        vm.backgroundScene.size = geo.size
                    }
            })
            .blur(radius: 1)
            .ignoresSafeArea(.container, edges: [.top, .bottom])
    }
    private var tree: some View{
        VStack(spacing: 0){
            Spacer()
            Image("tree")
                .resizable()
                .scaledToFit()
                .zIndex(2)
                .offset(x: 0, y: 10)
            Color.clear
                .frame(height: 200)
                .clipped()
                .offset(x: 0, y: -10)
                .zIndex(1)
                .ignoresSafeArea(.container, edges: .bottom)
        }.offset(x: 0, y: 20)
    }
    
    private var interactiveScene: some View{
        SpriteView(scene: vm.scene, options: [.allowsTransparency])
            .transition(.opacity)
            .background(GeometryReader{geo in
                Color.clear
                    .onAppear{
                        vm.scene.size = geo.size
                    }
            })
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
            touchParticleSelector
            Spacer()
            
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
                                .shadow(radius: 5)
                        }
                        .overlay(
                            Image(particle.sprite)
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                        )
                    }
                    .frame(width: 45,height: 45)
                }
            }
        }
    }
    
    private var touchParticleSelector: some View{
        
            HStack{
                ForEach(allParticles, id: \.id){particle in
                    Group{
                        let selected = particle.sprite == vm.selectedParticle?.sprite
                        Button {
                            if vm.selectedParticle?.id == particle.id{
                                vm.selectedParticle = nil
                            }else{
                                vm.selectedParticle = particle
                            }
                        } label: {
                            Image(particle.sprite).resizable().scaledToFit().padding(8)
                                .background(
                                    Group{
                                        
                                        Circle().fill(Color.white)
                                            .blur(radius: 2)
                                            .shadow(radius: 6)
                                            .opacity(selected ? 1 : 0)
                                        
                                    }
                                )
                        }
                    }
                    .frame(width: 60,height: 60)
                    
                }
                Spacer()
            }
            .padding(10)
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}


