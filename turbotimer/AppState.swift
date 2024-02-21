//
//  AppState.swift
//  turbotimer
//
//  Created by Louis Mills on 10/01/2024.
//

import Foundation
import SwiftUI

enum Mode: String, Equatable {
  case rest = "Rest time"
  case session = "Session time"
}

struct background {
  var background: Int
  var bought: Bool
  var cost: Int
  var colour: Color
}

struct UserBackgrounds: Identifiable, Codable{
  let id : Int
  var bought : Bool
  var cost : Int

  init(id: Int, bought: Bool, cost: Int) {
    self.id = id
    self.bought = bought
    self.cost = cost
  }
}

struct consumable {
  var consumable: Int
  var isActive: Bool
  var cost: Int
  var inventory: Int
  var multiplier: Double
  var duration: Int
  var image: String
}

struct UserConsumables: Identifiable, Codable{
  let id : Int
  var isActive : Bool
  var cost : Int
  var inventory: Int

  init(id: Int, isActive: Bool, cost: Int, inventory: Int) {
    self.id = id
    self.isActive = isActive
    self.cost = cost
    self.inventory = inventory
  }
}

struct shop {
  var shop: Int
  var bought: Bool
  var cost: Int
  var multiplier: Double
  var image: String
}

struct UserShops: Identifiable, Codable{
  let id : Int
  var bought : Bool
  var cost : Int

  init(id: Int, bought: Bool, cost: Int) {
    self.id = id
    self.bought = bought
    self.cost = cost
  }
}

extension Array: RawRepresentable where Element: Codable {
  public init?(rawValue: String) {
    guard let data = rawValue.data(using: .utf8) else {
      return nil
    }
    do {
      let result = try JSONDecoder().decode([Element].self, from: data)
      //            print("Init from result: \(result)")
      self = result
    } catch {
      //            print("Error: \(error)")
      return nil
    }
  }

  public var rawValue: String {
    guard let data = try? JSONEncoder().encode(self),
          let result = String(data: data, encoding: .utf8)
    else {
      return "[]"
    }
    //        print("Returning \(result)")
    return result
  }
}

extension Color: RawRepresentable {
  public init?(rawValue: Int) {
    let red =   Double((rawValue & 0xFF0000) >> 16) / 0xFF
    let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
    let blue =  Double(rawValue & 0x0000FF) / 0xFF
    self = Color(red: red, green: green, blue: blue)
  }

  public var rawValue: Int {
    guard let coreImageColor = coreImageColor else {
      return 0
    }
    let red = Int(coreImageColor.red * 255 + 0.5)
    let green = Int(coreImageColor.green * 255 + 0.5)
    let blue = Int(coreImageColor.blue * 255 + 0.5)
    return (red << 16) | (green << 8) | blue
  }

  private var coreImageColor: CIColor? {
    return CIColor(color: PlatformColor(self))
  }
}

#if os(iOS)
typealias PlatformColor = UIColor
extension Color {
  init(platformColor: PlatformColor) {
    self.init(uiColor: platformColor)
  }
}
//#elseif os(macOS)
//typealias PlatformColor = NSColor
//extension Color {
//  init(platformColor: PlatformColor) {
//    self.init(nsColor: platformColor)
//  }
//}
#endif

struct AppState {
  var sessionStars: Float = 0.0

  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTotalSessionTime") var userTotalSessionTime = 0
  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userMultiplier") var userMultiplier = 0.0
  @AppStorage("userImage") var userImage = "car1"

  @AppStorage("challengeSelectedReward") var challengeSelectedReward = 0
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0

  var shops = [shop(shop: 0, bought: true, cost: 0, multiplier: 0.0, image: "car1"),
               shop(shop: 1, bought: false, cost: 1, multiplier: 0.03, image: "car2"),
               shop(shop: 2, bought: false, cost: 4, multiplier: 0.06, image: "car3"),
               shop(shop: 3, bought: false, cost: 10, multiplier: 0.1, image: "car4"),
  ]

  var consumables = [consumable(consumable: 0, isActive: false, cost: 15, inventory: 0, multiplier: 0.3, duration: 60, image: "fuelcan"),
                     consumable(consumable: 1, isActive: false, cost: 25, inventory: 0, multiplier: 0.75, duration: 60, image: "car1"),
  ]

  var backgrounds = [background(background: 0, bought: true, cost: 10, colour: .gray),
                     background(background: 1, bought: false, cost: 10, colour: .yellow),
                     background(background: 2, bought: false, cost: 10, colour: .red),
                     background(background: 3, bought: false, cost: 10, colour: .purple),
                     background(background: 4, bought: false, cost: 10, colour: .blue),
                     background(background: 5, bought: false, cost: 10, colour: .green),
  ]

  var workMinutes: Int = 5 {
    didSet {
      if mode == .session {
        currentTime = workMinutes * 60
      }
    }
  }

  var restMinutes: Int = 1 {
    didSet {
      if mode == .rest {
        currentTime = restMinutes * 60
      }
    }
  }

  var mode = Mode.session

  var currentTime: Int

  let scene: GameScene

//  init(playSound: @escaping () -> Void) {
//    self.currentTime = workMinutes * 60
//  }

//  init() {
//    self.currentTime = workMinutes * 60
//    self.scene = scene
//  }

  init(scene: GameScene) {
    self.currentTime = workMinutes * 60
    self.scene = scene
  }

  var currentTimeDisplay: String {
    let hours = ((currentTime / 60) / 60)
    let minutes = (currentTime / 60) - (((currentTime / 60) / 60) * 60)
    let secondsLeft = currentTime % 60
    return "\(hours):\(minutes < 10 ? "0" : "")\(minutes):\(secondsLeft < 10 ? "0" : "")\(secondsLeft)"
  }

  var currentTimeCountdown: Double {
    let time = Double(currentTime)
    return time
  }

  mutating func next() {
    // Reward user with stars per minute
    if currentTime % 60 == 0 {
      //      print("WorkMinutes: \(workMinutes)")
      //      print("challengeSelectedReward: \(challengeSelectedReward)")
      //      print("Reward per minute: \(Float(challengeSelectedReward) / Float(workMinutes))")
      //      print("Multiplier: \(userMultiplier)")
      //      print("Reward Per Minute x Multiplier: \((Float(challengeSelectedReward) / Float(workMinutes)) + (Float(challengeSelectedReward) / Float(workMinutes)) * Float(userMultiplier))")

      let rewardPerMinute = Float(challengeSelectedReward) / Float(workMinutes)
      let rewardPerMinuteMultiplied = rewardPerMinute + (rewardPerMinute * Float(userMultiplier))

      sessionStars += 1 * rewardPerMinuteMultiplied
    }

    if currentTime > 0 {
      currentTime -= 1
      return
    }

    if currentTime == 0 {
      userStars += Int(sessionStars)
      userTotalSessionTime += workMinutes
      sessionStars = 0
      // Create new tyre
      print("created new tyre")
      scene.createTyre(tyreType: "tyreYellow")
    }

    switch(mode) {
    case .session:
      currentTime = self.restMinutes * 60
      mode = .rest
      break
    case .rest:
      currentTime = self.workMinutes * 60
      mode = .session
    }
  }

  mutating func reset() {
    restMinutes = 1
    workMinutes = challengeSelectedDuration
    sessionStars = 0
    mode = .session
  }
}
