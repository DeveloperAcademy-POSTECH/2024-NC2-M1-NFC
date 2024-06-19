
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
        
//    func removeBooking(_ booking: PCBooking) {
//            bookings.removeAll { $0.id == booking.id }
//        }
        
    func removeBooking(by id: UUID) {
                // id를 기준으로 배열에서 예약을 제거합니다.
                bookings.removeAll { $0.id == id }
            }
    func updateBooking(_ updatedBooking: PCBooking) {
            for index in 0..<bookings.count {
                if bookings[index].id == updatedBooking.id {
                    // 예약을 찾아서 업데이트합니다.
                    bookings[index] = updatedBooking
                    break
                }
            }
        }
}

struct BookingView: View {
    
    @Binding var showYeView: Bool
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
                    // Indicator Bar
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.pikachoGray300)
                        .frame(width: 40, height: 5)
                        //.padding(.top, 8)
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)
                    
                    Text("예약하기")
                        .font(.PikachoHeadiline)
                    
                    Spacer().frame(height: 20)
                    
                    // CustomTextField로 텍스트 필드를 생성
                    CustomTextField(label: "닉네임", placeholder: "본인 닉네임을 영어로 입력해주세요.", text: $name)
                    
                    Spacer().frame(height: 20)
                    
                    CustomTextField(label: "사용 용도", placeholder: "예약 용도를 입력해주세요.", text: $perposeOfReservation)
                    
                    Spacer().frame(height: 20)
                    
                    CustomTextField(label: "예약 인원", placeholder: "예약 인원을 입력해주세요.", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                    
                    Spacer().frame(height: 20)
                    
                    CustomTextField(label: "비밀번호", placeholder: "예약 수정 시 사용할 비밀번호(4자리)를 입력해주세요.", text: $password)
                        .keyboardType(.numberPad)
                    
//                    Picker("Color of Row", selection: $colorOfRow) {
//                        ForEach(PCColorList.allCases, id: \.self) { color in
//                            Text(color.tabkeBackgroundColor.description).tag(color)
//                        }
//                    }
//                    .pickerStyle(MenuPickerStyle())
//                    .padding()
                    
                    Spacer()
                    
                    
                        Button(action: {
                            saveBooking()
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.accentColor)
                                    //.frame(width: 361, height: 35)
                                    .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 8)
                                Text("완료하기")
                                    .font(.PikachoButton)
                                    .foregroundColor(.white)
                                
                            }
                        })
                        //.padding()
                    
                    
                    
                }.padding(.horizontal, 16)
                .onTapGesture { // <-
                        hideKeyboard()
                    }
                
            }//.padding(.horizontal, 16)
        }
    }
    
    private func saveBooking() {
        let uuid = UUID()
        let intPassword = Int(password) ?? 0
        let intNumberOfPeople = Int(numberOfPeople) ?? 0
        let newBooking = PCBooking(id: uuid, name: name, perposeOfReservation: perposeOfReservation, numberOfPeople: intNumberOfPeople, password: intPassword, colorOfRow: colorOfRow)
        DataManager.shared.addBooking(newBooking)
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
            
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 8)
                
                TextField(placeholder, text: $text)
                    .font(.PikachoBody)
                    .foregroundColor(.pikachoGray300)
                    //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
            }
        }.padding(.bottom, 20)
    }
}

extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
