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
    private let viewModel: CalculatorViewModel
    
    init(currencyCode: String, rate: Double) {
        self.viewModel = CalculatorViewModel(rate: rate, currencyCode: currencyCode)
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
        bindViewModel()
        updateCurrencyLabels()
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
        
        calculatorView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func updateCurrencyLabels() {
        calculatorView.currencyLabel.text = viewModel.currencyCode
        calculatorView.countryLabel.text = CurrencyCountryData.name[viewModel.currencyCode] ?? ""
    }
    
    private func bindViewModel() {
        viewModel.stateChange = { [weak self] state in
            self?.calculatorView.resultLabel.text = state.result
        }
        
        viewModel.error = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    private func buttonDidTapped() {
        calculatorView.convertButton.addTarget(self, action: #selector(didTapConvert), for: .touchUpInside)
    }
    
    @objc private func didTapConvert() {
        let input = calculatorView.amountTextField.text ?? ""
        viewModel.convert(input: input)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
