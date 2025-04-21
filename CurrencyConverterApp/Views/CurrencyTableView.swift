//
//  CurrencyTableView.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/17/25.
//

import UIKit

class CurrencyTableView: UIView {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.id)
        return tableView
    }()
    
    private let noResultLabel: UILabel = { // 결과 없음 표시 label
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func noResultState(isEmpty: Bool) { // 결과 없음 상태
        tableView.backgroundView = isEmpty ? noResultLabel : nil
    }
    
    private func configureUI() {
        self.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

