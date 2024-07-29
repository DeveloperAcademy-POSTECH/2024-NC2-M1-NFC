//
//  ContentView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/17/24.
//

import SwiftUI

//날짜 설정 뷰
struct ContentView: View {
    @State private var showYeView: Bool = false
    @State private var showUpdateView: Bool = false
    @State private var bookings: [PCBooking] = []
    @State private var selectedBooking: PCBooking?
    @State private var selectedTimeSlots: [Int] = [] 

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("MeetingRoom#1").font(.system(size: 30, weight: .bold))
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
            Text("Time Table")
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 4)
            Text("Sat, 15 June, 2024")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.bottom, 16)

            HStack {
                VStack {
                    Spacer().frame(height:16)
                    ForEach(9..<23) { hour in
                        Text("\(hour % 12 == 0 ? 12 : hour % 12) \(hour < 12 ? "AM" : "PM")").font(.system(size: 12))
                        Spacer().frame(height: 30)
                    }
                }
                ZStack {
                    VStack(spacing: 4) {
                        ForEach(0..<13) { index in
                            TableViewForReservation(index: index)
                        }
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 309, height: 1)
                    }
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 1, height: 584)
                        .offset(x: -115)
                }
            }
            .frame(width: 362, height: 587)
            .padding(.bottom, 36)

            HStack {
                Button {
                    if let booking = bookings.first(where: { selectedTimeSlots.contains($0.timeSlot) }) {
                        selectedBooking = booking
                    }
                    showUpdateView.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(bookings.contains { selectedTimeSlots.contains($0.timeSlot) } ? Color.accentColor : .gray)
                            .frame(width: 169, height: 35)
                        Text("수정/삭제하기")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
                .disabled(!bookings.contains { selectedTimeSlots.contains($0.timeSlot) })

                Button {
                    showYeView.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(!bookings.contains { selectedTimeSlots.contains($0.timeSlot) } ? Color.accentColor : .gray)
                            .frame(width: 169, height: 35)
                        Text("예약하기")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
                .disabled(bookings.contains { selectedTimeSlots.contains($0.timeSlot) })
            }
        }
        .padding(0)
        .onAppear {
            loadBookings()
        }
        .sheet(isPresented: $showYeView) {
            BookingView(showYeView: $showYeView, selectedTimeSlots: $selectedTimeSlots)
                .onDisappear {
                    loadBookings()
                }
        }
        .sheet(isPresented: $showUpdateView) {
            if let booking = selectedBooking {
                UpdateView(showUpdateView: $showUpdateView, booking: booking)
                    .onDisappear {
                        loadBookings()
                    }
            }
        }
    }

    @ViewBuilder
    private func TableViewForReservation(index: Int) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            Rectangle()
                .fill(.gray)
                .frame(width: 309, height: 1)
            Button {
                toggleSelection(index: index)
            } label: {
                ZStack {
                    let color: Color = {
                        if selectedTimeSlots.contains(index) {
                            return .blue
                        } else if let booking = bookings.first(where: { $0.timeSlot == index }) {
                            return booking.colorOfRow.tableBackgroundColor
                        } else {
                            return PCColorList.default.tableBackgroundColor
                        }
                    }()

                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 255, height: 36)
                        .foregroundColor(color)

                    if let booking = bookings.first(where: { $0.timeSlot == index }) {
                        Text("\(booking.name)/\(booking.perposeOfReservation ?? "")")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }


    private func toggleSelection(index: Int) {
        if selectedTimeSlots.contains(index) {
            selectedTimeSlots.removeAll(where: { $0 == index })
        } else if selectedTimeSlots.count < 3 {
            selectedTimeSlots.append(index)
            if let selectedBooking = bookings.first(where: { $0.timeSlot == index }) {
                let identicalTimeSlots = bookings.filter { $0.id == selectedBooking.id }.map { $0.timeSlot }
                selectedTimeSlots.append(contentsOf: identicalTimeSlots.filter { $0 != index })
            }
        }
    }

    private func loadBookings() {
        self.bookings = DataManager.shared.getAllBookings()
    }
}



#Preview {
    ContentView()
}
