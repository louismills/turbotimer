//
//  ContentView.swift
//  turbotimer
//
//  Created by Louis Mills on 09/01/2024.
//

import SpriteKit
import GameplayKit
import CoreMotion

import SwiftUI
import AVFoundation

struct AppBtn: ViewModifier {
  @AppStorage("sessionRunning") var sessionRunning = false

  let color: Color

  func body(content: Content) -> some View {
    content
//      .frame(minWidth: sessionRunning ? 80 : 250, minHeight: 45)
      .frame(minWidth: 80, minHeight: 45)
      .background(color)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct BtnTextPanelFormat: ViewModifier {
  @AppStorage("userBackground") var userBackground: Color = .red

  func body(content: Content) -> some View {
    content
      .padding(5)
      .background(Color("BackgroundPanel"))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color(userBackground), lineWidth: 2)
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
  func btnTextPanelFormat() -> some View {
    modifier(BtnTextPanelFormat())
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

//  @State var timer: Timer? = nil

  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userBackground") var userBackground: Color = .red
  @AppStorage("challengeSelected") var challengeSelected = false
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedRewardStars") var challengeSelectedRewardStars = 0
  @AppStorage("challengeSelectedRewardTyres") var challengeSelectedRewardTyres = 0

  let workMinutes: Int
  let rewardTyres: Int
  let rewardStars: Int

  var body: some View {
    Button(action: {
      challengeSelected = true
      challengeSelectedDuration = workMinutes
      challengeSelectedRewardTyres = rewardTyres
      challengeSelectedRewardStars = rewardStars
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
      .foregroundColor(Color("Text"))
      .background(Color("BackgroundPanel"))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color(userBackground), lineWidth: 2)
      )
      .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct vehicleConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userHeroColour") var userHeroColour: Color = .yellow
  @AppStorage("userMultiplier") var userMultiplier: Double = 0
  @AppStorage("userImage") var userImage = "car1"
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
        Image(store.image)
          .resizable()
          .aspectRatio(contentMode: .fit)
        if Int(store.multiplier * 100) > 0 {
          Text("+\(Int(store.multiplier * 100))%")
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

struct consumableConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userHeroColour") var userHeroColour: Color = .yellow
  @AppStorage("userMultiplier") var userMultiplier: Double = 0
  @AppStorage("userImage") var userImage = "car1"
  @AppStorage("userConsumables") var userConsumables = [UserConsumables(id: 0, bought: false, cost: 1, inventory: 0),
                                                        UserConsumables(id: 1, bought: false, cost: 1, inventory: 0)]

  var consumable: consumable

  var body: some View {
    VStack {
      Button(action: {
        if userStars >= consumable.cost && userConsumables[consumable.consumable].bought == false {
          userStars -= consumable.cost
          userConsumables[consumable.consumable].bought = true
          userMultiplier = consumable.multiplier
        }
        if userConsumables[consumable.consumable].bought == true {
          userMultiplier = consumable.multiplier
          userImage = consumable.image
        }
      }) {
        ZStack {
          Image(consumable.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
          Text("+\(Int(consumable.multiplier * 100))%")
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color("Background"))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .offset(x: -50, y: -70)
          if userConsumables[consumable.consumable].bought == false {
            buyShopBtn(cost: consumable.cost).offset(x: 40, y: -70)
          }
          else {
            if userMultiplier == consumable.multiplier {
              equippedBtn().offset(x: 50, y: -70)
            }
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.lightGray).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 20))

      }
      Text("\(consumable.inventory)")
      Button(action: {
        userConsumables[consumable.consumable].inventory -= 1
        print(consumable.inventory)
      }) {
        if consumable.inventory > 0 {
          Text("Activate")
        } else {
          Text("Buy")
        }
      }
    }
    .buttonStyle(PlainButtonStyle())

  }
}

struct backgroundConfig: View {
  @Binding var appState: AppState

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userBackground") var userBackground: Color = .red
  //  @AppStorage("userBackground") var userBackground = "bg1"
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
          //          userBackground = background.image
          userBackground = background.colour
        }
        if userBackgrounds[background.background].bought == true {
          //          userBackground = background.image
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

struct SheetChallengesView: View {
  @Binding var appState: AppState

  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("sessionRunning") var sessionRunning = false
  @AppStorage("challengeSelected") var challengeSelected = false
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedRewardStars") var challengeSelectedRewardStars = 0
  @AppStorage("challengeSelectedRewardTyres") var challengeSelectedRewardTyres = 0
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
        .overlay(Color(UIColor.lightGray))
        .offset(y: 60)
        .edgesIgnoringSafeArea(.horizontal)

      GeometryReader { geo in
        Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 5, rewardTyres: 1, rewardStars: 1)
            challengeConfig(appState: $appState, workMinutes: 10, rewardTyres: 1,rewardStars: 2)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 15, rewardTyres: 1,rewardStars: 3)
            challengeConfig(appState: $appState, workMinutes: 20, rewardTyres: 1,rewardStars: 5)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 25, rewardTyres: 1,rewardStars: 7)
            challengeConfig(appState: $appState, workMinutes: 30, rewardTyres: 1,rewardStars: 11)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 45, rewardTyres: 1,rewardStars: 15)
            challengeConfig(appState: $appState, workMinutes: 60, rewardTyres: 1,rewardStars: 22)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
          GridRow {
            challengeConfig(appState: $appState, workMinutes: 90, rewardTyres: 1,rewardStars: 30)
            challengeConfig(appState: $appState, workMinutes: 120, rewardTyres: 1,rewardStars: 38)
          }
          .frame(width: geo.size.width / 2, height: geo.size.height / 7)
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
        ChallengesDialog(isActive: $challengeSelected, duration: challengeSelectedDuration, rewardTyres: challengeSelectedRewardTyres, rewardStars: challengeSelectedRewardStars) {
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
  //  @AppStorage("userBackground") var userBackground = "bg1"
  @AppStorage("userBackground") var userBackground: Color = .red
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
            starIcon().padding(.leading, 10)
            Text("\(userStars)")
              .foregroundColor(Color("Text"))
            // In store purchases button
            Button {
              showingPurchases.toggle()
            } label: {
              Image(systemName: "plus.circle.fill").foregroundColor(.green)
            }
          }.font(.system(size: 20))
            .btnTextPanelFormat()

            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .top], 20)

          VStack() {
            // VEHICLES
            VStack() {
              Text("Effects")
                .foregroundColor(Color("Text"))
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
              Text("Speed up your trophy collection with better vehicles!")
                .foregroundColor(Color("Text"))
                .frame(maxWidth: .infinity, alignment: .leading)
              GeometryReader { geo in
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 0) {
                  GridRow {
                    vehicleConfig(appState: $appState, store: appState.shops[0])
                      .padding(.trailing, 10)
                    vehicleConfig(appState: $appState, store: appState.shops[1])
                      .padding(.leading, 10)
                  }
                  .padding(.bottom, 10)
                  .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                  GridRow {
                    vehicleConfig(appState: $appState, store: appState.shops[2])
                      .padding(.trailing, 10)
                    vehicleConfig(appState: $appState, store: appState.shops[3])
                      .padding(.leading, 10)
                  }
                  .padding(.bottom, 10)
                  .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                }
              }.frame(height: 400)
            }
            .padding()
            .background(Color("BackgroundPanel"))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
              //                .stroke(Color("Text"), lineWidth: 2)
                .stroke(Color(userBackground), lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
            }.padding(10)

            // BOOSTS
            VStack {
              Text("Powerful Boosts")
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
                    consumableConfig(appState: $appState, consumable: appState.consumables[0])
                    consumableConfig(appState: $appState, consumable: appState.consumables[1])
                  }
                  .padding(4)
                  .frame(width: geo.size.width / 2, height: geo.size.height)
                }
              }.frame(height: 250)
            }
            .padding()
            .background(Color("BackgroundPanel"))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
              //                .stroke(Color("Text"), lineWidth: 2)
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
            .background(Color("BackgroundPanel"))
            .overlay(
              RoundedRectangle(cornerRadius: 16)
              //                .stroke(Color("Text"), lineWidth: 2)
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
        PurchasesDialog(isActive: $showingPurchases, message1: "50", buttonTitle1: "Buy for £0.99", message2: "225", buttonTitle2: "Buy for £2.99") {
          showingPurchases = false
          dismiss()
        }
      }
    }
    .background(Color("Background"))
  }
}

// WIP
enum CollisionType: UInt32 {
  case object = 1
  case wall = 2
}

class GameScene: SKScene {
//class GameScene: SKScene, ObservableObject { // wip
//  @State var timer: Timer? = nil // wip

  private var motionManager: CMMotionManager!

  private var ball: SKCropNode!

  @AppStorage("userBackground") var userBackground: Color = .red

  //  init(sceneSize: CGSize) {
  //    super.init(size: sceneSize)
  //  }
  //
  //  required init?(coder aDecoder: NSCoder) {
  //    fatalError("init(coder:) has not been implemented")
  //  }

  override func sceneDidLoad() {
    setUpBounds()
//    createBall()
    setUpBox()
    setUpBtnTopLeft()
    setUpBtnTopRight()

    createTyre(tyreType: "tyreRed")
    createTyre(tyreType: "tyreBlue")
    createTyre(tyreType: "tyreYellow")
    createTyre(tyreType: "tyreWhite")
    createTyre(tyreType: "tyreGreen")
  }

  override func didMove(to view: SKView) {
    motionManager = CMMotionManager()
    motionManager.startAccelerometerUpdates()
    self.backgroundColor = UIColor(Color("Background"))
    self.physicsWorld.gravity = .zero
    self.scaleMode = .aspectFit
  }


  private func setUpBounds() {
    self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    self.physicsBody?.isDynamic = false
    self.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
  }

  private func setUpBox() {
    let screen = UIScreen.main.bounds
    let screenWidth = screen.size.width
    let shape = SKShapeNode()
    let shapePath = UIBezierPath(roundedRect: CGRect(x: self.frame.origin.x + 53, y: self.frame.origin.y + 53, width: screenWidth - 106, height: 220), cornerRadius: 20).cgPath
    shape.path = shapePath
    //    shape.position = CGPoint(x: frame.midX, y: frame.midY)

    //    shape.physicsBody = SKPhysicsBody(edgeChainFrom: shapePath)
    shape.physicsBody = SKPhysicsBody(polygonFrom: shapePath)
    shape.physicsBody?.isDynamic = false
    shape.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
    shape.strokeColor = UIColor(.black.opacity(0))
    shape.lineWidth = 2
    addChild(shape)
  }

  private func setUpBtnTopLeft() {
//    let screen = UIScreen.main.bounds
    let btnTop = SKShapeNode()
    let shapePath = UIBezierPath(roundedRect: CGRect(x: self.frame.origin.x + 16, y: self.frame.maxY - 112, width: 166, height: 30), cornerRadius: 20).cgPath

    btnTop.path = shapePath
    btnTop.physicsBody = SKPhysicsBody(polygonFrom: shapePath)
    btnTop.physicsBody?.isDynamic = false
    btnTop.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
//    btnTop.strokeColor = UIColor(.black.opacity(0))
    btnTop.lineWidth = 2
    addChild(btnTop)
  }

  private func setUpBtnTopRight() {
//    let screen = UIScreen.main.bounds
    let btnTop = SKShapeNode()
    let shapePath = UIBezierPath(roundedRect: CGRect(x: self.frame.maxX - 66, y: self.frame.maxY - 120, width: 50, height: 45), cornerRadius: 20).cgPath

    btnTop.path = shapePath
    btnTop.physicsBody = SKPhysicsBody(polygonFrom: shapePath)
    btnTop.physicsBody?.isDynamic = false
    btnTop.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
//    btnTop.strokeColor = UIColor(.black.opacity(0))
    btnTop.lineWidth = 2
    addChild(btnTop)
  }

//  private func createBall() {
//  public func createBall() {
//    // Create shape node to use during mouse interaction
//    let maskShapeTexture = SKTexture(imageNamed: "circle")
////    let texture = SKTexture(imageNamed: "tyre")
//    let texture = SKTexture(imageNamed: "tyreRedTEST")
//    let pictureToMask = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 50))
//    let mask = SKSpriteNode(texture: maskShapeTexture) //make a circular mask
//    let ball = SKCropNode()
//
//    ball.maskNode = mask
//    ball.addChild(pictureToMask)
//    ball.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
//    ball.zPosition = 1
//    ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
//    ball.physicsBody?.allowsRotation = true
//    ball.physicsBody?.linearDamping = 0.5
//    ball.physicsBody?.isDynamic = true
//    ball.physicsBody?.categoryBitMask = CollisionType.object.rawValue
//    ball.physicsBody?.collisionBitMask = CollisionType.wall.rawValue
//
//    self.ball = ball
//    self.addChild(self.ball)
//  }

  public func createTyre(tyreType: String) {
    // Create shape node to use during mouse interaction
    let maskShapeTexture = SKTexture(imageNamed: "circle")
//    let texture = SKTexture(imageNamed: "tyre")
    let texture = SKTexture(imageNamed: tyreType)
    let pictureToMask = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 50))
    let mask = SKSpriteNode(texture: maskShapeTexture) //make a circular mask
    let ball = SKCropNode()

    ball.maskNode = mask
    ball.addChild(pictureToMask)

    let randomCGFloat = CGFloat.random(in: 1...100)

    ball.position = CGPoint(x: self.frame.midX + randomCGFloat, y: self.frame.midY + randomCGFloat)
    ball.zPosition = 1
    ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
    ball.physicsBody?.allowsRotation = true
    ball.physicsBody?.linearDamping = 0.5
    ball.physicsBody?.isDynamic = true
    ball.physicsBody?.categoryBitMask = CollisionType.object.rawValue
    ball.physicsBody?.collisionBitMask = CollisionType.wall.rawValue

    self.ball = ball
    self.addChild(self.ball)
  }

  override func update(_ currentTime: TimeInterval) {
    //    print("update acc scene")
    if let accelerometerData = motionManager.accelerometerData {
      physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 7, dy: accelerometerData.acceleration.y * 7)
    }
// unlimited balls spawn
//    if timer == nil {
//      createBall()
//    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let location = touch.location(in: self)
    let maskShapeTexture = SKTexture(imageNamed: "circle")
//    let texture = SKTexture(imageNamed: "tyre")
    let texture = SKTexture(imageNamed: "tyreRed")
    let pictureToMask = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 50))
    let mask = SKSpriteNode(texture: maskShapeTexture) //make a circular mask
    let ball = SKCropNode()

    ball.maskNode = mask
    ball.addChild(pictureToMask)
    ball.position = location
    ball.zPosition = 1
    ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
    ball.physicsBody?.allowsRotation = true
    ball.physicsBody?.linearDamping = 0.5
    ball.physicsBody?.isDynamic = true

    addChild(ball)

//    createBall()
  }
}
// WIP


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
  @AppStorage("userBackground") var userBackground: Color = .red
  @AppStorage("userImage") var userImage = "car1"

  @AppStorage("showingSessionTimerWarning") var showingSessionTimerWarning = false

  @State var timer: Timer? = nil
  @State private var showingStore = false
  @State var sessionRunning = false



  // WIP
  var scene: SKScene {
//    //      let scene = GameScene(sceneSize: CGSize(width: 390, height: 700))
//
//    //    let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: 800))
    let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
//
//    let scene = GameScene()
    scene.scaleMode = .resizeFill
    return scene
  }

//  let scene: GameScene = {
//      let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: 800))
//    scene.scaleMode = .resizeFill
//
//      return scene
//  }()

//  let scene: GameScene = {
//      let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: 800))
//    scene.scaleMode = .resizeFill
//
//      return scene
//  }()
  // WIP

  var body: some View {
    ZStack {
      // WIP
      SpriteView(scene: scene)
      //        .frame(maxWidth: .infinity, maxHeight: .infinity)
      //        .frame(width: screenWidth, height: screenHeight)

      //                  .frame(width: 390, height: 700)
        .ignoresSafeArea()
      // WIP

      VStack(spacing: 10) {
        // TOP NAV SECTION - total stars, total session time and shop
        HStack {
          HStack {
            starIcon().padding(.leading, 10)
            Text("\(userStars)")
              .foregroundColor(Color("Text"))
              .padding(.trailing, 10)
          }.font(.system(size: 20))
            .btnTextPanelFormat()
          HStack {
            Text("\(userTotalSessionTime)")
              .padding(.leading, 10)
            Image(systemName: "clock")
              .foregroundColor(Color("Text"))
              .padding(.trailing, 10)
          }.font(.system(size: 20))
            .btnTextPanelFormat()
          Spacer()
          Button {
//            scene.createBall() // works but wip
            showingStore.toggle()
          } label: {
            Image(systemName: "cart")
              .foregroundColor(.white)
              .font(.system(size: 20))
          }.btnStoreFormat()
            .fullScreenCover(isPresented: $showingStore) {
              SheetStoreView(appState: $appState)
            }
        }
        // END OF TOP NAV SECTION
        Spacer()
        sessionTimerSection(appState: $appState)
          .onChange(of: scenePhase, initial: true) { oldPhase, newPhase in
            if newPhase == .active {
              print("Active")
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
          .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
          }
      }
      .padding()
      .padding(.bottom, 3)

      if showingSessionTimerWarning {
        SessionTimerDialog(isActive: $showingSessionTimerWarning, appState: $appState) {
          showingSessionTimerWarning = false
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
