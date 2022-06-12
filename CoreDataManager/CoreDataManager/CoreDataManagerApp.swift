//
//  CoreDataManagerApp.swift
//  CoreDataManager
//
//  Created by mehmet karanlık on 12.06.2022.
//

import SwiftUI

@main
struct CoreDataManagerApp: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView()
              .environment(\.managedObjectContext, CoreDataManager.shared.container.viewContext)
        }

    }
}
