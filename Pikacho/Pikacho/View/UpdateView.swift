

import SwiftUI

struct UpdateView: View {
    @Binding var showUpdateView: Bool
    @State var booking: PCBooking // 전달된 예약 정보
    @State private var comparePassword: String = ""
    @State private var showDetailSheet = false
    @State private var updateAllowed = false
    @State private var showAlert = false // Alert 상태 추가
    @State private var alertMessage = "" // Alert 메시지
    
    
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
                        .padding(.bottom, 16)
                        .frame(maxWidth: .infinity)
                    
                    Text("수정 / 삭제하기")
                        .font(.PikachoHeadiline)
                    
                    Spacer().frame(height: 20)
                    
                    // 비밀번호 입력 필드
                    CustomTextField(label: "비밀번호", placeholder: "예약 수정 시 사용할 비밀번호(4자리)를 입력해주세요.", text: $comparePassword)
                        .keyboardType(.numberPad)
                    
                    Spacer()
                    
                    if !updateAllowed {
                        // 비밀번호 확인 버튼
                        Button(action: {
                            verifyPassword()
                            //showDetailSheet = true
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(!comparePassword.isEmpty ? .accent: .pikachoGray200)
                                    .frame(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) / 8)
                                Text("입력 완료")
                                    .font(.PikachoButton)
                                    .foregroundColor(.white)
                            }
                        })
                        .disabled(comparePassword.isEmpty)
                    } else {
                        // 예약 정보가 있을 때 수정 및 삭제 버튼
                        Text("닉네임: \(booking.name)")
                            .font(.PikachoBody)
                            .padding(.bottom, 10)
                        Text("사용 용도: \(booking.perposeOfReservation ?? "")")
                            .font(.PikachoBody)
                            .padding(.bottom, 10)
                        Text("예약 인원: \(booking.numberOfPeople ?? 0)")
                            .font(.PikachoBody)
                            .padding(.bottom, 10)
                    }
                    
                }
                .padding(.horizontal, 16)
                .onTapGesture {
                    hideKeyboard()
                }
                .sheet(isPresented: $showDetailSheet) {
                    DetailView(booking: booking)
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                }
            }
        }
    }
    
    private func verifyPassword() {
        if let intPassword = Int(comparePassword), intPassword == booking.password {
            updateAllowed = true
            showDetailSheet = true
        } else {
            // 비밀번호가 일치하지 않을 경우 처리
            updateAllowed = false
            alertMessage = "비밀번호가 틀렸습니다. 다시 시도해주세요."
            showAlert = true
           
        }
    }
    
        private func deleteBooking() {
            DataManager.shared.removeBooking(by: booking.id)
            showUpdateView = false
        }
}


struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss


    @State private var newName: String
    @State private var newPerposeOfReservation: String
    @State private var newNumberOfPeople: String
    @State private var newPassword: String
    @State private var showAlert = false // 비밀번호 오류 메시지 표시 여부
    @State private var alertMessage = "" // 비밀번호 오류 메시지
    
    var originalBooking: PCBooking
    @State private var updatedBooking: PCBooking // 새로운 변수
    
    init(booking: PCBooking) {
        self.originalBooking = booking
        
        // 기존 예약 정보로 초기화
        _newName = State(initialValue: booking.name)
        _newPerposeOfReservation = State(initialValue: booking.perposeOfReservation ?? "")
        _newNumberOfPeople = State(initialValue: "\(booking.numberOfPeople ?? 0)")
        _newPassword = State(initialValue: "\(booking.password)")
        
        // 새로운 예약 정보 객체 초기화
        _updatedBooking = State(initialValue: booking)
    }
    
    var body: some View {
        ZStack{
            Color.pikachoGray100
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("수정 / 삭제하기")
                    .font(.PikachoHeadiline)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                
                
                    CustomTextField(label: "닉네임", placeholder: "본인 닉네임을 영어로 입력해주세요.", text: $newName)
                    
                    Spacer().frame(height: 20)
                    
                    CustomTextField(label: "사용 용도", placeholder: "예약 용도를 입력해주세요.", text: $newPerposeOfReservation)
                    
                    Spacer().frame(height: 20)
                    
                    CustomTextField(label: "예약 인원", placeholder: "예약 인원을 입력해주세요.", text:  $newNumberOfPeople)
                        .keyboardType(.numberPad)
                    
                    Spacer().frame(height: 20)
                    
                    CustomTextField(label: "비밀번호", placeholder: "예약 수정 시 사용할 비밀번호(4자리)를 입력해주세요.", text: $newPassword)
                        .keyboardType(.numberPad)
                    

               
                Spacer()
                
                HStack {
                    Button(action: {
                        // 수정 취소 버튼
                        // 수정된 값 초기화
                        newName = originalBooking.name
                        newPerposeOfReservation = originalBooking.perposeOfReservation ?? ""
                        newNumberOfPeople = "\(originalBooking.numberOfPeople ?? 0)"
                        newPassword = "\(originalBooking.password)"
                    }, label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.pikachoDelete)
                                //.frame(width: 361, height: 35)
                                .frame(width: 170, height: 35)
                            Text("삭제하기")
                                .font(.PikachoButton)
                                .foregroundColor(.white)
                            
                        }
                    })
                    
                    Button(action: {
                        // 수정 완료 버튼
                        verifyPassword()
                        dismiss()
                    }, label: {
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.accentColor)
                                //.frame(width: 361, height: 35)
                                .frame(width: 170, height: 35)
                            Text("저장하기")
                                .font(.PikachoButton)
                                .foregroundColor(.white)
                            
                        }
                    })
                }
                .padding(.horizontal)
            }
            .padding(.horizontal, 16)
            .navigationBarTitle(Text("예약 상세 정보 수정"), displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
    }
    
    private func verifyPassword() {
        if let intPassword = Int(newPassword), intPassword == originalBooking.password {
            // 비밀번호 일치 시 예약 정보 업데이트
            updateBooking()
        } else {
            // 비밀번호 불일치 시 오류 메시지 표시
            alertMessage = "비밀번호가 틀렸습니다. 다시 시도해주세요."
            showAlert = true
        }
    }

    
    private func updateBooking() {
        // newName, newPerposeOfReservation, newPassword는 이미 옵셔널이 아니기 때문에 추가적인 처리가 필요 없습니다.
        
        // newNumberOfPeople를 Int로 변환하여 사용합니다.
        guard let numberOfPeople = Int(newNumberOfPeople) else {
            // 예외 처리: 숫자로 변환할 수 없는 경우
            // 사용자에게 알림이 필요할 수 있습니다.
            // 예를 들어, showAlert와 alertMessage를 사용하여 오류를 표시할 수 있습니다.
            showAlert = true
            alertMessage = "올바른 숫자를 입력해주세요."
            return
        }
        
        // 변경된 데이터로 예약을 업데이트합니다.
        updatedBooking.name = newName
        updatedBooking.perposeOfReservation = newPerposeOfReservation
        updatedBooking.numberOfPeople = numberOfPeople
        updatedBooking.password = Int(newPassword) ?? 0
        
        // 예약을 DataManager를 통해 업데이트합니다.
        DataManager.shared.updateBooking(updatedBooking)
        
        // DetailView를 닫습니다.
        presentationMode.wrappedValue.dismiss()
    }

}
