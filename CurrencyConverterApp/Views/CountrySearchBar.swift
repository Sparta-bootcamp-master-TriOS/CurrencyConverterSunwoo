//
//  CountrySearchBar.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/18/25.
//

import UIKit
import SnapKit

class CountrySearchBar: UIView {

    private let mainSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "통화 검색"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(mainSearchBar)
        
        mainSearchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
