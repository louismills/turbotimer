//
//  PurchasesDialog.swift
//  astrotimer
//
//  Created by Louis Mills on 02/02/2024.
//

import Foundation
import SwiftUI
import StoreKit

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let points = [
            center.rotate(angle: .pi / 2.5),
            center.rotate(angle: .pi * 7 / 10),
            center.rotate(angle: .pi * 3 / 5),
            center.rotate(angle: .pi * 11 / 10),
            center.rotate(angle: .pi / 5),
        ]

        var path = Path()
        path.move(to: points[0])
        for point in points.dropFirst() {
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }
}

extension CGPoint {
    func rotate(angle: CGFloat) -> CGPoint {
        let x = self.x * cos(angle) - self.y * sin(angle)
        let y = self.x * sin(angle) + self.y * cos(angle)
        return CGPoint(x: x, y: y)
    }
}

struct CustomProductStyle: ProductViewStyle {
  @State private var offset: CGFloat = 1000

  @State private var scale = 1.0 // wip
  @State private var animationAmount = 1.0 // /wip


  @AppStorage("userTheme") var userTheme = "themeRed"

  func makeBody(configuration: Configuration) -> some View {
    switch configuration.state {
    case .loading:
      
      VStack { // Container for redacted items
        //  Placeholder for Product Name
        HStack {
          Capsule()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 100, height: 50)
            .redacted(reason: .placeholder)
          
          Capsule()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 100, height: 50)
            .redacted(reason: .placeholder)
        }
        // Placeholder for Price Area
        Capsule()
          .fill(Color.gray.opacity(0.3))
          .frame(height: 40)
          .redacted(reason: .placeholder)
      }
      .padding()
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .buttonStyle(.plain)
      
    case .success(let product):
      VStack (spacing: 15) {
        HStack {
          if product.id == "com.turbotimer.trophies.small" {
            Text("50")
            //              .foregroundColor(Color("Text"))
              .foregroundColor(Color(.white))
//              .foregroundColor(Color(userTheme))
          } else if product.id == "com.turbotimer.trophies.large" {
            Text("225")
            //              .foregroundColor(Color("Text"))
              .foregroundColor(Color(.white))
//              .foregroundColor(Color(userTheme))
          }

            Image(systemName: "star.fill")
              .foregroundColor(.yellow)

        }
        .font(.system(size: 50))
        .fontWeight(.bold)

        Button {
          configuration.purchase()
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(Color("Text"))
//              .foregroundColor(Color(userTheme))

            Text(verbatim: "Buy for \(product.displayPrice)")
              .lineLimit(2)
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(Color("Background"))
              .padding()
          }
        }
        .scaleEffect(product.id == "com.turbotimer.trophies.large" ? animationAmount : 1)
        .animation(
          .easeInOut(duration: 0.5)
                .repeatForever(autoreverses: true),
            value: animationAmount
        )
      }
      .padding()
//      .background(Color(UIColor.lightGray).opacity(0.4))
      .background(Color(.gray).opacity(0.4))
//      .background(Color(userTheme).opacity(0.6))
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .buttonStyle(.plain)
      .offset(x: 0, y: offset)
//      .onAppear {
//        withAnimation(.spring()) {
//          offset = 0
//        }
//      }
      .onAppear {
        animationAmount = 1.05
        withAnimation(.spring()) {
                  offset = 0
                }
      }

    default:
      Text("Something goes wrong...")
    }
  }
}

struct PurchasesDialog: View {
  @Binding var isActive: Bool
  
  @AppStorage("userStars") var userStars = 0
  @AppStorage("showingPurchases") var showingPurchases = false

  @State private var offset: CGFloat = 1000

  let action: () -> ()

  var body: some View {
    ZStack {
      Color(.black)
        .opacity(0.3)
      
      VStack(spacing: 20) {
        VStack {
          VStack(spacing: 20) {
            ForEach(["com.turbotimer.trophies.small", "com.turbotimer.trophies.large"], id: \.self) { id in
              ProductView(id: id)
                .productViewStyle(CustomProductStyle())
                .onInAppPurchaseStart { product in
                  print("User has started buying \(product.id)")
                }
                .onInAppPurchaseCompletion { product, result in
                  if case .success(.success(let transaction)) = result {
                    print("Purchased successfully: \(transaction.signedDate)")
                    print("Apply trophies to user total")
                    if product.id == "com.turbotimer.trophies.small" {
                      userStars += 50
                    }
                    if product.id == "com.turbotimer.trophies.large" {
                      userStars += 225
                    }
                    
                  } else {
                    print("Something else happened")
                  }
                }
            }
          }
        }
        Button {
          close()
          showingPurchases = false
        } label: {
          ZStack {
            RoundedRectangle(cornerRadius: 20)
              .foregroundColor(.gray)
            
            Text("Cancel")
              .textCase(.uppercase)
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(.white)
              .padding(10)
          }
        }
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .background(Color("BackgroundPanel"))
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .shadow(radius: 20)
      .padding(20)
      .offset(x: 0, y: offset)
      .onAppear {
        withAnimation(.spring()) {
          offset = 0
        }
      }
    }
    .ignoresSafeArea()
  }
  
  func close() {
    withAnimation(.spring()) {
      offset = 1000
      isActive = false
    }
  }
}

struct PurchasesDialog_Previews: PreviewProvider {
  static var previews: some View {
    PurchasesDialog(isActive: .constant(true), action: {})
  }
}
