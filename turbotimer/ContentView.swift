//
//  ContentView.swift
//  turbotimer
//
//  Created by Louis Mills on 09/01/2024.
//

import SwiftUI
import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

struct AppBtn: ViewModifier {
  @AppStorage("sessionRunning") var sessionRunning = false

  let color: Color

  func body(content: Content) -> some View {
    content
      .frame(minWidth: 80, minHeight: 45)
      .background(color)
//      .foregroundColor(.white)
      .foregroundColor(Color("Background"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct BtnTextPanelFormat: ViewModifier {
  @AppStorage("userTheme") var userTheme = "gray"

  func body(content: Content) -> some View {
    content
      .padding(5)
      .background(Color("BackgroundPanel"))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color(userTheme), lineWidth: 2)
      )
      .clipShape(RoundedRectangle(cornerRadius: 16))
  }
}

struct BtnTextFormat: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(5)
      .background(Color("Background"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct BtnFormat: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(minWidth: 50, maxWidth: 50, minHeight: 45)
      .background(Color("Text"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct starIcon: View {
  var body: some View {
    Image(systemName: "star.fill")
      .foregroundColor(.yellow)
  }
}

struct equippedBtn: View {
  var body: some View {
    HStack {
      Text(Image(systemName:"checkmark.circle.fill"))
        .foregroundColor(Color("Text"))
        .padding(.horizontal, 10)
    }
    .btnTextFormat()
  }
}

struct dismissBtn: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .foregroundColor(Color("Text"))
    }
  }
}

struct MyProgressViewStyle: ProgressViewStyle {
//  var myColor: Color

  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
//      .accentColor(myColor)
      .accentColor(Color("Text"))
      .background(Color(UIColor.lightGray).opacity(0.4))
      .frame(minHeight: 45)
      .scaleEffect(x: 1, y: 15, anchor: .center)
      .clipShape(RoundedRectangle(cornerRadius: 40))
  }
}

struct buyShopBtn: View {
  let cost: Int

  var body: some View {
    HStack {
      Text("\(cost)")
        .foregroundColor(Color("Text"))
        .padding(.leading, 10)
      starIcon()
    }
    .btnTextFormat()
  }
}

extension View {
  func btnTextFormat() -> some View {
    modifier(BtnTextFormat())
  }
  func btnTextPanelFormat() -> some View {
    modifier(BtnTextPanelFormat())
  }
  func btnFormat() -> some View {
    modifier(BtnFormat())
  }
}

extension Button {
  func appBtn(color: Color = .red) -> some View {
    modifier(AppBtn(color: color))
  }
}

struct ContentView: View {
  @Environment(\.scenePhase) var scenePhase
  @Environment(\.dismiss) var dismiss

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTotalSessionTime") var userTotalSessionTime = 0
  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("userTheme") var userTheme = "gray"
  @AppStorage("userImage") var userImage = "car1"
  @AppStorage("showingSessionTimerWarning") var showingSessionTimerWarning = false

  @State var appState = AppState()
  @State var timer: Timer? = nil
  @State private var showingStore = false
  @State var sessionRunning = false

  @State var gameScene: GameScene = {
    let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    scene.scaleMode = .resizeFill
    scene.backgroundColor = UIColor(Color("Background"))
    return scene
  }()

  @Environment(\.colorScheme) var colorScheme // wip

  var body: some View {
    ZStack {
      SpriteView(scene: gameScene)
        .onChange(of: self.colorScheme) {
          gameScene.updateBackgroundColor(mode: self.colorScheme)
    }
        .frame(maxHeight: UIScreen.main.bounds.size.height)

      VStack(spacing: 10) {
        // TOP NAV SECTION - total stars, total session time and shop
        HStack {
          HStack {
            Text("\(userStars)")
              .foregroundColor(Color("Text"))
            starIcon()
          }
          .padding(10)
          .font(.system(size: 20))
          .frame(height: 30)
          .background(Color("BackgroundPanel"))
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color(userTheme), lineWidth: 2)
          )
          .clipShape(RoundedRectangle(cornerRadius: 16))

          HStack {
            Text("\(userTotalSessionTime)")
            Image(systemName: "clock")
              .foregroundColor(Color("Text"))
          }
          .padding(10)
          .font(.system(size: 20))
          .frame(height: 30)
          .background(Color("BackgroundPanel"))
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color(userTheme), lineWidth: 2)
          )
          .clipShape(RoundedRectangle(cornerRadius: 16))
          Spacer()
          Button {
            showingStore.toggle()
          } label: {
            Image(systemName: "cart")
//              .foregroundColor(.white)
              .foregroundColor(Color("Background"))
              .font(.system(size: 20))
          }.btnFormat()
            .fullScreenCover(isPresented: $showingStore) {
              StoreView(appState: $appState)
            }
        }
        // END OF TOP NAV SECTION
        Spacer()
        sessionTimerSection(appState: $appState, scene: gameScene)
          .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
            if newPhase  == .background {
              sessionRunning = false
              timer?.invalidate()
              timer = nil
              appState.reset()
            }
          }
          .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
          }
      }
      .padding(.bottom, 53)
      .padding(.top, 55)
      .padding(.horizontal, 15)

      if showingSessionTimerWarning {
        SessionTimerDialog(isActive: $showingSessionTimerWarning, appState: $appState) {
          showingSessionTimerWarning = false
        }
      }
    }
    .ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
