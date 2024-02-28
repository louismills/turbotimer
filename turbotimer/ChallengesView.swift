//
//  ChallengesView.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SwiftUI

struct ChallengesView: View {
  @Binding var appState: AppState

  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("sessionRunning") var sessionRunning = false
  @AppStorage("challengeSelected") var challengeSelected = false
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedRewardStars") var challengeSelectedRewardStars = 0
  @AppStorage("challengeSelectedRewardTyres") var challengeSelectedRewardTyres = 0
  @AppStorage("challengeSelectedRewardTyresType") var challengeSelectedRewardTyresType = ""
  @AppStorage("userSessionTime") var userSessionTime = 0

  @AppStorage("challenges") var challenges = DefaultSettings.challengesDefault

  @Environment(\.dismiss) var dismiss

  var body: some View {

    GeometryReader { geo in
      ZStack {
        HStack(spacing: 0) {
          Text("")
            .frame(width: geo.size.width / 4, alignment: .leading)
          Text("CHALLENGES")
            .foregroundColor(Color("Text"))
            .font(.title3).fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
//          dismissSettingsBtn()
          dismissBtn()
            .frame(width: geo.size.width / 4, alignment: .trailing)
        }
      }
      .frame(height: 30)
      .padding()
      .background(Color("Background"))

      Divider()
        .overlay(Color(UIColor.lightGray))
        .offset(y: 60)
        .edgesIgnoringSafeArea(.horizontal)

      GeometryReader { geo in
        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
          GridRow {
            ChallengeConfig(appState: $appState, challenge: challenges[0])
            ChallengeConfig(appState: $appState, challenge: challenges[1])
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            ChallengeConfig(appState: $appState, challenge: challenges[2])
            ChallengeConfig(appState: $appState, challenge: challenges[3])
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            ChallengeConfig(appState: $appState, challenge: challenges[4])
            ChallengeConfig(appState: $appState, challenge: challenges[5])
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            ChallengeConfig(appState: $appState, challenge: challenges[6])
            ChallengeConfig(appState: $appState, challenge: challenges[7])
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            ChallengeConfig(appState: $appState, challenge: challenges[8])
            ChallengeConfig(appState: $appState, challenge: challenges[9])
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
        }
        .frame(width: geo.size.width, height: geo.size.height)
      }
      .padding([.horizontal], 30)
      .offset(y: 20)
      //    Stepper("\(appState.restMinutes) min break ", value: $appState.restMinutes, in: 1...60)
      //      .padding()
      //      .background(.white)
      //      .foregroundColor(.black)
      //      .font(.title)

      if challengeSelected {
        ChallengesDialog(isActive: $challengeSelected, duration: challengeSelectedDuration, rewardTyresType: challengeSelectedRewardTyresType, rewardTyres: challengeSelectedRewardTyres, rewardStars: challengeSelectedRewardStars) {
          appState.workMinutes = challengeSelectedDuration
          dismiss()
        }
      }
    }
  }
}
