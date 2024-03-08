//
//  CustomDialog.swift
//  turbotimer
//
//  Created by Louis Mills on 02/02/2024.
//

import Foundation
import SwiftUI

struct ChallengesDialog: View {
  @Binding var isActive: Bool

  let duration: Int
  let rewardTyresType: String
  let rewardTyres: Int
  let rewardStars: Int
  let action: () -> ()

  @State private var offset: CGFloat = 1000

  @AppStorage("userTheme") var userTheme = "themeRed"

  var body: some View {
    ZStack {
      Color(.black)
        .opacity(0.3)
      VStack {
        HStack {
          ZStack {
            Image(rewardTyresType)
              .resizable()
              .frame(width: 90, height: 90)
            Text("\(rewardTyres)")
              .padding(10)
              .background(Color("Background"))
              .foregroundColor(Color("Text"))
              .clipShape(Circle())
              .offset(x: 50, y: -40)
          }
          ZStack {
            Image(systemName: "star.fill")
              .font(.system(size: 80))
              .foregroundColor(.yellow)
            Text("\(rewardStars)")
              .padding(10)
              .background(Color("Background"))
              .foregroundColor(Color("Text"))
              .clipShape(Circle())
              .offset(x: 40, y: -40)
          }
        }
        if duration < 60 {
          Text("Focus for \(duration) minutes")
            .textCase(.uppercase)
            .font(.title2)
            .bold()
            .padding()
        } else {
          let remainingMins = (duration - (((duration) / 60) * 60))
          if remainingMins > 0 {
            Text("Focus for \(duration / 60):\(remainingMins) hours")
              .textCase(.uppercase)
              .font(.title2)
              .bold()
              .padding()
          } else {
            if (duration / 60) > 1 {
              Text("Focus for \(duration / 60) hours")
                .textCase(.uppercase)
                .font(.title2)
                .bold()
                .padding()
            } else {
              Text("Focus for \(duration / 60) hour")
                .textCase(.uppercase)
                .font(.title2)
                .bold()
                .padding()
            }
          }
        }
        Text("You will get this reward when you complete this challenge.")
          .foregroundColor(Color("Text"))
          .multilineTextAlignment(.center).padding(.bottom, 20)
        Text("Remember: don't close or switch the app!")
          .foregroundColor(Color("Text"))
          .padding(.bottom, 20)
        Button {
          action()
          close()
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(Color("Text"))
            Text("Select")
              .textCase(.uppercase)
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(Color("Background"))
              .padding(10)
          }
        }
        Button {
          close()
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.gray)
            Text("Cancel")
              .textCase(.uppercase)
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(.white)
              .padding(10)
          }
        }
      }
      .padding(.top, 20)
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .background(Color("BackgroundPanel"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .shadow(radius: 20)
      .padding(20)
      .offset(x: 0, y: offset)
      .onAppear {
        withAnimation(.spring()) {
          offset = 0
        }
      }
    }
    .ignoresSafeArea()
  }

  func close() {
    withAnimation(.spring()) {
      offset = 1000
      isActive = false
    }
  }
}

struct ChallengesDialog_Previews: PreviewProvider {
  static var previews: some View {
    ChallengesDialog(isActive: .constant(true), duration: 10, rewardTyresType: "tyreRed", rewardTyres: 0, rewardStars: 2, action: {})
  }
}
