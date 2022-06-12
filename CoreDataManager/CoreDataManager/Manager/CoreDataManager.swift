//
//  CoreDataManager.swift
//  CoreDataManager
//
//  Created by mehmet karanlık on 12.06.2022.
//

import Foundation
import SwiftUI
import UIKit
import CoreData

struct CoreDataManager : ICoreDataManager {

   // MARK:  properties
   static let shared = CoreDataManager()


   var container : NSPersistentContainer {
      NSPersistentContainer(name: "CoreDataManager")
   }

   func coreSave() throws {
      do {
         try self.container.viewContext.save()
      } catch let e {
         fatalError(e.localizedDescription)
      }
   }


   private init() {
      container.loadPersistentStores { persistenStores, error in
         if let error = error {
            print("Error while loading persistenStore : \(error)")
            return
         }
      }
      container.viewContext.automaticallyMergesChangesFromParent = true

   }
   // save
   func saveSingleItem<T : NSManagedObject>(object : T) {
      let object = object
      container.viewContext.insert(object)
      try? coreSave()

   }

   func saveMultipleItems<T>(objects: [T]) where T : NSManagedObject {
      objects.forEach { container.viewContext.insert($0) }
      try? coreSave()

   }


   // delete
   func deleteSingleItem<T>(object: T) where T : NSManagedObject {
      container.viewContext.delete(object)
      try? coreSave()
   }

   func deleteMultipleItem<T>(objects: [T]) where T : NSManagedObject {
      objects.forEach { container.viewContext.delete($0) }
      try? coreSave()
   }

   func deleteByCondition<T>(objects: [T], conditional: @escaping (T) throws -> Bool) where T : NSManagedObject {
      try? objects.forEach {
         while try conditional($0) {
            container.viewContext.delete($0)
         }
      }
      try? coreSave()

   }




   }
