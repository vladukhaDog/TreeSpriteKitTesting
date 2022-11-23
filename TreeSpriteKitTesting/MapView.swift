//
//  MapView.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 23.11.2022.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        ScrollView(.horizontal){
            Image("map")
                .resizable()
                .scaledToFit()
                .blur(radius: 2)
                .overlay(
                    VStack{
                        ForEach(1...3, id: \.self) { row in
                            HStack{
                                ForEach(1...5, id: \.self) { number in
                                    Spacer()
                                    if Bool.random(){
                                        Menu {
                                            Text("Someones tree #\(row)\(number)")
                                        } label: {
                                            Image("tree")
                                                .resizable()
                                                .scaledToFit()
                                                .shadow(radius: 5)
                                                .frame(height: 200)
                                        }
                                    }

                                    
                                        
                                }
                                Spacer()
                            }
                        }
                    }
                )
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
