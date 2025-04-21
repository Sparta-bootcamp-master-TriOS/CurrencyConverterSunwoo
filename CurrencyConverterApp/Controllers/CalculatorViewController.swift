//
//  CalculatorViewController.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/21/25.
//

import UIKit
import SnapKit

class CalculatorViewController: UIViewController {
    private let calculatorView = CalculatorView()
    
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
        navigationBarUI()
        configureUI()
        buttonDidTapped()
    }
    
    private func navigationBarUI() {
        self.title = "환율 계산기"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        let backBarButtonItem = UIBarButtonItem(title: "환율 정보", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor {
            $0.userInterfaceStyle == .dark ? .black : .white
        }
        
        view.addSubview(calculatorView)
        
        calculatorView.currencyLabel.text = currencyCode
        calculatorView.countryLabel.text = CurrencyCountryData.name[currencyCode] ?? ""
        
        calculatorView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func buttonDidTapped() {
        calculatorView.convertButton.addTarget(self, action: #selector(didTapConvert), for: .touchUpInside)
    }
    
    @objc private func didTapConvert() {
        guard let inputNumber = calculatorView.amountTextField.text,
              let amount = Double(inputNumber) else { return }
        
        let result = amount * rate
        
        calculatorView.resultLabel.text = "$\(amount) → \(result) \(currencyCode)"
    }
}
