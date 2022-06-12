//
//  CoreDataManager.swift
//  CoreDataManager
//
//  Created by mehmet karanlık on 12.06.2022.
//

import CoreData
import Foundation
import SwiftUI
import UIKit

struct CoreDataManager: ICoreDataManager {


   // MARK: properties

   static let shared = CoreDataManager()

   var container: NSPersistentContainer = .init(name: "ContainerModel")

   func coreSave() throws {
      do {
         try container.viewContext.save()
      } catch let e {
         print("Error : " + e.localizedDescription)
         //fatalError(e.localizedDescription)
      }
   }

   fileprivate func initiliazePersistenStore() {
      container.loadPersistentStores { _, error in
         if let error = error {
            print("Error while loading persistenStore : \(error)")
            return
         }
      }
      container.viewContext.automaticallyMergesChangesFromParent = true
   }

   private init() {
      initiliazePersistenStore()
   }

   // save
   func saveSingleItem<T: NSManagedObject>(object: T) {
      container.viewContext.insert(object)
      try? coreSave()
   }

   func saveMultipleItems<T>(objects: [T]) where T: NSManagedObject {
      objects.forEach {
         var entity = T(context: container.viewContext)
         entity = $0
      }
      try? coreSave()
   }

   // delete
   func deleteSingleItem<T>(object: T) where T: NSManagedObject {
      container.viewContext.delete(object)
      try? coreSave()
   }

   func deleteMultipleItem<T>(objects: [T]) where T: NSManagedObject {
      objects.forEach { container.viewContext.delete($0) }
      try? coreSave()
   }

   func deleteByCondition<T>(objects: [T], predicament: @escaping (T) throws -> Bool) where T: NSManagedObject {
      try? objects.forEach {
         while try predicament($0) {
            container.viewContext.delete($0)
         }
      }
      try? coreSave()
   }

   func clearCache() {
      let request = NSFetchRequest<Fruit>(entityName: "Fruit")
      let results = fetchRequest(request: request)
      if let results = results {
         results.forEach { container.viewContext.delete($0)    }
      }
      try? coreSave()

   }

   // fetch
   func fetchSingular<T: NSManagedObject>(object: T,predicament: @escaping (T) throws -> Bool) -> T? {
      let request = NSFetchRequest<T>(entityName: object.entity.name!)
      let queue = queueGenerator("FetchQue")
      let requestResult = fetchRequest(request: request)
      let result = requestResult?.filter { try! predicament($0) }.first


      return result
   }

   func fetchMultiple<T>() -> [T]? where T: NSManagedObject {
      let request = NSFetchRequest<T>(entityName: "Fruit")
      let queue = queueGenerator("FetchQue")
      var result : [T]?
      result = fetchRequest(request: request)
      return result
   }

   // misc
   private func queueGenerator(_ queueLabel: String) -> DispatchQueue {
      let queue = DispatchQueue(
         label: queueLabel, qos: .background,
         attributes: .concurrent,
         autoreleaseFrequency: .inherit, target: .main)

      return queue
   }

   private func fetchRequest<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
      var results = [T]()
      do {
         results = try container.viewContext.fetch(request)
      } catch let e {
         print("Error while fetching entity : \(e.localizedDescription)")
      }
      return results
   }
}
