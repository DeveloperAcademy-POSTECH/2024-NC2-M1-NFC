//
//  NFCTagScanView.swift
//  Pikacho
//
//  Created by Hajin on 6/18/24.
//

import SwiftUI
import CoreNFC

struct NFCTagScanView: View {
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var session: NFCNDEFReaderSession?
    @State private var haveToNavigate = false
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Meet-ing").font(.PikachoHeadiline)
                    Spacer()
                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
                HStack{
                    Text("미팅룸 예약을 위해").font(.PikachoButton)
                    Spacer()
                }
                HStack{
                    Text("NFC 태그에 아이폰을 가까이 가져가세요.").font(.PikachoButton)
                    Spacer()
                }
            }.frame(width: 361, height: 97)
                .padding(0)

            Spacer()

            Image(systemName: "airtag.radiowaves.forward")
                .resizable()
                .frame(width: 297, height: 189)
                .foregroundColor(Color(hex: 0x523BDB))

            Spacer()

            Button{
                beginScanning()
            }label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x523BDB)).frame(width: 361, height: 51)
                    Text("스캔하기").foregroundColor(.white).font(.PikachoButton)
                }
            }

            NavigationLink(destination: ContentView(), isActive: $haveToNavigate) {
                EmptyView()
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }

    }
    private func beginScanning() {
        print("Checking")
        guard NFCNDEFReaderSession.readingAvailable else {
            alertMessage = "This device doesn't support tag scanning."
            showingAlert = true
            print("NFC scanning not available on this device.")
            return
        }

        print("NFC scanning started")

        session = NFCNDEFReaderSession(delegate: NFCDelegate(showingAlert: $showingAlert, alertMessage: $alertMessage, haveToNavigate: $haveToNavigate), queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iphone near the item to learn more about it."
        session?.begin()
    }
}

class NFCDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    @Binding var haveToNavigate: Bool
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String

    init(showingAlert: Binding<Bool>, alertMessage: Binding<String>, haveToNavigate: Binding<Bool>) {
        _showingAlert = showingAlert
        _alertMessage = alertMessage
        _haveToNavigate = haveToNavigate
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("NFC tag detected.")
        DispatchQueue.main.async {
            self.haveToNavigate = true
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            print("NFC session invalidated with error")
            if readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead && readerError.code != .readerSessionInvalidationErrorUserCanceled {
                DispatchQueue.main.async {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
            }
        }
    }
}


#Preview {
    NFCTagScanView()
}
