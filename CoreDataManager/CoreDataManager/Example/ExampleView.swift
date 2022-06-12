//
//  ExampleView.swift
//  CoreDataManager
//
//  Created by mehmet karanlık on 12.06.2022.
//

import SwiftUI
import CoreData

struct ExampleView: View {

   let coreManager : CoreDataManager
   @State var items : [Fruit] = []

   init() {
      coreManager = CoreDataManager.shared

   }

    var body: some View {
       List {
          Button("Add Item") {
             withAnimation {
                let item = Fruit(context: coreManager.container.viewContext)
                item.name = "Karpuz"
                coreManager.saveSingleItem(object: item)
                items = coreManager.fetchMultiple() as! [Fruit]
             }
          }
          Button("Delete") {
             withAnimation {
                coreManager.clearCache()
                items.removeAll()
             }
          }
          ForEach(items, id: \.self) { item in
             Text(item.name!)
          }
       }
          .onAppear {
             let results = coreManager.fetchSingular(object: Fruit()) { fruit in
                fruit.name == "Karpuz"
             }
             if let results = results {
                items.append(results)
             }
             items.forEach { fruit in
                print(fruit.name!)
             }


          }
    }

}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
