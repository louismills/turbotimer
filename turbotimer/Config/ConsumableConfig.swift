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
  @AppStorage("consumables") var consumables = DefaultSettings.consumablesDefault
  @AppStorage("consumableIsActive") var consumableIsActive = false

  //  @State private var timeRemaining = 3600
  @State private var timeRemaining = 10

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  var consumable: Consumables

  var body: some View {
    VStack {
      Button(action: {
        if userStars >= consumable.cost && consumables[consumable.id].inventory < 10 {
          userStars -= consumable.cost
          consumables[consumable.id].inventory += 1
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
      Text("\(consumables[consumable.id].inventory)")
      Button(action: {
        if (consumables[consumable.id].inventory > 0 && consumables[consumable.id].active == false && consumableIsActive == false) {
          consumables[consumable.id].inventory -= 1
          consumables[consumable.id].active = true
          consumableIsActive = true
          userMultiplier = consumable.multiplier
        }
      }) {
        if consumables[consumable.id].active {
          ZStack {
            ProgressView(value: progress()).progressViewStyle(MyProgressViewStyle(myColor: Color.green))
            Text(formattedTime())
              .foregroundStyle(Color("Background"))
          }
          .frame(maxWidth: .infinity, maxHeight: 40)
          .fontWeight(.heavy)
          .background(Color("Text"))
          .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
//          Spacer()
          Text("Activate")
            .foregroundStyle(Color("Background"))
            .frame(maxWidth: .infinity, maxHeight: 40)
            .fontWeight(.heavy)
            .background(Color("Text"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }

      }
      .disabled((consumables[consumable.id].inventory == 0 && consumables[consumable.id].active == false) || (consumables[consumable.id].active == false && consumableIsActive == true))
    }
    .onReceive(timer) { _ in
      if consumables[consumable.id].active {
        if timeRemaining > 0 {
          timeRemaining -= 1
        } else {
          consumables[consumable.id].active = false
          consumableIsActive = false
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
