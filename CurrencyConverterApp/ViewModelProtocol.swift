//
//  ViewModelProtocol.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/23/25.
//

import Foundation

protocol ViewModelProtocol {
    associatedtype Action // 행동 요청
    associatedtype State // 값의 상태
    
    var action: ((Action) -> Void)? { get }
    var state: State { get }
}
