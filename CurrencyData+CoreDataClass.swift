//
//  CurrencyData+CoreDataClass.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/23/25.
//
//

import Foundation
import CoreData

@objc(CurrencyData)
public class CurrencyData: NSManagedObject {
    public static let className = "CurrencyData"
    public enum Key {
        static let currencyCode = "currencyCode"
    }
}
