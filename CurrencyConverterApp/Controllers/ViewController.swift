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
    private let countrySearchBar = CountrySearchBar()
    private let currencyTableView = CurrencyTableView()
    
    private var allDataList: [(String, Double)] = [] // 모든 데이터
    private var filteredDataList: [(String, Double)] = [] // 필터링된 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDelegates()
        configureUI()
        fetchCurrencyData()
    }
    
    private func viewDelegates() {
        countrySearchBar.mainSearchBar.delegate = self
        currencyTableView.tableView.delegate = self
        currencyTableView.tableView.dataSource = self
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
    
    private func fetchCurrencyData() {
        dataService.fetchData(success: { [weak self] response in
            let data = response.rates
                .sorted { $0.key < $1.key }
                .map { ($0.key, $0.value) }
            self?.allDataList = data
            self?.filteredDataList = data
            self?.currencyTableView.tableView.reloadData()
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let keyword = searchText.uppercased()
        let newItems = keyword.isEmpty
            ? allDataList
            : allDataList.filter { $0.0.contains(keyword) }
        
        let newKeys = newItems.map { $0.0 }
        let oldKeys = filteredDataList.map { $0.0 }
        
        // 변경 없으면 아무 작업하지 않음
        guard newKeys != oldKeys else { return }
        
        let oldCount = filteredDataList.count
        let newCount = newItems.count
        
        // 항상 데이터 먼저 갱신
        filteredDataList = newItems
        
        // 셀 수가 같을 때만 reloadRows 사용
        if oldCount == newCount {
            let visible = currencyTableView.tableView.indexPathsForVisibleRows ?? [] // 화면에 보이는 인덱스 목록을 가져옴
            let indexPaths = visible.filter { $0.row < filteredDataList.count } // 현재 데이터 범위 안에 있는 인덱스만
            currencyTableView.tableView.reloadRows(at: indexPaths, with: .automatic)
        } else {
            currencyTableView.tableView.reloadData()
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.id) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        
        let (currency, rate) = filteredDataList[indexPath.row]
        cell.configure(currency: currency, rate: rate)
        return cell
    }
}
