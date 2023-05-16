//
//  NetworkService.swift
//  WBTravel
//
//  Created by Лёха Небесный on 12.05.2023.
//

import Foundation

protocol NetworkServicePorotocol: AnyObject {


    /// Создаём URLRequest для аэропорта прибытия
    /// - Parameter departureAirport: Код аэропорта отправления (международный код обозначения)
    /// - Returns: URLRequest для получения списко билетов
    func URLRequestFor(departureAirport: String) -> URLRequest?

    /// Получить локацию
    /// - Parameters:
    ///   - URLRequest: URLRequestt запроса
    ///   - completion: экземпляр FlightsAPIAnswer
    func fetchFlights(
        usingURLRequest urlRequest: URLRequest,
        completion: @escaping (Result<FlightsAPIAnswer, NetworkError>) -> Void
    )

}


final class NetworkService {}

extension NetworkService: NetworkServicePorotocol {
    func URLRequestFor(departureAirport: String) -> URLRequest? {
        let stringForPayload = "{\"startLocationCode\": \"" + departureAirport + "\"}"
        guard let url = URL(string: "https://vmeste.wildberries.ru/api/avia-service/twirp/aviaapijsonrpcv1.WebAviaService/GetCheap"),
            let payload = stringForPayload.data(using: .utf8) else
        {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = payload
        return request
    }

    func fetchFlights(usingURLRequest urlRequest: URLRequest, completion: @escaping (Result<FlightsAPIAnswer, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(.server(reason: error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(.unknown))
                return
            }

            do {
                let flights = try JSONDecoder().decode(FlightsAPIAnswer.self, from: data)
                completion(.success(flights))
            } catch {
                completion(.failure(.parse(description: error.localizedDescription)))
            }
        }.resume()
    }

}
