//
//  ContentView.swift
//  Filest
//
//  Created by Hassan Khan on 2021-03-23.
//  Copyright © 2021 Z-Lux. All rights reserved.
//

import Foundation
import SwiftUI

struct CircleView: View {
    @State var image: UIImage
    
    var body: some View {
        ZStack{
            Image(uiImage: image)
                .frame(width: 40, height: 40, alignment: .center)
        }
    }
}
struct horizontalView: View{
    var body: some View {
        VStack{
            Divider()
            ScrollView(.horizontal){
                HStack(alignment: .center, spacing: 5){
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    ForEach(0..<AbsentSingleton.getto().count){ i in
                        if let cachedImage = delegate.contactsCache.object(forKey: (AbsentSingleton.getto()[i]+".png") as NSString) {
                            CircleView(image: cachedImage)
                        }
                        
                    }

                }.padding()
            }.frame(height: 100)
            Divider()
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider{
    static var previews: some View {
        horizontalView()
    }
}
