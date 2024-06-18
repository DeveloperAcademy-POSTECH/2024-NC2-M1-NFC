//
//  ContentView.swift
//  Pikacho
//
//  Created by SOOKYUNG CHO on 6/17/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {

            Text("MeetingRoom#1").font(.system(size: 30, weight: .bold))
                .padding(EdgeInsets(top: 20, leading: 0, bottom: 10, trailing: 0))
            Text("Time Table")
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 4)
            Text("Sat, 15 June, 2024")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .padding(.bottom, 16)

            HStack{
                VStack{
                    Text("9 AM").font(.system(size: 12))
                    Spacer()
                    Text("10 AM").font(.system(size: 12))
                    Spacer()
                    Text("11 AM").font(.system(size: 12))
                    Spacer()
                    Text("12 PM").font(.system(size: 12))
                    Spacer()
                    Text("1 PM").font(.system(size: 12))
                    Spacer()
                    Text("2 PM").font(.system(size: 12))
                    Spacer()
                    Text("3 PM").font(.system(size: 12))
                    Spacer()
                    Text("4 PM").font(.system(size: 12))
                    Spacer()
                    Text("5 PM").font(.system(size: 12))
                    Spacer()
                    Text("6 PM").font(.system(size: 12))
                    Spacer()
                    Text("7 PM").font(.system(size: 12))
                    Spacer()
                    Text("8 PM").font(.system(size: 12))
                    Spacer()
                    Text("9 PM").font(.system(size: 12))
                    Spacer()
                    Text("10 PM").font(.system(size: 12))
                }
                ZStack{
                    VStack(spacing:4){
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        TableViewForReservation()
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 309, height: 1)
                    }
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 1, height: 584)
                        .offset(x:-115)
                }
            }.frame(width:362,height: 587).padding(.bottom, 36)

            HStack{
                Button{}label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(width:169, height: 35)
                        Text("수정/삭제하기")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
                Button{}label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray)
                            .frame(width:169, height: 35)
                        Text("예약하기")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding(0)
    }

    @ViewBuilder
    private func TableViewForReservation() -> some View {
        VStack(alignment:.trailing, spacing: 4){
            Rectangle()
                .fill(Color.gray)
                .frame(width: 309, height: 1)
            Button{}label:{
                RoundedRectangle(cornerRadius: 5).frame(width:255, height: 36).foregroundColor(.gray)
            }.padding(.horizontal, 8)

        }
    }
}

#Preview {
    ContentView()
}
