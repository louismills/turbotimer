//
//  ContentView.swift
//  astrotimer
//
//  Created by Louis Mills on 09/01/2024.
//

import SwiftUI
import AVFoundation

struct AppBtn: ViewModifier {
  @AppStorage("sessionRunning") var sessionRunning = false

  let color: Color

  func body(content: Content) -> some View {
    content
      .frame(minWidth: sessionRunning ? 80 : 250, minHeight: 45)
      .background(color)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct BtnTextFormat: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(5)
//      .background(.black)
      .background(Color("Background"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct BtnStoreFormat: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(minWidth: 50, maxWidth: 50, minHeight: 45)
      .background(.green)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct SettingBtnTextFormat: ViewModifier {
  func body(content: Content) -> some View {
    content
      .frame(minWidth: 50, maxWidth: 50, minHeight: 45)
      .background(.green)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct starIcon: View {
  var body: some View {
    Image(systemName: "star.fill").foregroundColor(.yellow)
  }
}

//struct equipBtn: View {
//  var body: some View {
//    HStack {
//      Text("Equip").foregroundColor(.white).padding(.leading, 10).padding(.trailing, 10)
//    }
//    .btnTextFormat()
//  }
//}

struct equippedBtn: View {
  var body: some View {
    HStack {
      Text(Image(systemName:"checkmark.circle.fill"))
        .foregroundColor(Color("Text"))
        .padding(.leading, 10).padding(.trailing, 10)
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
      Image(systemName: "xmark.circle.fill").font(.title)
        .foregroundColor(Color("Text"))
    }
  }
}

struct dismissSettingsBtn: View {
  @Environment(\.dismiss) var dismiss

  @AppStorage("challengeSelected") var challengeSelected = false

  var body: some View {
    Button {
      dismiss()
      challengeSelected = false

    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .foregroundColor(Color("Text"))
    }
  }
}

struct MyProgressViewStyle: ProgressViewStyle {
  var myColor: Color

  func makeBody(configuration: Configuration) -> some View {
    ProgressView(configuration)
      .accentColor(myColor)
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
    }.btnTextFormat()
  }
}

extension View {
  func btnTextFormat() -> some View {
    modifier(BtnTextFormat())
  }
}

extension View {
  func btnStoreFormat() -> some View {
    modifier(BtnStoreFormat())
  }
}

extension View {
  func settingBtnTextFormat() -> some View {
    modifier(SettingBtnTextFormat())
  }
}

extension Button {
  func appBtn(color: Color = .red) -> some View {
    modifier(AppBtn(color: color))
  }
}

struct challengeConfig: View {
  @Environment(\.dismiss) var dismiss

  @Binding var appState: AppState

  @State var timer: Timer? = nil

  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("challengeSelected") var challengeSelected = false
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedReward") var challengeSelectedReward = 0

  let workMinutes: Int
  let reward: Int

  var body: some View {
    Button(action: {
      challengeSelected = true
      challengeSelectedDuration = workMinutes
      challengeSelectedReward = reward
    }) {
      HStack {
        Spacer()
        VStack {
          Spacer()
          if workMinutes < 60 {
            Text("\(workMinutes)").font(.system(size: 50))
            Text("MINUTES").font(.system(size: 22))
          } else {
            let remainingMins = (workMinutes - (((workMinutes) / 60) * 60))
            if remainingMins > 0 {
              Text("\(workMinutes / 60):\(remainingMins)").font(.system(size: 50))
              Text("HOURS").font(.system(size: 22))
            } else {
              if (workMinutes / 60) > 1 {
                Text("\(workMinutes / 60)").font(.system(size: 50))
                Text("HOURS").font(.system(size: 22))
              } else {
                Text("\(workMinutes / 60)").font(.system(size: 50))
                Text("HOUR").font(.system(size: 22))
              }
            }
          }
          Spacer()
        }
        Spacer()
      }
      .fontWeight(.heavy)
      .foregroundColor(.white)
      .background(.green)
//      .background(Color("Button"))
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct petConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0

  @AppStorage("userHeroColour") var userHeroColour: Color = .yellow

  @AppStorage("userMultiplier") var userMultiplier: Double = 0

  @AppStorage("userImage") var userImage = "fish.fill"

  @AppStorage("userShops") var userStores = [UserShops(id: 0, bought: true, cost: 1),
                                            UserShops(id: 1, bought: false, cost: 40),
                                            UserShops(id: 2, bought: false, cost: 80),
                                            UserShops(id: 3, bought: false, cost: 100),
                                            UserShops(id: 4, bought: false, cost: 125),
                                            UserShops(id: 5, bought: false, cost: 200),
                                            UserShops(id: 6, bought: false, cost: 250),
                                            UserShops(id: 7, bought: false, cost: 500),
                                            UserShops(id: 8, bought: false, cost: 750),
                                            UserShops(id: 9, bought: false, cost: 1000)]

  var store: shop

  var body: some View {
    Button(action: {
      if userStars >= store.cost && userStores[store.shop].bought == false {
        userStars -= store.cost
        userStores[store.shop].bought = true
        userMultiplier = store.multiplier
      }
      if userStores[store.shop].bought == true {
        userMultiplier = store.multiplier
        userImage = store.image
      }
    }) {
      ZStack {
        Image(systemName: store.image)
          .font(.system(size: 80))
          .foregroundColor(.white)
        if Int(store.multiplier * 100) > 0 {
          Text("\(Int(store.multiplier * 100))%")
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color("Background"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .offset(x: -50, y: -70)
        }
        if userStores[store.shop].bought == false {
          buyShopBtn(cost: store.cost).offset(x: 40, y: -70)
        }
        else {
          if userMultiplier == store.multiplier {
            equippedBtn().offset(x: 50, y: -70)
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(UIColor.lightGray).opacity(0.4))
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct backgroundConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userBackground") var userBackground: Color = .yellow
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
        if userBackgrounds[background.background].bought == false {
          ZStack(alignment: .center) {
            Circle()
//              .fill(background.colour.opacity(0.6))
              .fill(background.colour)
              .frame(width: 80, height: 80)
              .shadow(radius: 10)

            buyShopBtn(cost: background.cost)
              .offset(x: 30, y: -30)
          }
        }
        else {
          if userBackground.rawValue != background.colour.rawValue {
            ZStack(alignment: .center) {
              Circle()
//                .fill(background.colour.opacity(0.6))
                .fill(background.colour)
                .frame(width: 80, height: 80)
            }
          } else {
            ZStack(alignment: .center) {
              Circle()
//                .fill(background.colour.opacity(0.6))
                .fill(background.colour)
                .frame(width: 80, height: 80)
                .shadow(radius: 10)

              equippedBtn()
                .offset(x: 30, y: -30)
            }
          }
        }
      }.buttonStyle(PlainButtonStyle())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct SheetChallengesView: View {
  @Binding var appState: AppState

  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("sessionRunning") var sessionRunning = false
  @AppStorage("challengeSelected") var challengeSelected = false
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedReward") var challengeSelectedReward = 0
  @AppStorage("userSessionTime") var userSessionTime = 0

  @Environment(\.dismiss) var dismiss

  var body: some View {

    GeometryReader { geo in
      ZStack {
        HStack(spacing: 0) {
          Text("")
            .frame(width: geo.size.width / 4, alignment: .leading)
          Text("CHALLENGES")
            .foregroundColor(Color("Text"))
            .font(.title3).fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
          dismissSettingsBtn()
            .frame(width: geo.size.width / 4, alignment: .trailing)
        }
      }
      .frame(height: 30)
      .padding()
      .background(Color("Background"))

      Divider()
        .frame(height: 1)
//        .overlay(Color("Text"))
        .overlay(Color(UIColor.lightGray))
          .offset(y: 60)
        .edgesIgnoringSafeArea(.horizontal)

      GeometryReader { geo in
        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 5, reward: 1)
            challengeConfig(appState: $appState, workMinutes: 10, reward: 2)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7).foregroundColor(.black).background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 15, reward: 3)
            challengeConfig(appState: $appState, workMinutes: 20, reward : 5)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7).foregroundColor(.black).background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 25, reward: 7)
            challengeConfig(appState: $appState, workMinutes: 30, reward: 11)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7).foregroundColor(.black).background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 45, reward: 15)
            challengeConfig(appState: $appState, workMinutes: 60, reward: 22)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7).foregroundColor(.black).background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 90, reward: 30)
            challengeConfig(appState: $appState, workMinutes: 120, reward: 38)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7).foregroundColor(.black).background(.green).clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .frame(width: geo.size.width, height: geo.size.height)
      }
      .padding([.horizontal], 30)
      .offset(y: 20)
      //    Stepper("\(appState.restMinutes) min break ", value: $appState.restMinutes, in: 1...60)
      //      .padding()
      //      .background(.white)
      //      .foregroundColor(.black)
      //      .font(.title)

      if challengeSelected {
        ChallengesDialog(isActive: $challengeSelected, duration: challengeSelectedDuration, reward: challengeSelectedReward, buttonTitle: "Select") {
          appState.workMinutes = challengeSelectedDuration
          dismiss()
        }
      }
    }
  }
}

struct SheetStoreView: View {
  @Binding var appState: AppState

  @Environment(\.dismiss) var dismiss

  @State private var showingPurchases = false

  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("userBackground") var userBackground: Color = .yellow
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
        .shadow(radius: 10)
        .padding()
        .background(Color("Background"))

        Divider()
          .frame(height: 2)
//          .overlay(Color("Text"))
          .overlay(Color(UIColor.lightGray))
//          .offset(y: 60)
          .edgesIgnoringSafeArea(.horizontal)

        ScrollView {
          HStack(spacing: 0) {
            starIcon().padding(.trailing, 10)
            Text("\(userStars)")
              .padding(.trailing, 10)
            // In store purchases button
            //            Button {
            //              showingPurchases.toggle()
            //            } label: {
            //              Image(systemName: "plus.circle.fill").foregroundColor(.green)
            //            }
          }
          .btnTextFormat()
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding([.leading, .top], 20)

          VStack() {
            // PETS
            VStack() {
              Text("Pets")
                .foregroundColor(Color("Text"))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("Speed up your star collection with better friends!")
                .foregroundColor(Color("Text"))
                .frame(maxWidth: .infinity, alignment: .leading)
              GeometryReader { geo in
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                  GridRow {
                    petConfig(appState: $appState, store: appState.shops[0])
                      .padding(.trailing, 10)
                    petConfig(appState: $appState, store: appState.shops[1])
                      .padding(.leading, 10)
                  }
                  .padding(.bottom, 10)
                  .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                  GridRow {
                    petConfig(appState: $appState, store: appState.shops[2])
                      .padding(.trailing, 10)
                    petConfig(appState: $appState, store: appState.shops[3])
                      .padding(.leading, 10)
                  }
                  .padding(.bottom, 10)
                  .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                }
              }.frame(height: 400)
            }
            .padding()
            .background(Color("Background"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)

            HStack {
            }.padding(10)
            // BACKGROUNDS
            VStack {
              Text("Backgrounds")
                .foregroundColor(Color("Text"))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("You deserve to look great!")
                .foregroundColor(Color("Text"))
                .frame(maxWidth: .infinity, alignment: .leading)
              GeometryReader { geo in
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                  GridRow {
                    backgroundConfig(appState: $appState, background: appState.backgrounds[0])
                    backgroundConfig(appState: $appState, background: appState.backgrounds[1])
                    backgroundConfig(appState: $appState, background: appState.backgrounds[2])
                  }
                  .padding(4)
                  .frame(width: geo.size.width / 3, height: geo.size.height / 2)
                  GridRow {
                    backgroundConfig(appState: $appState, background: appState.backgrounds[3])
                    backgroundConfig(appState: $appState, background: appState.backgrounds[4])
                    backgroundConfig(appState: $appState, background: appState.backgrounds[5])
                  }
                  .padding(4)
                  .frame(width: geo.size.width / 3, height: geo.size.height / 2)
                }
              }.frame(height: 300)
            }
            .padding()
            .background(Color("Background"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
          }
          .padding()
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
      }
      if showingPurchases {
        PurchasesDialog(isActive: $showingPurchases, message1: "50", buttonTitle1: "Buy for £0.99", message2: "225", buttonTitle2: "Buy for £2.99") {
          showingPurchases = false
          dismiss()
        }
      }
    }
//    .background(userBackground.opacity(0.6))
    .background(userBackground)
  }
}


struct ContentView: View {
  @Environment(\.scenePhase) var scenePhase

  @Environment(\.dismiss) var dismiss

  @State var appState = AppState {
    AudioServicesPlaySystemSound(1032)
  }

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTotalSessionTime") var userTotalSessionTime = 0
  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("userBackground") var userBackground: Color = .yellow
  @AppStorage("userImage") var userImage = "fish.fill"

  @AppStorage("showingSessionTimerWarning") var showingSessionTimerWarning = false

  @State var timer: Timer? = nil
  @State private var showingStore = false
  @State var sessionRunning = false

  var body: some View {
    ZStack {
      VStack(spacing: 10) {
        // TOP NAV SECTION - total stars, total session time, shop
        HStack {
          HStack {
            starIcon().padding(.leading, 10)
            Text("\(userStars)")
              .foregroundColor(Color("Text"))
              .padding(.trailing, 10)
          }
          .btnTextFormat()
//          .shadow(radius: 10)
          HStack {
            Text("\(userTotalSessionTime)")
              .padding(.leading, 10)
            Image(systemName: "clock")
              .foregroundColor(Color("Text"))
              .padding(.trailing, 10)
          }
          .btnTextFormat()
//          .shadow(radius: 10)
          Spacer()
          Button {
            showingStore.toggle()
          } label: {
            Image(systemName: "cart")
//              .foregroundColor(Color("Text"))
              .foregroundColor(.white)
              .padding(.leading, 10).padding(.trailing, 10).font(.system(size: 25))
          }.btnStoreFormat()
//            .shadow(radius: 10)
            .fullScreenCover(isPresented: $showingStore) {
              SheetStoreView(appState: $appState)
            }
        }
        // END OF TOP NAV SECTION
        Spacer()
        Image(systemName: userImage).foregroundColor(.white).font(.system(size: 100))
        sessionTimerSection(appState: $appState)
          .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
            if newPhase == .active {
              print("Active")
              UIApplication.shared.isIdleTimerDisabled = false
            } else if newPhase == .inactive {
              print("Inactive")
            } else if newPhase == .background {
              print("Background")
              sessionRunning = false
              timer?.invalidate()
              timer = nil
              appState.reset()
            }
          }
      }
      .padding()
      .background(userBackground)
//      .background(userBackground.opacity(0.6))

      if showingSessionTimerWarning {
        SessionTimerDialog(isActive: $showingSessionTimerWarning, appState: $appState) {
          showingSessionTimerWarning = false
          dismiss()
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
