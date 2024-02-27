//
//  AppState.swift
//  turbotimer
//
//  Created by Louis Mills on 10/01/2024.
//

import Foundation
import SwiftUI

enum DefaultSettings {
  static let consumablesDefault = [
    UserConsumables(id: 0, isActive: false, cost: 0, inventory: 0, multiplier: 0.30, duration: 60, image: "fuelcan"),
    UserConsumables(id: 1, isActive: false, cost: 0, inventory: 0, multiplier: 0.75, duration: 60, image: "crashhelmet")
  ]

  static let themesDefault = [
    UserThemes(id: 0, bought: true, cost: 0, colour: "gray"),
    UserThemes(id: 1, bought: false, cost: 0, colour: "yellow"),
    UserThemes(id: 2, bought: false, cost: 10, colour: "red"),
    UserThemes(id: 3, bought: false, cost: 10, colour: "purple"),
    UserThemes(id: 4, bought: false, cost: 10, colour: "blue"),
    UserThemes(id: 5, bought: false, cost: 10, colour: "green"),
  ]
}

enum Mode: String, Equatable {
  case rest = "Rest time"
  case session = "Session time"
}

struct UserThemes: Identifiable, Codable {
  let id : Int
  var bought : Bool
  var cost : Int
  var colour: String

  init(id: Int, bought: Bool, cost: Int, colour: String) {
    self.id = id
    self.bought = bought
    self.cost = cost
    self.colour = colour
  }
}

struct UserConsumables: Identifiable, Codable {
  let id : Int
  var isActive : Bool
  var cost : Int
  var inventory: Int
  var multiplier: Double
  var duration: Int
  var image: String

  init(id: Int, isActive: Bool, cost: Int, inventory: Int, multiplier: Double, duration: Int, image: String) {
    self.id = id
    self.isActive = isActive
    self.cost = cost
    self.inventory = inventory
    self.multiplier = multiplier
    self.duration = duration
    self.image = image
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
#endif

struct AppState {
  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTotalSessionTime") var userTotalSessionTime = 0
  @AppStorage("userSessionTime") var userSessionTime = 0
  @AppStorage("userMultiplier") var userMultiplier = 0.0
  @AppStorage("userImage") var userImage = "car1"

  @AppStorage("challengeSelectedReward") var challengeSelectedReward = 0
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedRewardStars") var challengeSelectedRewardStars = 0

  @AppStorage("sessionRunning") var sessionRunning = false

  @AppStorage("userConsumables") var userConsumables = DefaultSettings.consumablesDefault
  @AppStorage("userThemes") var userThemes = DefaultSettings.themesDefault

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

  init() {
    self.currentTime = workMinutes * 60
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
    if currentTime > 0 {
      currentTime -= 1
      return
    }

    if currentTime == 0 {
      userStars += challengeSelectedRewardStars
      userTotalSessionTime += workMinutes
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
    mode = .session
  }
}
