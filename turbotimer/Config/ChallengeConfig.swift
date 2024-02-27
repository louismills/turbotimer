//
//  ChallengeConfig.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SwiftUI

struct ChallengeConfig: View {
  @Environment(\.dismiss) var dismiss

  @Binding var appState: AppState

  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userTheme") var userTheme: Color = .gray
  @AppStorage("challengeSelected") var challengeSelected = false
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedRewardStars") var challengeSelectedRewardStars = 0
  @AppStorage("challengeSelectedRewardTyres") var challengeSelectedRewardTyres = 0
  @AppStorage("challengeSelectedRewardTyresType") var challengeSelectedRewardTyresType = ""

  let workMinutes: Int
  let rewardTyresType: String
  let rewardTyres: Int
  let rewardStars: Int

  var body: some View {
    Button(action: {
      challengeSelected = true
      challengeSelectedDuration = workMinutes
      challengeSelectedRewardTyres = rewardTyres
      challengeSelectedRewardStars = rewardStars
      challengeSelectedRewardTyresType = rewardTyresType
    }) {
      HStack {
        Spacer()
        VStack {
          Spacer()
          if workMinutes < 60 {
            Text("\(workMinutes)").font(.system(size: 50))
            Text("MINUTES").font(.system(size: 22))
          } else {
            let remainingMins = (workMinutes - (((workMinutes) / 60) * 60))
            if remainingMins > 0 {
              Text("\(workMinutes / 60):\(remainingMins)").font(.system(size: 50))
              Text("HOURS").font(.system(size: 22))
            } else {
              if (workMinutes / 60) > 1 {
                Text("\(workMinutes / 60)").font(.system(size: 50))
                Text("HOURS").font(.system(size: 22))
              } else {
                Text("\(workMinutes / 60)").font(.system(size: 50))
                Text("HOUR").font(.system(size: 22))
              }
            }
          }
          Spacer()
        }
        Spacer()
      }
      .fontWeight(.heavy)
      .foregroundColor(Color("Text"))
      .background(Color("BackgroundPanel"))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color(userTheme), lineWidth: 2)
      )
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    .buttonStyle(PlainButtonStyle())
  }
}
