//
//  DataService.swift
//  CurrencyConverterApp
//
//  Created by 조선우 on 4/17/25.
//

import Foundation

class DataService {
    // 서버 데이터(환율 데이터)를 외부 API로부터 불러오고 호출한 쪽(VC)에게 전달하는 메서드 선언
    func fetchData(success: @escaping (DataResponse) -> Void, failure: @escaping () -> Void) {
        
        guard let url: URL = URL(string: "https://open.er-api.com/v6/latest/USD") else {
            print("URL is not correct")
            return
        }
        
        // URLRequest 설정
        var request: URLRequest = URLRequest(url: url)
        // GET 메소드 사용(요청 객체)
        request.httpMethod = "GET"
        // json 데이터 형식임을 서버에 알려줌
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // URLSession 생성 (기본 default 세션) (네트워크 요청을 수행함)
        let session: URLSession = URLSession(configuration: .default)
        
        // dataTask (실제로 서버에 요청을 보내고 응답을 기다림) (백그라운드 쓰레드에서 실행됨)
        session.dataTask(with: request) { data, response, error in
            // http 통신 response에는 status code가 함께오는데, 200번대가 성공
            let successRange: Range = (200..<300)
            // 통신 성공
            guard let data, error == nil else {
                DispatchQueue.main.async { failure() }
                return
            }
            
            if let response: HTTPURLResponse = response as? HTTPURLResponse{
                // 요청 성공 (StatusCode가 200번대)
                if successRange.contains(response.statusCode){
                    // decode
                    guard let decoded: DataResponse = try? JSONDecoder().decode(DataResponse.self, from: data) else { return }
                    
                    DispatchQueue.main.async{
                        success(decoded)
                    }
                } else { // 요청 실패 (Status code가 200대 아님)
                    DispatchQueue.main.async {
                        failure()
                    }
                }
            }
        }.resume()
    }
}
