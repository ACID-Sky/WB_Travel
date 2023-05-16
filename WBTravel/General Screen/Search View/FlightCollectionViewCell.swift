//
//  FlightCollectionViewCell.swift
//  WBTravel
//
//  Created by Лёха Небесный on 15.05.2023.
//

import UIKit

final class FlightCollectionViewCell: UICollectionViewCell {
    private lazy var shortInformationView = ShortInformationView()
    private lazy var flightTemplateView = FlightTemplateView(with: shortInformationView)


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupFlightTemplate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupFlightTemplate(){
        self.flightTemplateView.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(self.flightTemplateView)

        NSLayoutConstraint.activate([
            self.flightTemplateView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.flightTemplateView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.flightTemplateView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.flightTemplateView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
        ])
    }
}

extension FlightCollectionViewCell {
    func setup(for flight: Flights) {
        self.flightTemplateView.changeLiked(to: flight.liked)
        self.shortInformationView.setupInfo(for: flight)
    }
}




