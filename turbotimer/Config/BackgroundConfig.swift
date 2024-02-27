//
//  BackgroundConfig.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SwiftUI

struct BackgroundConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userBackground") var userBackground: Color = .gray
  @AppStorage("userBackgrounds") var userBackgrounds = [UserBackgrounds(id: 0, bought: true, cost: 1),
                                                        UserBackgrounds(id: 1, bought: false, cost: 1),
                                                        UserBackgrounds(id: 2, bought: false, cost: 1),
                                                        UserBackgrounds(id: 3, bought: false, cost: 1),
                                                        UserBackgrounds(id: 4, bought: false, cost: 1),
                                                        UserBackgrounds(id: 5, bought: false, cost: 1),
                                                        UserBackgrounds(id: 6, bought: false, cost: 1)]

  var background: background

  var body: some View {
    ZStack(alignment: .center) {
      Button(action: {
        if userStars >= background.cost && userBackgrounds[background.background].bought == false {
          userStars -= background.cost
          userBackgrounds[background.background].bought = true
          userBackground = background.colour
        }
        if userBackgrounds[background.background].bought == true {
          userBackground = background.colour
        }

      }) {
        ZStack(alignment: .center) {
          Circle().fill(background.colour).padding(10)

          if userBackgrounds[background.background].bought == false {
            buyShopBtn(cost: background.cost).offset(x: 30, y: -30)
          }
          else {
            if userBackground.rawValue == background.colour.rawValue {
              equippedBtn().offset(x: 30, y: -30)
            }
          }
        }
      }
      .buttonStyle(PlainButtonStyle())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
