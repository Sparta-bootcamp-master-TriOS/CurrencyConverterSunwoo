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
        dataService.fetchData(success: { [weak self] response in
            let data = response.rates
                .sorted { $0.key < $1.key }
                .map { ($0.key, $0.value) }
            self?.currencyTableView.updateData(response: data)
        }, failure: { [weak self] in
            self?.dataErrorAlert()
            }
        )
    }
    
    // 데이터 로딩 실패 시 Alert 띄어주는 함수 구현
    private func dataErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "🚨데이터를 불러올 수 없습니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
