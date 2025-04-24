//
//  DataResponse.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/17/25.
//

import Foundation

struct DataResponse: Decodable {
    var result: String
    var provider, documentation, termsOfUse: String
    var timeLastUpdateUnix: Int
    var timeLastUpdateUtc: String
    var timeNextUpdateUnix: Int
    var timeNextUpdateUtc: String
    var timeEolUnix: Int
    var baseCode: String
    var rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result, provider, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUtc = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUtc = "time_next_update_utc"
        case timeEolUnix = "time_eol_unix"
        case baseCode = "base_code"
        case rates
    }
}
