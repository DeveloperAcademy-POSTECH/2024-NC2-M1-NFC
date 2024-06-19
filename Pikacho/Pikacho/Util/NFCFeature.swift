//
//  NFCFeature.swift
//  Pikacho
//
//  Created by Hajin on 6/18/24.
//

import Foundation
import CoreNFC

class NFCFeature: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    @Published var messages: [NFCNDEFMessage] = []
    var session: NFCNDEFReaderSession?

    func beginScanning() {
        guard NFCNDEFReaderSession.readingAvailable else {
            print("This device doesn't support NFC scanning.")
            return
        }

        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iphone near the item to learn more about it."
        session?.begin()
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        DispatchQueue.main.async {
            self.messages.append(contentsOf: messages)
        }
    }

    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead && readerError.code != .readerSessionInvalidationErrorUserCanceled {

                print("NFC Session invalidated: \(error.localizedDescription)")
            }
        }
        self.session = nil
    }
}
