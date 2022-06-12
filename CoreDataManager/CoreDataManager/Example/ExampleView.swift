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
   @State var items : [Item] = []

   init() {
      coreManager = CoreDataManager.shared

   }

    var body: some View {
       List {

       }
          .onAppear {
             guard let results = coreManager.fetchMultiple() as? [Item] else { return }
             items = results

          }
    }

}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
