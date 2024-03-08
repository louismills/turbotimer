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

    @State private var timeRemaining = 3600
//  @State private var timeRemaining = 10

  @State var timerConsumable: Timer? = nil

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
        if timerConsumable == nil {
          timerConsumable = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ _ in
            appState.consumableNext()

            if appState.consumableTimeCountdown == 0 {
              timerConsumable?.invalidate()
              timerConsumable = nil
              consumables[consumable.id].active = false
              consumableIsActive = false
            }
          }
        }
      }) {
        
        if consumables[consumable.id].active {
          ZStack {
            ProgressView(value: appState.progress())
              .progressViewStyle(MyProgressViewStyle())
            Text(appState.consumableFormattedTime())
              .foregroundStyle(Color("Background"))
          }
          .frame(maxWidth: .infinity, maxHeight: 40)
          .fontWeight(.heavy)
          .background(Color("Text"))
          .clipShape(RoundedRectangle(cornerRadius: 20))
        } else {
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
    .buttonStyle(PlainButtonStyle())
  }
}
