//
//  PurchaseManager.swift
//  turbotimer
//
//  Created by Louis Mills on 09/03/2024.
//

import SwiftUI
import StoreKit

@MainActor final class PurchaseManager: ObservableObject {
  @Published private(set) var products: [Product] = []
  private var updates: Task<Void, Never>?

  init() {
    updates = Task {
      for await update in StoreKit.Transaction.updates {
        if let transaction = try? update.payloadValue {
          await transaction.finish()
        }
      }
    }
  }

  deinit {
    updates?.cancel()
  }

  func fetchProducts() async {
    do {
      products = try await Product.products(
        for: [
          "com.turbotimer.trophies.small", "com.turbotimer.trophies.large"
        ]
      )
    } catch {
      products = []
    }
  }

  @Published private(set) var activeTransactions: Set<StoreKit.Transaction> = []

  @AppStorage("userStars") var userStars = 0

  func purchase(_ product: Product) async throws {
    let result = try await product.purchase()
    switch result {
    case .success(let verificationResult):
      if let transaction = try? verificationResult.payloadValue {
        activeTransactions.insert(transaction)
        await transaction.finish()
        if product.id == "com.turbotimer.trophies.small" {
          userStars += 50
        }
        if product.id == "com.turbotimer.trophies.large" {
          userStars += 225
        }
      }
    case .userCancelled:
      break
    case .pending:
      break
    @unknown default:
      break
    }
  }
}
