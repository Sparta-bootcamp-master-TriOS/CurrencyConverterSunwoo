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
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
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
        [labelStackView, rateLabel].forEach { contentView.addSubview($0) }
        
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        rateLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).inset(16)
        }
    }
    
    public func configure(currency: String, rate: Double) {
        currencyLabel.text = currency
        rateLabel.text = String(format: "%.4f", rate)
        countryLabel.text = CurrencyCountryData.name[currency]
    }

}
