//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/16/25.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    private let viewModel = MainViewModel()
    private let countrySearchBar = CountrySearchBar()
    private let currencyTableView = CurrencyTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDelegates()
        navigationBarUI()
        configureUI()
        bindViewModel()
        viewModel.action?(.fetchData)
        bindError()
    }
    
    private func viewDelegates() {
        countrySearchBar.mainSearchBar.delegate = self
        currencyTableView.tableView.delegate = self
        currencyTableView.tableView.dataSource = self
    }
    
    private func navigationBarUI() {
        self.title = "환율 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureUI() {
        // 다크모드 대응
        view.backgroundColor = UIColor {
            $0.userInterfaceStyle == .dark ? .black : .white
        }
        
        [countrySearchBar, currencyTableView].forEach { view.addSubview($0) }
        
        countrySearchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        currencyTableView.snp.makeConstraints {
            $0.top.equalTo(countrySearchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.stateChange = { [weak self] state, reloadRows in
            guard let self = self else { return }
            
            // 필터링 값이 비어있다면 "결과 없음" 호출
            self.currencyTableView.noResultState(isEmpty: state.filteredDataList.isEmpty)
            
            if let rows = reloadRows {
                self.currencyTableView.tableView.reloadRows(at: rows, with: .automatic)
            } else {
                self.currencyTableView.tableView.reloadData()
            }
        }
    }
    
    private func bindError() {
        viewModel.error = { [weak self] in
            self?.dataErrorAlert()
        }
    }
    
    // 데이터 로딩 실패 시 Alert 띄어주는 함수 구현
    private func dataErrorAlert() {
        let alert = UIAlertController(title: "Error", message: "🚨데이터를 불러올 수 없습니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let visible = currencyTableView.tableView.indexPathsForVisibleRows ?? [] // 화면에 보이는 인덱스 목록을 가져옴
        viewModel.filterData(with: searchText, visible: visible)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = viewModel.data(at: indexPath.row) else { return }
        let calculatorVC = CalculatorViewController(currencyCode: data.0, rate: data.1)
        
        navigationController?.pushViewController(calculatorVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.id) as? CurrencyTableViewCell,
              let (currency, rate) = viewModel.data(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        let isBookmark = viewModel.isBookmark(code: currency)
        
        cell.configure(currency: currency, rate: rate, isBookmark:  isBookmark)
        cell.bookmarkButtonTapped = { [weak self] in
            self?.viewModel.action?(.toggleBookmark(currency))
        }
        
        return cell
    }
}
