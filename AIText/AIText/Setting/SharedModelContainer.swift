//
//  sharedModelContainer.swift
//  AIText
//
//  Created by will Suo on 2025/3/24.
//



import Foundation
import SwiftData

let sharedModelContainer: ModelContainer = {
    let schema = Schema([
        QuickItem.self,
    ])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false, cloudKitDatabase: .none)
    
    do {
        let result = try ModelContainer(for: schema, configurations: [modelConfiguration])
        return result
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
