//
//  BackgroundConfig.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SwiftUI

struct ThemeConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTheme") var userTheme: Color = .gray
  @AppStorage("themes") var themes = DefaultSettings.themesDefault

  var theme: Themes

  var body: some View {
    ZStack(alignment: .center) {
      Button(action: {
        if userStars >= theme.cost && themes[theme.id].bought == false {
          userStars -= theme.cost
          themes[theme.id].bought = true
          userTheme = Color(theme.colour)
        }
        if themes[theme.id].bought == true {
          userTheme = Color(theme.colour)
        }
      }) {
        ZStack(alignment: .center) {
          Circle().fill(Color(theme.colour)).padding(10)

          if themes[theme.id].bought == false {
            buyShopBtn(cost: theme.cost).offset(x: 30, y: -30)
          }
          else {
            if userTheme.rawValue == Color(theme.colour).rawValue {
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
