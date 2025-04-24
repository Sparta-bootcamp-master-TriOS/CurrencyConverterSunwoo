//
//  CoreDataManager.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/23/25.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    var container: NSPersistentContainer
    
   private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    // Read
    func fetchAll() -> [String] {
        do {
            let result = try container.viewContext.fetch(CurrencyData.fetchRequest())
            let code = result.compactMap { $0.currencyCode }
            return code
        } catch {
            return []
        }
    }
    
    // Create
    func add(currencyCode: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: CurrencyData.className, in: container.viewContext) else { return }
        let object = NSManagedObject(entity: entity, insertInto: container.viewContext)
        object.setValue(currencyCode, forKey: CurrencyData.Key.currencyCode)
        do {
            try container.viewContext.save()
        } catch {
            print("Add Fail")
        }
    }
    
    // Delete
    func remove(currencyCode: String) {
        let fetch = CurrencyData.fetchRequest()
        fetch.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)
        
        do {
            let result = try container.viewContext.fetch(fetch)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
            try self.container.viewContext.save()
        } catch {
            print("Remove Fail")
        }
    }
}
