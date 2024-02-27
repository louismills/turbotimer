//
//  StoreView.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SpriteKit
import GameplayKit
import CoreMotion

import SwiftUI
import AVFoundation

struct StoreView: View {
  @Binding var appState: AppState

  @Environment(\.dismiss) var dismiss

  @State private var showingPurchases = false

  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("userBackground") var userBackground: Color = .gray
  @AppStorage("userStars") var userStars = 0

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        GeometryReader { geo in
          HStack(spacing: 0) {
            Text("")
              .frame(width: geo.size.width / 4, alignment: .leading)
            Text("STORE")
              .foregroundColor(Color("Text"))
              .font(.title3)
              .fontWeight(.bold)
              .frame(maxWidth: .infinity, alignment: .center)
            dismissBtn()
              .frame(width: geo.size.width / 4, alignment: .trailing)
          }
        }
        .frame(height: 30)
        .padding()
        .background(Color("Background"))

        Divider()
          .overlay(Color(UIColor.lightGray))
          .edgesIgnoringSafeArea(.horizontal)

        ScrollView {
          HStack {
            //            Text("\(userStars)")
            //              .foregroundColor(Color("Text"))
            //            starIcon()
            //              .padding(.leading, 10)

            // In store purchases button
            Button {
              showingPurchases.toggle()
            } label: {
              Image(systemName: "plus.circle.fill").foregroundColor(.green).font(.system(size: 23))
              Text("\(userStars)")
                .foregroundColor(Color("Text"))
              starIcon()
            }
          }.font(.system(size: 20))
            .btnTextPanelFormat()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top], 20)

          VStack() {
            // BOOSTS
            VStack {
              Text("Boosts")
                .foregroundColor(Color("Text"))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("Temporarily shift into a higher gear for a boost in performance!")
                .foregroundColor(Color("Text"))
                .frame(maxWidth: .infinity, alignment: .leading)
              GeometryReader { geo in
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                  GridRow {
                    ConsumableConfig(appState: $appState, consumable: appState.consumables[0])
                    ConsumableConfig(appState: $appState, consumable: appState.consumables[1])
                  }
                  .padding(4)
                  .frame(width: geo.size.width / 2, height: geo.size.height)
                }
              }.frame(height: 280)
            }
            .padding()
            .background(Color("BackgroundPanel"))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color(userBackground), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
            }.padding(10)
            // THEMES
            VStack {
              Text("Themes")
                .foregroundColor(Color("Text"))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("Set the mood with these clean themes!")
                .foregroundColor(Color("Text"))
                .frame(maxWidth: .infinity, alignment: .leading)
              GeometryReader { geo in
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                  GridRow {
                    BackgroundConfig(appState: $appState, background: appState.backgrounds[0])
                    BackgroundConfig(appState: $appState, background: appState.backgrounds[1])
                    BackgroundConfig(appState: $appState, background: appState.backgrounds[2])
                  }
                  .padding(4)
                  .frame(width: geo.size.width / 3, height: geo.size.height / 2)
                  GridRow {
                    BackgroundConfig(appState: $appState, background: appState.backgrounds[3])
                    BackgroundConfig(appState: $appState, background: appState.backgrounds[4])
                    BackgroundConfig(appState: $appState, background: appState.backgrounds[5])
                  }
                  .padding(4)
                  .frame(width: geo.size.width / 3, height: geo.size.height / 2)
                }
              }.frame(height: 300)
            }
            .padding()
            .background(Color("BackgroundPanel"))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
                .stroke(Color(userBackground), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
          }
          .padding()
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
      }
      if showingPurchases {
        PurchasesDialog(isActive: $showingPurchases) {
          showingPurchases = false
          dismiss()
        }
      }
    }
    .background(Color("Background"))
  }
}
