//
//  SessionTimerDialog.swift
//  turbotimer
//
//  Created by Louis Mills on 05/02/2024.
//

import Foundation
import SwiftUI

struct SessionTimerDialog: View {
  @Binding var isActive: Bool
  @Binding var appState: AppState

  @State var timer: Timer? = nil
  @State private var offset: CGFloat = 1000

  @AppStorage("userStars") var userStars = 0
  @AppStorage("sessionRunning") var sessionRunning = false

  let action: () -> ()

  var body: some View {
    ZStack {
      Color(.black)
        .opacity(0.3)
      VStack {
        Image("crashhelmet").resizable()
          .frame(width: 100, height: 100)
        Text("Stay Focused")
          .textCase(.uppercase)
          .font(.title2)
          .bold()
          .padding(.bottom, 20)
          .padding(.top, 10)

        let timeElapsed = (appState.workMinutes * 60) - Int(appState.currentTimeCountdown)
        if timeElapsed == 1 {
          Text("Session stopped! You focused for \(timeElapsed) second. You've got this!")
            .multilineTextAlignment(.center).padding(.bottom, 20)
        } else if timeElapsed < 60 {
          Text("Session stopped! You focused for \(timeElapsed) seconds. You've got this!")
            .multilineTextAlignment(.center).padding(.bottom, 20)
        } else if timeElapsed == 60 {
          Text("Session stopped! You focused for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minute. You've got this!")
            .multilineTextAlignment(.center).padding(.bottom, 20)
        } else {
          // More than 1 minute has passed
          let remainingSecs = (appState.workMinutes - (((appState.workMinutes) / 60) * 60))
          // less than 2 mins
          if timeElapsed < 120 {
            if remainingSecs == 1 {
              Text("Session stopped! You focused for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minute and \(remainingSecs) second. You've got this!")
                .multilineTextAlignment(.center).padding(.bottom, 20)
            } else {
              Text("Session stopped! You focused for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minute and \(remainingSecs) seconds. You've got this!")
                .multilineTextAlignment(.center).padding(.bottom, 20)
            }
          } else {
            if remainingSecs == 1 {
              Text("Session stopped! You focused for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minutes and \(remainingSecs) second. You've got this!")
                .multilineTextAlignment(.center).padding(.bottom, 20)
            } else {
              Text("Session stopped! You focused for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minutes and \(remainingSecs) seconds. You've got this!")
                .multilineTextAlignment(.center).padding(.bottom, 20)
            }
          }
        }

        Button {
          if userStars >= 10 {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
              appState.next()
              sessionRunning = true
            }
            userStars -= 10
          }
          else {
            timer?.invalidate()
            timer = nil
            appState.reset()
            sessionRunning = false
          }
          close()
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.green)
            Text("Continue (10 Trophies)")
              .textCase(.uppercase)
              .fontWeight(.bold)
              .foregroundColor(.white)
              .padding(10)
          }
        }
        Button {
          timer?.invalidate()
          timer = nil
          appState.reset()
          sessionRunning = false
          close()
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.gray)

            Text("End Session")
              .textCase(.uppercase)
              .fontWeight(.bold)
              .foregroundColor(.white)
              .padding(10)
          }
        }
      }
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

//struct SessionTimerDialog_Previews: PreviewProvider {
//  static var previews: some View {
//    SessionTimerDialog(isActive: .constant(true), appState: $appState, action: {})
//  }
//}
