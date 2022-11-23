//
//  MyTreesView.swift
//  TreeSpriteKitTesting
//
//  Created by Permyakov Vladislav on 23.11.2022.
//

import SwiftUI

struct MyTreesView: View {
    var body: some View {
        ScrollView{
            VStack{
                ForEach(1...15, id: \.self){number in
                    HStack{
                        Image("tree")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                        Text("My tree #\(number)")
                        Spacer()
                    }
                    Divider()
                }
            }.padding()
        }
    }
}

struct MyTreesView_Previews: PreviewProvider {
    static var previews: some View {
        MyTreesView()
    }
}
