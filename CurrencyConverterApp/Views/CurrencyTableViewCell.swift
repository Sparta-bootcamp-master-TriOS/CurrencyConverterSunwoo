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
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemYellow
        button.setImage(UIImage(systemName: "star"), for: .normal)
        return button
    }()
    
    // bookmarkButton 클로저로 전달
    var bookmarkButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [labelStackView, rateLabel, bookmarkButton].forEach { contentView.addSubview($0) }
        
        labelStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        rateLabel.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(bookmarkButton.snp.leading).inset(10)
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).inset(16)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }
    
    @objc private func bookmarkTapped() {
        bookmarkButtonTapped?()
    }
    
    public func configure(currency: String, rate: Double, isBookmark: Bool) {
        currencyLabel.text = currency
        rateLabel.text = String(format: "%.4f", rate)
        countryLabel.text = CurrencyCountryData.name[currency]
        let imageName = isBookmark ? "star.fill" : "star"
        bookmarkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

}
