//
//  ICoreDataManager.swift
//  CoreDataManager
//
//  Created by mehmet karanlık on 12.06.2022.
//

import Foundation
import CoreData

protocol ICoreDataManager {
   //save
   func saveSingleItem<T: NSManagedObject>(object : T)
   func saveMultipleItems<T : NSManagedObject>(objects : [T])
   //delete
   func deleteSingleItem<T : NSManagedObject>(object : T)
   func deleteMultipleItem<T: NSManagedObject>(objects : [T])
   func deleteByCondition<T:NSManagedObject>(objects : [T], predicament: @escaping (T) throws -> Bool)
   //fetch
   func fetchSingular<T: NSManagedObject>(object : T) -> T?
   func fetchMultiple<T : NSManagedObject>() -> [T]?


   func coreSave() throws
}
