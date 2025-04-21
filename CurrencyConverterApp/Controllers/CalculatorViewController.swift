//
//  CalculatorViewController.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/21/25.
//

import UIKit
import SnapKit

class CalculatorViewController: UIViewController {
    
    private let currencyCode: String
    private let rate: Double
    
    init(currencyCode: String, rate: Double) {
        self.currencyCode = currencyCode
        self.rate = rate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor {
            $0.userInterfaceStyle == .dark ? .black : .white
        }
        
    }
    
}
