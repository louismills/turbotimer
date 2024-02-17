//
//  SessionTimerSection.swift
//  astrotimer
//
//  Created by Louis Mills on 02/02/2024.
//

import Foundation
import SwiftUI

struct sessionTimerSection: View {
  @Environment(\.dismiss) var dismiss

  @Binding var appState: AppState

  @State var timer: Timer? = nil
  @State private var showingSettings = false
  @State private var showingWarning = false

  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("sessionRunning") var sessionRunning = false
  @AppStorage("userStars") var userStars = 0
  @AppStorage("showingSessionTimerWarning") var showingSessionTimerWarning = false

  @AppStorage("userBackground") var userBackground: Color = .red


  var body: some View {
    // WIP
    let screen = UIScreen.main.bounds
    let screenWidth = screen.size.width
    // WIP
    GeometryReader { geo in
      VStack {
        HStack {
          // TOP LEFT - SESSION TIME
          VStack (alignment: .leading) {
            Text(appState.mode.rawValue)
              .foregroundStyle(.gray)
            Text(appState.currentTimeDisplay)
              .font(.system(size: 45))
              .fontWeight(.heavy)
          }
          Spacer()
          VStack (alignment: .trailing) {
            // TOP RIGHT - STARS COUNT
            Text("Trophies")
              .foregroundStyle(.gray)
            Text("\(Int(appState.sessionStars))").foregroundColor(.yellow)
              .font(.system(size: 45))
              .fontWeight(.heavy)
          }
        }
        Spacer()
        HStack(alignment: .bottom) {
          // BOTTOM LEFT - Settings, Progress bar
          if !sessionRunning {
            Button {
              showingSettings.toggle()
            } label: {
              Image(systemName: "gear")
                .foregroundColor(.white)
                .font(.title)
            }
            .settingBtnTextFormat()
            .fullScreenCover(isPresented: $showingSettings) {
              SheetChallengesView(appState: $appState)
            }
          }
          VStack (alignment: .leading) {
            if sessionRunning {
              Text("Progress")
                .foregroundStyle(.gray)
              ProgressView(value: appState.currentTimeCountdown, total: Double(appState.workMinutes * 60))
              //              ProgressView(value: appState.currentTimeCountdown, total: Double(userSessionTime * 60))
                .progressViewStyle(MyProgressViewStyle(myColor: Color.green))
            }
          }

          Spacer()

          // BOTTOM RIGHT - Start / Stop button
          Button {
            if timer == nil {
              timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
                appState.next()
              }
              sessionRunning = true
            }
            else {
              timer?.invalidate()
              timer = nil
              showingWarning.toggle()
              sessionRunning = false
              showingSessionTimerWarning = true
            }
          } label: {
            if !sessionRunning {
              Spacer()
              Text("START")
              Spacer()
            } else {
//              Spacer()
              Text("STOP")
//              Spacer()
            }
          }
          .appBtn(color: !sessionRunning ? .green : Color(UIColor.lightGray).opacity(0.4))
            .fontWeight(.heavy)
        }
      }
      .padding(.top, 10)
    }
    .padding()
    .frame(maxHeight: 220)

    .frame(width: screenWidth - 106)
    .background(Color("BackgroundPanel"))
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color(userBackground), lineWidth: 2)
    )
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
