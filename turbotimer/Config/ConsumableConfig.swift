//
//  ConsumableConfig.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SwiftUI

struct ConsumableConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userHeroColour") var userHeroColour: Color = .yellow
  @AppStorage("userMultiplier") var userMultiplier: Double = 0
  @AppStorage("userImage") var userImage = "car1"
  @AppStorage("userConsumables") var userConsumables = [UserConsumables(id: 0, isActive: false, cost: 1, inventory: 0),
                                                        UserConsumables(id: 1, isActive: false, cost: 1, inventory: 0)]

  //  @State private var timeRemaining = 3600
  @State private var timeRemaining = 10
  @State private var timerIsActive = false
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


  var consumable: consumable

  var body: some View {
    VStack {
      Button(action: {
        if userStars >= consumable.cost && userConsumables[consumable.consumable].inventory < 10 {
          userStars -= consumable.cost
          userConsumables[consumable.consumable].inventory += 1
        }
      }) {
        ZStack {
          Image(consumable.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
          HStack {
            Text("+\(Int(consumable.multiplier * 100))%")
              .padding(.horizontal, 10)
              .padding(.vertical, 5)
              .background(Color("Background"))
              .clipShape(RoundedCorner(radius: 20, corners: [.bottomRight, .topRight]))
            Spacer()
            HStack {
              Text("\(consumable.cost)")
              starIcon()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color("Background"))
            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
          }.offset(y: -70)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.lightGray).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 20))
      }
      Text("QTY: \(userConsumables[consumable.consumable].inventory)")
      Button(action: {
        if (userConsumables[consumable.consumable].inventory > 0 && userConsumables[consumable.consumable].isActive == false && timerIsActive == false) {
          userConsumables[consumable.consumable].inventory -= 1
          userConsumables[consumable.consumable].isActive = true
          timerIsActive = true
          userMultiplier = consumable.multiplier
        }
      }) {
        if userConsumables[consumable.consumable].isActive {
          ZStack {
            ProgressView(value: progress()).progressViewStyle(MyProgressViewStyle(myColor: Color.green))
            Text(formattedTime()).foregroundStyle(Color("Text"))
          }
        } else {
          Spacer()
          Text("Activate")
          Spacer()
        }
      }
      .disabled((userConsumables[consumable.consumable].inventory == 0 && userConsumables[consumable.consumable].isActive == false) || (userConsumables[consumable.consumable].isActive == false && timerIsActive == true))
      .frame(maxWidth: .infinity, maxHeight: 40)
      .fontWeight(.heavy)
      .background(.green)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .onReceive(timer) { _ in
      if userConsumables[consumable.consumable].isActive {
        if timeRemaining > 0 {
          timeRemaining -= 1
        } else {
          userConsumables[consumable.consumable].isActive = false
          timerIsActive = false
          //          timeRemaining = 3600
          timeRemaining = 10
          userMultiplier = 0
        }
      }
    }
    .buttonStyle(PlainButtonStyle())
  }
  func progress() -> Double {
    //          max(0.0, 1.0 - Double(timeRemaining) / 3600.0)
    max(0.0, 1.0 - Double(timeRemaining) / 10.0)
  }
  func formattedTime() -> String {
    let minutes = timeRemaining / 60
    let seconds = timeRemaining % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
}
