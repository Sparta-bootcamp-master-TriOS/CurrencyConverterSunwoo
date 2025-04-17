//
//  CurrencyTableView.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/17/25.
//

import UIKit

class CurrencyTableView: UIView {
    
    private var dataSource: [(String, Double)] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateData(response: DataResponse) {
        self.dataSource = response.rates
            .sorted { $0.key < $1.key }
            .map { ($0.key, $0.value) }
        tableView.reloadData()
    }
}

extension CurrencyTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

extension CurrencyTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.id) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }

        let (currency, rate) = dataSource[indexPath.row]
        cell.configure(currency: currency, rate: rate)
        return cell
    }
}
