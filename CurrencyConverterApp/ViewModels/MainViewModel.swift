//
//  MainViewModel.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/22/25.
//

import Foundation

final class MainViewModel: ViewModelProtocol {
    enum Action {
        case fetchData
        case filter(String, [IndexPath])
    }
    
    private let dataService = DataService()
    private var reloadIndexPaths: [IndexPath]? = nil // 항상 reload 되는 것이 아니므로 옵셔널
    
    struct State {
        var allDataList: [(String, Double)] = [] // 모든 데이터
        var filteredDataList: [(String, Double)] = [] // 필터링된 데이터
    }
    
    private(set) var state = State() {
        didSet {
            stateChange?(state, reloadIndexPaths)
            reloadIndexPaths = nil // 사용 후 초기화
        }
    }
    
    // 상태변화 클로저
    var stateChange: ((State, [IndexPath]?) -> Void)?
    // 에러처리 클로저
    var error: (() -> Void)?
    // 액션 클로저
    var action: ((Action) -> Void)?
    
    init() {
        action = { [weak self] action in
            switch action {
            case .fetchData:
                self?.fetchCurrencyData()
            case .filter(let keyword, let visible):
                self?.filterData(with: keyword, visible: visible)
            }
        }
    }
    
    private func fetchCurrencyData() {
        dataService.fetchData(success: { [weak self] response in
            let data = response.rates
                .sorted { $0.key < $1.key }
                .map { ($0.key, $0.value) }
            self?.state.allDataList = data
            self?.state.filteredDataList = data
        }, failure: { 
            self.error?()
            }
        )
    }
    
    func filterData(with searchText: String, visible: [IndexPath]) {
        let keyword = searchText.uppercased()
        
        let newItems = keyword.isEmpty
            ? state.allDataList
            : state.allDataList.filter {
                let currencyCode = $0.0
                let countryName = CurrencyCountryData.name[currencyCode] ?? ""
                return currencyCode.contains(keyword) || countryName.contains(searchText)
            }
        
        let newKeys = newItems.map { $0.0 }
        let oldKeys = state.filteredDataList.map { $0.0 }
        
        // 변경 없으면 아무 작업하지 않음
        guard newKeys != oldKeys else { return }
        
        let oldCount = state.filteredDataList.count
        let newCount = newItems.count
        
        // 셀 수가 같을 때만 reloadRows 사용
        if oldCount == newCount {
            reloadIndexPaths = visible.filter { $0.row < newCount } // 현재 데이터 범위 안에 있는 유효한 인덱스만
        }
        // 필터링 데이터 갱신
        state.filteredDataList = newItems
    }
    
    func numberOfRows() -> Int {
        return state.filteredDataList.count
    }
    
    func data(at index: Int) -> (String, Double)? {
        guard index < state.filteredDataList.count else { return nil }
        return state.filteredDataList[index]
    }
}
