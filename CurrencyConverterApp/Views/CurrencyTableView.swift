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
}

