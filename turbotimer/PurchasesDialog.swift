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
        .opacity(0.2)
        .onTapGesture {
          close()
        }

      VStack {
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
                .foregroundColor(.white)
                .padding()
            }
          }
        }
        .padding()
        .background(.purple.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 20))
//        .frame(height: 150)

        VStack {}.padding()

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
                .foregroundColor(.white)
                .padding()
            }
          }
        }
        .padding()
        .background(.purple.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 20))
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding()
      .padding(.top, 20)
      .padding(.bottom, 10)
      .background(.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .overlay(alignment: .topTrailing) {
        Button {
          close()
        } label: {
          Image(systemName: "xmark")
            .font(.title2)
            .fontWeight(.medium)
        }
        .tint(.black)
        .padding()
      }
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
