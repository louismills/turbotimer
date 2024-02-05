//
//  CustomDialog.swift
//  astrotimer
//
//  Created by Louis Mills on 02/02/2024.
//

import Foundation
import SwiftUI

struct ChallengesDialog: View {
  @Binding var isActive: Bool

  let duration: Int
  let reward: Int
  let buttonTitle: String
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


        Text("You will get this reward when you complete this challenge.").multilineTextAlignment(.center).padding(.bottom, 20)
        Text("Remember: don't close or switch the app!")
          .padding(.bottom, 20)


        Button {
          action()
          close()
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.green)

            Text(buttonTitle)
              .textCase(.uppercase)
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(.white)
              .padding(10)
          }
//          .padding()

        }

      }
      .padding(.top, 20)
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .background(.white)
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
      Image(systemName: "star.fill").font(.system(size: 80)).foregroundColor(.yellow).offset(y: -160)
        Text("\(reward)")
//          .padding(.horizontal, 15)
        .padding(10)
          .background(.indigo)
          .foregroundColor(.white)
          .clipShape(Circle())
          .offset(x: 40, y: -200)
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
    ChallengesDialog(isActive: .constant(true), duration: 10, reward: 2, buttonTitle: "Select", action: {})
  }
}
