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
                print(haveToNavigate)
//                beginScanning()
                NewNFCDelete.shared.completeNavigate = {
                    haveToNavigate = true
                    print(haveToNavigate)
                }
                startNFCTagging()
            }label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x523BDB)).frame(width: 361, height: 51)
                    Text("스캔하기").foregroundColor(.white).font(.PikachoButton)
                }
            }

        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            
        }
        .sheet(isPresented: $haveToNavigate){ ContentView()
        }

    }
        
    private func beginScanning() {
        
        guard NFCNDEFReaderSession.readingAvailable else {
            alertMessage = "This device doesn't support tag scanning."
            showingAlert = true
            return
        }

        print("NFC scanning started")
        
       

        session = NFCNDEFReaderSession(delegate: NFCDelegate(showingAlert: $showingAlert, alertMessage: $alertMessage, haveToNavigate: $haveToNavigate), queue: nil, invalidateAfterFirstRead: true)
    }
}

private func startNFCTagging() {
    let session = NFCTagReaderSession(pollingOption: .iso14443, delegate: NewNFCDelete.shared)
    session?.begin()
}

class NewNFCDelete: NSObject, NFCTagReaderSessionDelegate {
    static let shared = NewNFCDelete()
    
    var completeNavigate: (() -> Void)?
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("become active")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: any Error) {
        if let readerError = error as? NFCReaderError, readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead {
            print("NFC Reader session 오루 \(error.localizedDescription)")
        }
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        print(tags)
        if let completeNavigate {
            completeNavigate()
        }
        session.invalidate()
    }
    
    
}

class NFCDelegate: NSObject, NFCNDEFReaderSessionDelegate {
    @Binding var haveToNavigate: Bool
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String

    init(showingAlert: Binding<Bool>, alertMessage: Binding<String>, haveToNavigate: Binding<Bool>) {
        self._showingAlert = showingAlert
        self._alertMessage = alertMessage
        self._haveToNavigate = haveToNavigate
        super.init()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        
        DispatchQueue.main.async {
            self.haveToNavigate = true
        }
    }
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("be active")
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {

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
