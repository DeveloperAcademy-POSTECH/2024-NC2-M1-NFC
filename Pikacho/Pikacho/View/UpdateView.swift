

import SwiftUI

struct UpdateView: View {
    @Binding var showUpdateView: Bool
    //@State private var showDetailView = false
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
                    DetailView(booking: booking, showUpdateView: $showUpdateView)
                    
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
            //showUpdateView = false
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


