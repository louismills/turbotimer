//
//  SessionTimerDialog.swift
//  astrotimer
//
//  Created by Louis Mills on 05/02/2024.
//

import Foundation
import SwiftUI

struct SessionTimerDialog: View {
  @Binding var isActive: Bool

  @Binding var appState: AppState

  @State var timer: Timer? = nil

  @AppStorage("userStars") var userStars = 0

  @AppStorage("sessionRunning") var sessionRunning = false



  let action: () -> ()
  @State private var offset: CGFloat = 1000

  var body: some View {
    ZStack {
      Color(.black)
        .opacity(0.3)
        .onTapGesture {
          close()
        }

      VStack {
        Image(systemName: "brain").foregroundColor(.pink).font(.system(size: 80))
        Text("Stay Focused")
          .textCase(.uppercase)
          .font(.title2)
          .bold()
          .padding()
        let timeElapsed = (appState.workMinutes * 60) - Int(appState.currentTimeCountdown)
        if timeElapsed == 1 {
              Text("Session stopped! You focused just for \((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) second. You've got this!")
          .multilineTextAlignment(.center).padding(.bottom, 20)
       } else if (appState.workMinutes * 60) - Int(appState.currentTimeCountdown) < 60 {
          Text("Session stopped! You focused just for \((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) seconds. You've got this!")
            .multilineTextAlignment(.center).padding(.bottom, 20)
        } else if (appState.workMinutes * 60) - Int(appState.currentTimeCountdown) == 60 {
          Text("Session stopped! You focused just for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minute. You've got this!")
            .multilineTextAlignment(.center).padding(.bottom, 20)
        } else {
          let remainingMins = (appState.workMinutes - (((appState.workMinutes) / 60) * 60))
          Text("Session stopped! You focused just for \(((appState.workMinutes * 60) - Int(appState.currentTimeCountdown)) / 60) minutes and \(remainingMins) seconds. You've got this!")
            .multilineTextAlignment(.center).padding(.bottom, 20)
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
              .foregroundColor(.red)

            Text("End Session")
              .textCase(.uppercase)
              .fontWeight(.bold)
              .foregroundColor(.white)
              .padding(10)
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

            Text("Continue (10 stars)")
              .textCase(.uppercase)
              .fontWeight(.bold)
              .foregroundColor(.white)
              .padding(10)
          }
        }
      }
      .padding(.top, 20)
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .background(Color("Background"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .overlay(alignment: .topTrailing) {
        Button {
          close()
        } label: {
          Image(systemName: "xmark")
            .font(.title2)
            .fontWeight(.medium)
        }
        .tint(.black)
        .padding()
      }
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
//
//  static var previews: some View {
//    SessionTimerDialog(isActive: .constant(true), appState: $appState, action: {})
//  }
//}
