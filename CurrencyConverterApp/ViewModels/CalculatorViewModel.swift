//
//  CalculatorViewModel.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/22/25.
//

import Foundation

final class CalculatorViewModel: ViewModelProtocol {
    enum Action {
        case convert(String)
    }
    
    let rate: Double
    let currencyCode: String
    
    init(rate: Double, currencyCode: String) {
        self.rate = rate
        self.currencyCode = currencyCode
    }
    
    struct State {
        var result: String = ""
    }
    
    private(set) var state = State() {
        didSet { stateChange?(state) }
    }
    
    var stateChange: ((State) -> Void)?
    var error: ((String) -> Void)?
    var action: ((Action) -> Void)?
    
    func convert(input: String) {
        guard !input.isEmpty else {
            error?("금액을 입력해주세요")
            return
        }
        
        guard let amount = Double(input) else {
            error?("올바른 숫자를 입력해주세요")
            return
        }
        
        let result = amount * rate
        // 반올림 구현
        let roundedAmount = (amount * 100).rounded() / 100
        let roundedResult = (result * 100).rounded() / 100
        
        let stringAmount = String(format: "%.2f", roundedAmount)
        let stringResult = String(format: "%.2f", roundedResult)
        
        state.result = "$\(stringAmount) → \(stringResult) \(currencyCode)"
    }
}
