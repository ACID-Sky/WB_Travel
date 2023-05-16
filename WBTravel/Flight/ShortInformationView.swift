//
//  ShortInformationView.swift
//  WBTravel
//
//  Created by Лёха Небесный on 15.05.2023.
//

import UIKit

class ShortInformationView: UIView {
    
    private lazy var startCityLabel = UILabel()
    private lazy var endCityLabel = UILabel()
    private lazy var startDateLabel = UILabel()
    private lazy var endDateLabel = UILabel()
    private lazy var priceLabel = UILabel()
    
    
    init() {
        super.init(frame: .zero)
        self.setupPriceLabel()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupPriceLabel(){
        let stack = CommonFunc().generateVerticalStack(with: (nameLabel: "Цена", valuesLabel: self.priceLabel))
        stack.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.widthAnchor.constraint(equalToConstant: 80),
        ])

        self.setupHorizontalStackView(attachTo: stack)
    }

    private func setupHorizontalStackView(attachTo stack: UIStackView) {
        let horizontalStackView = UIStackView()
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        
        self.addSubview(horizontalStackView)

        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: stack.trailingAnchor, constant: 16),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let paramsArray: [(imgaName: String, labelsArray: [(nameLabel: String, valuesLabel: UILabel)])] = [
            (
                imgaName: "airplane.departure",
                labelsArray: [
                    (nameLabel: "Город отправления", valuesLabel: self.startCityLabel),
                    (nameLabel: "Дата отправления", valuesLabel: self.startDateLabel)
                ]
            ),
            (
                imgaName: "airplane.arrival",
                labelsArray: [
                    (nameLabel: "Город прибытия", valuesLabel: self.endCityLabel),
                    (nameLabel: "Дата обратного вылета", valuesLabel: self.endDateLabel)
                ]
            )
        ]

        self.add(labels: paramsArray, to: horizontalStackView)

    }

    private func add(labels: [(imgaName: String, labelsArray: [(nameLabel: String, valuesLabel: UILabel)])], to stack: UIStackView){
        labels.forEach({
            let verticalalStackView = UIStackView()
            verticalalStackView.axis = .vertical
            verticalalStackView.spacing = 8
            verticalalStackView.distribution = .fillProportionally
            verticalalStackView.alignment = .fill

            stack.addArrangedSubview(verticalalStackView)

            let imageView = UIImageView()
            imageView.backgroundColor = .clear
            imageView.contentMode = .left
            imageView.image = UIImage(systemName: $0.imgaName)
            imageView.tintColor = .black

            verticalalStackView.addArrangedSubview(imageView)

            $0.labelsArray.forEach({
                let groupStack = CommonFunc().generateVerticalStack(with: (nameLabel: $0.nameLabel, valuesLabel: $0.valuesLabel))
                verticalalStackView.addArrangedSubview(groupStack)

            })

        })
    }
}


extension ShortInformationView {
    /// Устанавливам значения в лейблы для перелета
    /// - Parameter flight: экземпляр перелета, по которому нужно вывести информацию
    func setupInfo(for flight: Flights){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        let startDateArray = flight.startDate.components(separatedBy: " ").filter({!$0.isEmpty})
        let endDateArray = flight.endDate.components(separatedBy: " ").filter({!$0.isEmpty})

        self.startCityLabel.text = flight.startCity + "\n(" + flight.startLocationCode + ")"
        self.endCityLabel.text = flight.endCity + "\n(" + flight.endLocationCode + ")"
        self.priceLabel.text = String(flight.price)  + " руб."

        guard let startDate = dateFormatter.date(from: startDateArray[0] + " " + startDateArray[1]),
              let endDate = dateFormatter.date(from: endDateArray[0] + " " + endDateArray[1]) else {
            self.startDateLabel.text = "-- -- ---- --:--"
            self.endDateLabel.text = "-- -- ---- --:--"
        return
        }
        dateFormatter.locale = .current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "d MMM yyyy HH:mm"

        self.startDateLabel.text = dateFormatter.string(from: startDate)
        if endDate > startDate {
            self.endDateLabel.text = dateFormatter.string(from: endDate)
        } else {
            self.endDateLabel.text = "Нет обратного рейса"
        }
    }
}

