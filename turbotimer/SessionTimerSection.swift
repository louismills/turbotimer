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

  @AppStorage("userTheme") var userTheme = "gray"

  @AppStorage("challengeSelectedRewardTyres") var challengeSelectedRewardTyres = 0
  @AppStorage("challengeSelectedRewardTyresType") var challengeSelectedRewardTyresType = ""

  @AppStorage("userTyres") var userTyres = DefaultSettings.tyresDefault

  func updateInventory(type: String) {
    if let index = userTyres.firstIndex(where: { $0.type == type }) {
      userTyres[index].inventory += 1
    }
  }

  let scene: GameScene

  var body: some View {
    let screen = UIScreen.main.bounds
    let screenWidth = screen.size.width
    GeometryReader { geo in
      VStack {
        // TOP LEFT - SESSION TIME
        VStack (alignment: .leading) {
          Text(appState.mode.rawValue)
            .foregroundStyle(.gray)
            .fontWeight(.bold)
          Text(appState.currentTimeDisplay)
            .font(.system(size: 300))
            .minimumScaleFactor(0.01)
            .fontWeight(.heavy)
            .monospacedDigit()

        }
        Spacer()
        HStack(alignment: .bottom) {
          // BOTTOM LEFT - Settings, Progress bar
          if !sessionRunning {
            Button {
              showingSettings.toggle()
            } label: {
              Image(systemName: "gear")
                .foregroundColor(Color("Background"))
                .font(.title)
            }
            .btnFormat()
            .fullScreenCover(isPresented: $showingSettings) {
              ChallengesView(appState: $appState)
            }
          }
          VStack (alignment: .leading) {
            if sessionRunning {
              Text("Progress")
                .foregroundStyle(.gray)
                .fontWeight(.bold)
              if appState.mode == .session {
                ProgressView(value: appState.currentTimeCountdown, total: Double(appState.workMinutes * 60))
                  .progressViewStyle(MyProgressViewStyle())
              } else {
                ProgressView(value: appState.currentTimeCountdown, total: Double(appState.restMinutes * 60))
                  .progressViewStyle(MyProgressViewStyle())
              }
            }
          }
          Spacer()
          // BOTTOM RIGHT - Start / Stop button
          Button {
            if timer == nil {
              timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
                appState.next()
                // Create correct tyre colour
                if appState.currentTime == 0 && appState.mode == .session {
                  // Create quantity
                  for _ in 0..<challengeSelectedRewardTyres {
                    scene.createTyre(tyreType: challengeSelectedRewardTyresType)
                    // add to user tyre inventory
                    updateInventory(type: challengeSelectedRewardTyresType)
                  }
                }
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
              Text("STOP")
            }
          }
//          .appBtn(color: !sessionRunning ? Color("Text") : Color(UIColor.lightGray).opacity(0.4))
          .appBtn(color: !sessionRunning ? Color("Text") : Color(.gray))
          .fontWeight(.heavy)
        }
      }
      //      .padding(.top, 10)
      .padding(.top, 5)
//            .padding(.top, sessionRunning ? 0 : 10)
    }
    .padding()
//    .frame(maxHeight: 220)
    .frame(maxHeight: 235)
    .frame(width: screenWidth - 106)
    .background(Color("BackgroundPanel"))
    .overlay(
      RoundedRectangle(cornerRadius: 20)
        .stroke(Color(userTheme), lineWidth: 2)
    )
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
