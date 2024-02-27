//
//  ConsumableConfig.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ConsumableConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userMultiplier") var userMultiplier: Double = 0
  @AppStorage("userConsumables") var userConsumables = DefaultSettings.consumablesDefault

  //  @State private var timeRemaining = 3600
  @State private var timeRemaining = 10
  @State private var timerIsActive = false
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


//  var consumable: consumable
  var consumable: UserConsumables

  var body: some View {
    VStack {
      Button(action: {
        if userStars >= consumable.cost && userConsumables[consumable.id].inventory < 10 {
          userStars -= consumable.cost
          userConsumables[consumable.id].inventory += 1
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
      Text("\(userConsumables[consumable.id].inventory)")
      Button(action: {
        if (userConsumables[consumable.id].inventory > 0 && userConsumables[consumable.id].isActive == false && timerIsActive == false) {
          userConsumables[consumable.id].inventory -= 1
          userConsumables[consumable.id].isActive = true
          timerIsActive = true
          userMultiplier = consumable.multiplier
        }
      }) {
        if userConsumables[consumable.id].isActive {
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
      .disabled((userConsumables[consumable.id].inventory == 0 && userConsumables[consumable.id].isActive == false) || (userConsumables[consumable.id].isActive == false && timerIsActive == true))
      .frame(maxWidth: .infinity, maxHeight: 40)
      .fontWeight(.heavy)
      .background(.green)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .onReceive(timer) { _ in
      if userConsumables[consumable.id].isActive {
        if timeRemaining > 0 {
          timeRemaining -= 1
        } else {
          userConsumables[consumable.id].isActive = false
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
