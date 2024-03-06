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
  @AppStorage("userTheme") var userTheme = "gray"
  @AppStorage("themes") var themes = DefaultSettings.themesDefault

  var theme: Themes

  var body: some View {
    ZStack(alignment: .center) {
      Button(action: {
        if userStars >= theme.cost && themes[theme.id].bought == false {
          userStars -= theme.cost
          themes[theme.id].bought = true
          userTheme = theme.colour
        }
        if themes[theme.id].bought == true {
          userTheme = theme.colour
        }
      }) {
        ZStack(alignment: .center) {
          Circle().fill(Color(theme.colour)).padding(10)

          // Theme not bought
          if themes[theme.id].bought == false {
//            buyShopBtn(cost: theme.cost)
            HStack {
              Text("\(theme.cost)")
                .foregroundColor(Color("Text"))
                .padding(.leading, 10)
              starIcon()
            }
            .btnTextFormat()
            .background(Color("Background"))
            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
            .offset(x: 25, y: -40)
          }
          else {
            // Theme bought and equipped
            if Color(userTheme) == Color(theme.colour) {
//              equippedBtn()
              HStack {
                Text(Image(systemName:"checkmark.circle.fill"))
                  .foregroundColor(Color("Text"))
                  .padding(.horizontal, 10)
              }
              .btnTextFormat()
                .background(Color("Background"))
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .bottomLeft]))
                .offset(x: 35, y: -40)
            }

          }
        }
      }
      .buttonStyle(PlainButtonStyle())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(UIColor.lightGray).opacity(0.4))
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
