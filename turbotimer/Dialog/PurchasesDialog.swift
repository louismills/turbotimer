//
//  PurchasesDialog.swift
//  astrotimer
//
//  Created by Louis Mills on 02/02/2024.
//

import Foundation
import SwiftUI
import StoreKit

// wip
struct CustomProductStyle: ProductViewStyle {
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
      VStack {
        HStack {
          if product.id == "com.turbotimer.trophies.small" {
            Text("50")
              .foregroundColor(Color("Text"))
          } else if product.id == "com.turbotimer.trophies.large" {
            Text("225")
              .foregroundColor(Color("Text"))
          }
          //          Text(verbatim: product.displayName)
          //            .foregroundColor(Color("Text"))
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
              .foregroundColor(.green)

            Text(verbatim: "Buy for \(product.displayPrice)")
              .lineLimit(2)
              .font(.system(size: 20, weight: .bold))
              .foregroundColor(Color("Text"))
              .padding()
          }
        }
      }
      .padding()
      .background(Color(UIColor.lightGray).opacity(0.4))
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .buttonStyle(.plain)



    default:
      Text("Something goes wrong...")
    }
  }
}
// wip

struct PurchasesDialog: View {
  @Binding var isActive: Bool

  @AppStorage("userStars") var userStars = 0

//  let message1: String
//  let buttonTitle1: String
//  let message2: String
//  let buttonTitle2: String
  let action: () -> ()
  @State private var offset: CGFloat = 1000

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
