//
//  PurchasesDialog.swift
//  astrotimer
//
//  Created by Louis Mills on 02/02/2024.
//

import Foundation
import SwiftUI

struct PurchasesDialog: View {
  @Binding var isActive: Bool

  //  let title: String
  let message1: String
  let buttonTitle1: String
  let message2: String
  let buttonTitle2: String
  let action: () -> ()
  @State private var offset: CGFloat = 1000

  var body: some View {
    ZStack {
      Color(.black)
        .opacity(0.3)

      VStack(spacing: 20) {
        VStack {
          HStack {
            Text(message1)
            Image(systemName: "star.fill").foregroundColor(.yellow)
          }
          .font(.system(size: 50))
          .fontWeight(.bold)

          Button {
            action()
            close()
          } label: {
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.green)

              Text(buttonTitle1)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("Text"))
                .padding()
            }
          }
        }
        .padding()
        .background(Color(UIColor.lightGray).opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 20))

        VStack {
          HStack {
            Text(message2)
            Image(systemName: "star.fill").foregroundColor(.yellow)
          }
          .font(.system(size: 50))
          .fontWeight(.bold)

          Button {
            action()
            close()
          } label: {
            ZStack {
              RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.green)

              Text(buttonTitle2)
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
      .padding(.top, 20)
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
    PurchasesDialog(isActive: .constant(true), message1: "50", buttonTitle1: "Buy for 0.99", message2: "225", buttonTitle2: "Buy for 2.99" + "\n33% Discount", action: {})
  }
}
