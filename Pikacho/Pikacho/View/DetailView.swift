

import SwiftUI


struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss

    @Binding var showUpdateView: Bool

    @State private var newName: String
    @State private var newPerposeOfReservation: String
    @State private var newNumberOfPeople: String
    @State private var newPassword: String
    @State private var showAlert = false
    @State private var alertMessage = ""

    var originalBooking: PCBooking
    @State private var updatedBooking: PCBooking

    init(booking: PCBooking, showUpdateView: Binding<Bool>) {
        self._showUpdateView = showUpdateView
        self.originalBooking = booking
        self._newName = State(initialValue: booking.name)
        self._newPerposeOfReservation = State(initialValue: booking.perposeOfReservation ?? "")
        self._newNumberOfPeople = State(initialValue: "\(booking.numberOfPeople ?? 0)")
        self._newPassword = State(initialValue: "\(booking.password)")
        self._updatedBooking = State(initialValue: booking)
    }

    var body: some View {
        ZStack {
            Color.pikachoGray100
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.pikachoGray300)
                    .frame(width: 40, height: 5)
                    .padding(.bottom, 16)
                    .frame(maxWidth: .infinity)

                Text("수정 / 삭제하기")
                    .font(.PikachoHeadiline)

                Spacer().frame(height: 20)

                CustomTextField(label: "닉네임", placeholder: "본인 닉네임을 영어로 입력해주세요.", text: $newName)
                    .keyboardType(.asciiCapable)

                Spacer().frame(height: 20)

                CustomTextField(label: "사용 용도", placeholder: "예약 용도를 입력해주세요.", text: $newPerposeOfReservation)

                Spacer().frame(height: 20)

                CustomTextField(label: "예약 인원", placeholder: "예약 인원을 입력해주세요.", text: $newNumberOfPeople)
                    .keyboardType(.numberPad)

                Spacer().frame(height: 20)

                CustomTextField(label: "비밀번호", placeholder: "예약 수정 시 사용할 비밀번호(4자리)를 입력해주세요.", text: $newPassword)
                    .keyboardType(.numberPad)

                Spacer()

                HStack {
                    Button(action: {
                        confirmDelete()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.pikachoDelete)
                                .frame(width: 170, height: 35)
                            Text("삭제하기")
                                .font(.PikachoButton)
                                .foregroundColor(.white)
                        }
                    })

                    Button(action: {
                        verifyPassword()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.accentColor)
                                .frame(width: 170, height: 35)
                            Text("저장하기")
                                .font(.PikachoButton)
                                .foregroundColor(.white)
                        }
                    })
                }
            }
            .padding(.horizontal, 16)
            .navigationBarTitle(Text("예약 상세 정보 수정"), displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage.contains("오류") ? "오류" : "삭제 확인"),
                    message: Text(alertMessage),
                    primaryButton: .destructive(Text("삭제")) {
                        deleteBooking()
                    },
                    secondaryButton: .cancel()
                )
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func confirmDelete() {
        alertMessage = "예약을 삭제하시겠습니까?"
        showAlert = true
    }

    private func verifyPassword() {
        if let intPassword = Int(newPassword), intPassword == originalBooking.password {
            updateBooking()
        } else {
            alertMessage = "비밀번호가 틀렸습니다. 다시 시도해주세요."
            showAlert = true
        }
    }

    private func updateBooking() {
        guard let numberOfPeople = Int(newNumberOfPeople) else {
            showAlert = true
            alertMessage = "올바른 숫자를 입력해주세요."
            return
        }

        updatedBooking.name = newName
        updatedBooking.perposeOfReservation = newPerposeOfReservation
        updatedBooking.numberOfPeople = numberOfPeople
        updatedBooking.password = Int(newPassword) ?? 0

        let identicalBookings = DataManager.shared.getAllBookings().filter { $0.id == originalBooking.id }
        for booking in identicalBookings {
            var updated = booking
            updated.name = newName
            updated.perposeOfReservation = newPerposeOfReservation
            updated.numberOfPeople = numberOfPeople
            updated.password = Int(newPassword) ?? 0
            DataManager.shared.updateBooking(updated)
        }

        showUpdateView = false
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteBooking() {
        DataManager.shared.deleteBooking(originalBooking)
        showUpdateView = false
        presentationMode.wrappedValue.dismiss()
    }
}

