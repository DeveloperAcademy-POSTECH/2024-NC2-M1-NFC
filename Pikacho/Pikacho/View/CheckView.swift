//
//  CheckView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/19/24.
//

//import SwiftUI
//
//struct CheckView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    CheckView()
//}

//
//  ContentView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/17/24.
//

import SwiftUI
import SwiftData

struct CheckView: View {
    
    @State private var showYeView: Bool = false
    @State private var bookings: [PCBooking] = []
    
    var body: some View {
        VStack {
            Button(action: {
                showYeView.toggle()
            }, label: {
                Text("예약하기")
            })
            .padding()

            List(bookings) { booking in
                VStack(alignment: .leading) {
                    Text("Name: \(booking.name)")
                    Text("Purpose: \(booking.perposeOfReservation ?? "N/A")")
                    Text("Number of People: \(booking.numberOfPeople ?? 0)")
                    Text("Password: \(booking.password)")
                    //Text("Color: \(booking.colorOfRow.rawValue)")
                    Text("Color: \(booking.colorOfRow.tabkeBackgroundColor.description)")

                }
                .padding()
                .background(booking.colorOfRow.tabkeBackgroundColor)
                .cornerRadius(8)
            }
        }
        .onAppear {
            loadBookings()
        }
        .sheet(isPresented: $showYeView) {
            BookingView(showYeView: $showYeView)
                .onDisappear {
                    loadBookings()
                }
        }
    }

    private func loadBookings() {
        self.bookings = DataManager.shared.getAllBookings()
    }
}

#Preview {
    CheckView()
}

