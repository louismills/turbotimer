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
      .frame(minWidth: 80, minHeight: 45)
      .background(color)
      .foregroundColor(.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}

struct BtnTextPanelFormat: ViewModifier {
  @AppStorage("userBackground") var userBackground: Color = .gray

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
    }
    .btnTextFormat()
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

extension Button {
  func appBtn(color: Color = .red) -> some View {
    modifier(AppBtn(color: color))
  }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

enum CollisionType: UInt32 {
  case object = 1
  case wall = 2
}

class GameScene: SKScene {
  private var motionManager: CMMotionManager!
  private var ball: SKCropNode!

  @AppStorage("userBackground") var userBackground: Color = .gray

  //  init(sceneSize: CGSize) {
  //    super.init(size: sceneSize)
  //  }
  //
  //  required init?(coder aDecoder: NSCoder) {
  //    fatalError("init(coder:) has not been implemented")
  //  }

  override func sceneDidLoad() {
    setUpBounds()
    setUpBox()
    setUpBtnTopLeft()
    setUpBtnTopMiddle()
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
    let screen = UIScreen.main.bounds
    let screenHeight = screen.size.height
    let btnTop = SKShapeNode()
    let shapePath = UIBezierPath(roundedRect: CGRect(x: self.frame.origin.x + 16, y: screenHeight - 93, width: 80, height: 30), cornerRadius: 20).cgPath
    btnTop.path = shapePath
    btnTop.physicsBody = SKPhysicsBody(polygonFrom: shapePath)
    btnTop.physicsBody?.isDynamic = false
    btnTop.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
    btnTop.strokeColor = UIColor(.black.opacity(0))
    btnTop.lineWidth = 2
    addChild(btnTop)
  }

  private func setUpBtnTopMiddle() {
    let screen = UIScreen.main.bounds
    let screenHeight = screen.size.height
    let btnTop = SKShapeNode()
    let shapePath = UIBezierPath(roundedRect: CGRect(x: self.frame.origin.x + 104, y: screenHeight - 93, width: 80, height: 30), cornerRadius: 20).cgPath
    btnTop.path = shapePath
    btnTop.physicsBody = SKPhysicsBody(polygonFrom: shapePath)
    btnTop.physicsBody?.isDynamic = false
    btnTop.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
    btnTop.strokeColor = UIColor(.black.opacity(0))
    btnTop.lineWidth = 2
    addChild(btnTop)
  }

  private func setUpBtnTopRight() {
    let btnTop = SKShapeNode()
    let shapePath = UIBezierPath(roundedRect: CGRect(x: self.frame.maxX - 66, y: self.frame.maxY - 100, width: 50, height: 45), cornerRadius: 20).cgPath
    btnTop.path = shapePath
    btnTop.physicsBody = SKPhysicsBody(polygonFrom: shapePath)
    btnTop.physicsBody?.isDynamic = false
    btnTop.physicsBody?.categoryBitMask = CollisionType.wall.rawValue
    btnTop.strokeColor = UIColor(.black.opacity(0))
    btnTop.lineWidth = 2
    addChild(btnTop)
  }

  func createTyre(tyreType: String) {
    let maskShapeTexture = SKTexture(imageNamed: "circle")
    let texture = SKTexture(imageNamed: tyreType)
    let pictureToMask = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 50))
    let mask = SKSpriteNode(texture: maskShapeTexture)
    let tyre = SKCropNode()
    tyre.maskNode = mask
    tyre.addChild(pictureToMask)
    let randomCGFloat = CGFloat.random(in: 1...100)
    tyre.position = CGPoint(x: self.frame.midX + randomCGFloat, y: self.frame.midY + randomCGFloat)
    tyre.zPosition = 1
    tyre.physicsBody = SKPhysicsBody(circleOfRadius: 25)
    tyre.physicsBody?.allowsRotation = true
    tyre.physicsBody?.linearDamping = 0.5
    tyre.physicsBody?.isDynamic = true
    addChild(tyre)
  }

  override func update(_ currentTime: TimeInterval) {
    if let accelerometerData = motionManager.accelerometerData {
      physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 7, dy: accelerometerData.acceleration.y * 7)
    }
  }

//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    guard let touch = touches.first else { return }
//    let location = touch.location(in: self)
//    let maskShapeTexture = SKTexture(imageNamed: "circle")
//    let texture = SKTexture(imageNamed: "tyreRed")
//    let pictureToMask = SKSpriteNode(texture: texture, size: CGSize(width: 50, height: 50))
//    let mask = SKSpriteNode(texture: maskShapeTexture)
//    let ball = SKCropNode()
//    ball.maskNode = mask
//    ball.addChild(pictureToMask)
//    ball.position = location
//    ball.zPosition = 1
//    ball.physicsBody = SKPhysicsBody(circleOfRadius: 25)
//    ball.physicsBody?.allowsRotation = true
//    ball.physicsBody?.linearDamping = 0.5
//    ball.physicsBody?.isDynamic = true
//
//    addChild(ball)
//  }
}
// WIP


struct ContentView: View {
  @Environment(\.scenePhase) var scenePhase
  @Environment(\.dismiss) var dismiss

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTotalSessionTime") var userTotalSessionTime = 0
  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userDestination") var userDestination = ""
  @AppStorage("userBackground") var userBackground: Color = .gray
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

  var body: some View {
    ZStack {
      // WIP
      SpriteView(scene: gameScene)
      //              .frame(maxWidth: .infinity, maxHeight: .infinity)
      //              .frame(width: screenWidth, height: screenHeight)
        .frame(maxHeight: UIScreen.main.bounds.size.height)

      //                  .frame(width: 390, height: 700)
      //        .ignoresSafeArea()
      // WIP

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
//          .frame(width: 80, height: 30)
          .background(Color("BackgroundPanel"))
          .overlay(
            RoundedRectangle(cornerRadius: 16)
              .stroke(Color(userBackground), lineWidth: 2)
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
              .stroke(Color(userBackground), lineWidth: 2)
          )
          .clipShape(RoundedRectangle(cornerRadius: 16))
          Spacer()
          Button {
            showingStore.toggle()
          } label: {
            Image(systemName: "cart")
              .foregroundColor(.white)
              .font(.system(size: 20))
          }.btnStoreFormat()
            .fullScreenCover(isPresented: $showingStore) {
              StoreView(appState: $appState)
            }
        }
        // END OF TOP NAV SECTION
        Spacer()
        sessionTimerSection(appState: $appState, scene: gameScene)
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
      .padding(.bottom, 53)
      .padding(.top, 55)
      .padding(.horizontal, 15)

      if showingSessionTimerWarning {
        SessionTimerDialog(isActive: $showingSessionTimerWarning, appState: $appState) {
          showingSessionTimerWarning = false
        }
      }
    }.ignoresSafeArea()
  }
}

#Preview {
  ContentView()
}
