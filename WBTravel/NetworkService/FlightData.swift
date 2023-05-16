//
//  FlightData.swift
//  WBTravel
//
//  Created by Лёха Небесный on 12.05.2023.
//

import Foundation

struct FlightsAPIAnswer: Decodable {
    let flights: [Flights]
}

struct Flights: Decodable {
    let startDate: String
    let endDate: String
    let startLocationCode: String
    let endLocationCode: String
    let startCity: String
    let endCity: String
    let serviceClass: String
    let seats: [Seats]
    let price: Int16
    let searchToken: String
    var liked: Bool

    enum CodingKeys: String, CodingKey {
        case startDate,
             endDate,
             startLocationCode,
             endLocationCode,
             startCity,
             endCity,
             serviceClass,
             seats,
             price,
             searchToken
    }

    init(from decoder: Decoder) throws {
        self.liked = false
        let container = try decoder.container(keyedBy: CodingKeys.self)
        startDate = try container.decode(String.self, forKey: .startDate)
        endDate = try container.decode(String.self, forKey: .endDate )
        startLocationCode = try container.decode(String.self, forKey: .startLocationCode )
        endLocationCode = try container.decode(String.self, forKey: .endLocationCode )
        startCity = try container.decode(String.self, forKey: .startCity )
        endCity = try container.decode(String.self, forKey: .endCity )
        serviceClass = try container.decode(String.self, forKey: .serviceClass )
        seats = try container.decode([Seats].self, forKey: .seats )
        price = try container.decode(Int16.self, forKey: .price )
        searchToken = try container.decode(String.self, forKey: .searchToken )
    }
}

struct Seats: Decodable {
    let passengerType: String
    let count: Int16
}
