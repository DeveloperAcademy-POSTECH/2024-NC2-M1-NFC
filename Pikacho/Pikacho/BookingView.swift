//
//  BookingView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/18/24.
//

import SwiftUI

struct BookingView: View {
    
    @Binding var showBookingView: Bool
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack(alignment: .leading){
            Text("예약하기")
                .font(.PikachoHeadiline)
            
            Spacer().frame(height: 20)
            
            Text("닉네임")
                .font(.PikachoBody2)
            
            //TextField("본인 닉네임을 영어로 입력해주세요." ,text: $pc.nickname)
                .keyboardType(.default)
                .font(.PikachoBody)
                .padding(.leading, 12)
                .focused($focusField, equals: .nickname)
             
            Spacer().frame(height: 20)
            
            Text("사용 용도")
                .font(.PikachoBody2)
            
            //TextField("예약 용도를 입력해주세요." ,text: $pc.purpose)
                .keyboardType(.default)
                .font(.PikachoBody)
                .padding(.leading, 12)
                .focused($focusField, equals: .purpose)
            
            Text("예약 인원")
                .font(.PikachoBody2)
            
            //TextField("예약 인원을 입력해주세요." ,text: $pc.people)
                .keyboardType(.default)
                .font(.PikachoBody)
                .padding(.leading, 12)
                .focused($focusField, equals: .people)
            
            Text("비밀번호")
                .font(.PikachoBody2)
            
            //TextField("예약 수정 시 사용할 비밀번호(4자리)를 입력해주세요." ,text: $pc.password)
                .keyboardType(.default)
                .font(.PikachoBody)
                .padding(.leading, 12)
                .focused($focusField, equals: .password)
             
                
            
            
            Spacer()
            
            
        }
    }
}

#Preview {
    BookingView(showBookingView: .constant(true))
}


enum Field{
    case nickname
    case purpose
    case people
    case password
}
