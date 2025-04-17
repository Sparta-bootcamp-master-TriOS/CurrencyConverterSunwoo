//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/16/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let dataService = DataService()
    private let currencyTableView = CurrencyTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchCurrencyData()
    }
    
    private func configureUI() {
        // 다크모드 대응
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }
        
        [currencyTableView].forEach { view.addSubview($0) }
        
        currencyTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func fetchCurrencyData() {
        dataService.fetchData { [weak self] response in
            self?.currencyTableView.updateData(response: response)
        }
    }
}
