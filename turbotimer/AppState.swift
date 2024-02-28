//
//  AppState.swift
//  turbotimer
//
//  Created by Louis Mills on 10/01/2024.
//

//import Foundation
import SwiftUI

enum DefaultSettings {
  static let consumablesDefault = [
    Consumables(id: 0, isActive: false, cost: 15, inventory: 0, multiplier: 0.30, duration: 60, image: "fuelcan"),
    Consumables(id: 1, isActive: false, cost: 35, inventory: 0, multiplier: 0.75, duration: 60, image: "crashhelmet")
  ]

  static let themesDefault = [
    Themes(id: 0, bought: true, cost: 0, colour: "themeGray"),
    Themes(id: 1, bought: false, cost: 10, colour: "themeYellow"),
    Themes(id: 2, bought: false, cost: 10, colour: "themeRed"),
    Themes(id: 3, bought: false, cost: 10, colour: "themePurple"),
    Themes(id: 4, bought: false, cost: 10, colour: "themeBlue"),
    Themes(id: 5, bought: false, cost: 10, colour: "themeGreen"),
  ]

  static let challengesDefault = [
    Challenges(id: 0, workMinutes: 5, rewardTyresType: "tyreRed", rewardTyres: 1, rewardStars: 1),
    Challenges(id: 1, workMinutes: 10, rewardTyresType: "tyreYellow", rewardTyres: 1,rewardStars: 2),
    Challenges(id: 2, workMinutes: 15, rewardTyresType: "tyreWhite", rewardTyres: 1,rewardStars: 3),
    Challenges(id: 3, workMinutes: 20, rewardTyresType: "tyreGreen", rewardTyres: 1,rewardStars: 5),
    Challenges(id: 4, workMinutes: 25, rewardTyresType: "tyreBlue", rewardTyres: 1,rewardStars: 7),
    Challenges(id: 5, workMinutes: 30, rewardTyresType: "tyreRed", rewardTyres: 2,rewardStars: 11),
    Challenges(id: 6, workMinutes: 45, rewardTyresType: "tyreYellow", rewardTyres: 2,rewardStars: 15),
    Challenges(id: 7, workMinutes: 60, rewardTyresType: "tyreWhite", rewardTyres: 2,rewardStars: 22),
    Challenges(id: 8, workMinutes: 90, rewardTyresType: "tyreGreen", rewardTyres: 2,rewardStars: 30),
    Challenges(id: 9, workMinutes: 120, rewardTyresType: "tyreBlue", rewardTyres: 2,rewardStars: 38)
  ]

  static let tyresDefault = [
    Tyres(id: 0, type: "tyreRed", inventory: 0),
    Tyres(id: 1, type: "tyreYellow", inventory: 0),
    Tyres(id: 2, type: "tyreWhite", inventory: 0),
    Tyres(id: 3, type: "tyreGreen", inventory: 0),
    Tyres(id: 4, type: "tyreBlue", inventory: 0)
  ]
}

enum Mode: String, Equatable {
  case rest = "Rest time"
  case session = "Session time"
}

struct Tyres: Identifiable, Codable {
  let id : Int
  var type: String
  var inventory: Int

  init(id: Int, type: String, inventory: Int) {
    self.id = id
    self.type = type
    self.inventory = inventory
  }
}

struct Themes: Identifiable, Codable {
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

struct Consumables: Identifiable, Codable {
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

struct Challenges: Identifiable, Codable {
  let id : Int
  var workMinutes: Int
  var rewardTyresType: String
  var rewardTyres: Int
  var rewardStars: Int

  init(id: Int, workMinutes: Int, rewardTyresType: String, rewardTyres: Int, rewardStars: Int) {
    self.id = id
    self.workMinutes = workMinutes
    self.rewardTyresType = rewardTyresType
    self.rewardTyres = rewardTyres
    self.rewardStars = rewardStars
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

struct AppState {
  @AppStorage("userStars") var userStars = 0
  @AppStorage("userTotalSessionTime") var userTotalSessionTime = 0
  @AppStorage("challengeSelectedDuration") var challengeSelectedDuration = 0
  @AppStorage("challengeSelectedRewardStars") var challengeSelectedRewardStars = 0

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

    if currentTime == 0 && mode == .session {
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
