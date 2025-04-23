//
//  CurrencyData+CoreDataProperties.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/23/25.
//
//

import Foundation
import CoreData


extension CurrencyData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyData> {
        return NSFetchRequest<CurrencyData>(entityName: "CurrencyData")
    }

    @NSManaged public var currencyCode: String?

}

extension CurrencyData : Identifiable {

}
