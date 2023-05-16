//
//  DetailView.swift
//  WBTravel
//
//  Created by Лёха Небесный on 16.05.2023.
//

import UIKit

class DetailView: UIView {

    private lazy var shortInformationView = ShortInformationView()
    private let detailInformationView: DetailInformationView

    init(for flight: Flights, delegate: DetailInformationViewDelegate){
        self.detailInformationView = DetailInformationView(for: flight, delegate: delegate)
        super.init(frame: .zero)
        self.setupViews()
        self.shortInformationView.setupInfo(for: flight)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.shortInformationView.translatesAutoresizingMaskIntoConstraints = false
        self.detailInformationView.translatesAutoresizingMaskIntoConstraints = false

        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1)

        addSubview(self.shortInformationView)
        addSubview(line)
        addSubview(self.detailInformationView)

        NSLayoutConstraint.activate([
            self.shortInformationView.topAnchor.constraint(equalTo: self.topAnchor),
            self.shortInformationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.shortInformationView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.shortInformationView.heightAnchor.constraint(equalToConstant: 200),

            line.topAnchor.constraint(equalTo: self.shortInformationView.bottomAnchor, constant: 8),
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: 4),

            self.detailInformationView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 8),
            self.detailInformationView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.detailInformationView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.detailInformationView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])

    }
}
