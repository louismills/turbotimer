//
//  GameScene.swift
//  turbotimer
//
//  Created by Louis Mills on 27/02/2024.
//

import SpriteKit
import GameplayKit
import CoreMotion

import SwiftUI
import AVFoundation

enum CollisionType: UInt32 {
  case object = 1
  case wall = 2
}

class GameScene: SKScene {
  private var motionManager: CMMotionManager!
  private var ball: SKCropNode!

  @AppStorage("userTheme") var userTheme: Color = .gray
  @AppStorage("userTyres") var userTyres = DefaultSettings.tyresDefault

  override func sceneDidLoad() {
    setUpBounds()
    setUpBox()
    setUpBtnTopLeft()
    setUpBtnTopMiddle()
    setUpBtnTopRight()

    // Load tyres
    for tyre in userTyres {
      for _ in 0..<tyre.inventory {
        createTyre(tyreType: tyre.type)
      }
    }
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
