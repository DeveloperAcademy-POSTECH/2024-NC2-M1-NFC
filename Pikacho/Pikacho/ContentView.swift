//
//  ContentView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var showBookingView: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Spacer().frame(height: 30)
            
            Button(action: {
                showBookingView.toggle()
            }, label: {
                Text("Button")
            })
        }
        .padding()
        .sheet(isPresented: $showBookingView){
            BookingView(showBookingView: $showBookingView)
        }
//        .onAppear {
//            for family in UIFont.familyNames {
//                print(family)
//                
//                for names in UIFont.fontNames(forFamilyName: family) {
//                    print("==\(names)")
//                }
//            }
//        }
    }
}

#Preview {
    ContentView()
}
