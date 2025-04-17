//
//  CurrencyTableViewCell.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/17/25.
//

import UIKit
import SnapKit

class CurrencyTableViewCell: UITableViewCell {

    static let id = "CurrencyTableViewCell"
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [currencyLabel, rateLabel].forEach { contentView.addSubview($0) }
        
        currencyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func configure(currency: String, rate: Double) {
        currencyLabel.text = currency
        rateLabel.text = String(rate)
    }

}
