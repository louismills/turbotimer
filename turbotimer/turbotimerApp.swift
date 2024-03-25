//
//  astrotimerApp.swift
//  astrotimer
//
//  Created by Louis Mills on 09/01/2024.
//

import SwiftUI

@main
struct turbotimerApp: App {
  @StateObject private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(purchaseManager)
        }
    }
}
