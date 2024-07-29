
//
//  BookingView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/18/24.
//

import Foundation
import SwiftUI
import SwiftData

class DataManager {
    static let shared = DataManager()

    private var bookings: [PCBooking] = []

    func addBooking(_ booking: PCBooking) {
        bookings.append(booking)
    }

    func getAllBookings() -> [PCBooking] {
        return bookings
    }

    func updateBooking(_ updatedBooking: PCBooking) {
        for index in 0..<bookings.count {
            if bookings[index].id == updatedBooking.id {
                bookings[index] = updatedBooking
            }
        }
    }

    func deleteBooking(_ booking: PCBooking) {
        bookings.removeAll { $0.id == booking.id }
    }
}

//예약하는 페이지
struct BookingView: View {
    @Binding var showYeView: Bool
    @Binding var selectedTimeSlots: [Int]
    @State private var name: String = ""
    @State private var perposeOfReservation: String = ""
    @State private var numberOfPeople: String = ""
    @State private var password: String = ""
    @State private var colorOfRow: PCColorList = .default

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.pikachoGray100
                    .ignoresSafeArea()

                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.pikachoGray300)
                        .frame(width: 40, height: 5)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)

                    Text("예약하기")
                        .font(.PikachoHeadiline)

                    Spacer().frame(height: 20)

                    CustomTextField(label: "닉네임", placeholder: "본인 닉네임을 영어로 입력해주세요.", text: $name)
                        .keyboardType(.asciiCapable)

                    Spacer().frame(height: 20)

                    CustomTextField(label: "사용 용도", placeholder: "예약 용도를 입력해주세요.", text: $perposeOfReservation)

                    Spacer().frame(height: 20)

                    CustomTextField(label: "예약 인원", placeholder: "예약 인원을 입력해주세요.", text: $numberOfPeople)
                        .keyboardType(.numberPad)

                    Spacer().frame(height: 20)

                    CustomTextField(label: "비밀번호", placeholder: "예약 수정 시 사용할 비밀번호(4자리)를 입력해주세요.", text: $password)
                        .keyboardType(.numberPad)

                    Spacer()

                    Button(action: {
                        saveBooking()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.accentColor)
                                .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 8)
                            Text("완료하기")
                                .font(.PikachoButton)
                                .foregroundColor(.white)
                        }
                    })
                }
                .padding(.horizontal, 16)
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
    }

    private func saveBooking() {
        let intPassword = Int(password) ?? 0
        let intNumberOfPeople = Int(numberOfPeople) ?? 0
        let selectedColor = PCColorList.allCases.randomElement() ?? .timeTable1

        for index in selectedTimeSlots {
            let uuid = UUID()
            let newBooking = PCBooking(
                id: uuid,
                name: name,
                perposeOfReservation: perposeOfReservation,
                numberOfPeople: intNumberOfPeople,
                password: intPassword,
                timeSlot: index,
                colorOfRow: selectedColor 
            )
            DataManager.shared.addBooking(newBooking)
        }

        selectedTimeSlots.removeAll() // 선택된 시간대 초기화
        showYeView.toggle()
    }


}

struct CustomTextField: View {
    var label: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.PikachoBody)

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 8)

                TextField(placeholder, text: $text)
                    .font(.PikachoBody)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 20)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
