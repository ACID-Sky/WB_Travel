//
//  DetailInformationView.swift
//  WBTravel
//
//  Created by Лёха Небесный on 16.05.2023.
//

import UIKit

protocol DetailInformationViewDelegate: AnyObject {
    /// передаём на контроллер нажатие кнопки на view
    func buttonDidTap()
}

final class DetailInformationView: UIView {

    private var flight: Flights
    private let delegate: DetailInformationViewDelegate

    private lazy var serviceClassLabel = UILabel()
    private lazy var searchTokenLabel = UILabel()


    private lazy var button = UIButton()

    init(for flight: Flights, delegate: DetailInformationViewDelegate) {
       self.flight = flight
        self.delegate = delegate

       super.init(frame: .zero)

        self.setupServiceClassLabel()
        self.setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupServiceClassLabel(){
        let serviceClass: ServiceClass = ServiceClass(rawValue: self.flight.serviceClass) ?? .ECONOMY

        self.serviceClassLabel.text = {
            switch serviceClass {

            case .ECONOMY:
                return "Эконом"
            case .COMFORT:
                return "Комфорт"
            case .BUSINESS:
                return "Бизнес"
            }
        }()
        let stack = CommonFunc().generateVerticalStack(with: (nameLabel: "Класс обслуживания", valuesLabel: self.serviceClassLabel))

        self.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])

        self.setupHorizontalStack(attachTo: stack)
    }

    private func setupHorizontalStack(attachTo stack: UIStackView) {

        let groupHorizontalStack = UIStackView()
        groupHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        groupHorizontalStack.axis = .horizontal
        groupHorizontalStack.spacing = 3
        groupHorizontalStack.distribution = .fillProportionally
        groupHorizontalStack.alignment = .fill

        let seatsVerticalStack = CommonFunc().generateVerticalStack(with: "Места в перелёте", stack: groupHorizontalStack)

        var passengers: [(typePassenger: PassengerType, numberOfSeats: Int16)] = [
            (typePassenger: .ADT, numberOfSeats: 0),
            (typePassenger: .CHD, numberOfSeats: 0),
            (typePassenger: .INF, numberOfSeats: 0),
            (typePassenger: .INS, numberOfSeats: 0),
            (typePassenger: .UNN, numberOfSeats: 0)
        ]

        self.flight.seats.forEach({
            let passengerType: PassengerType = PassengerType(rawValue: $0.passengerType) ?? .Unknow

            switch passengerType {
            case .ADT:
                passengers[0].numberOfSeats += $0.count
            case .CHD:
                passengers[1].numberOfSeats += $0.count
            case .INF:
                passengers[2].numberOfSeats += $0.count
            case .INS:
                passengers[3].numberOfSeats += $0.count
            case .UNN:
                passengers[4].numberOfSeats += $0.count
            case .Unknow:
                return
            }
        })

        passengers.forEach({
            if $0.numberOfSeats > 0 {
                let label = UILabel()
                label.text = String($0.numberOfSeats)
                var passengerType =  $0.typePassenger.rawValue

                let passenger: PassengerType = $0.typePassenger

                let passengerTypeString: String = {
                    switch passenger {
                    case .ADT:
                        return "Взрослый (старше 12 лет)"
                    case .CHD:
                        return "Ребенок (от 2 до 12 лет)"
                    case .INF:
                        return "Младенец без места (до 2 лет)"
                    case .INS:
                        return "Младенец с местом (до 2 лет)"
                    case .UNN:
                        return "Ребенок без сопровождения(от 2 до 12 лет)"
                    case .Unknow:
                        return ""
                    }
                }()


                let seatStack = CommonFunc().generateVerticalStack(with: (nameLabel: passengerTypeString, valuesLabel: label))
                groupHorizontalStack.addArrangedSubview(seatStack)
            }
        })


        self.addSubview(seatsVerticalStack)

        NSLayoutConstraint.activate([
            seatsVerticalStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16),
            seatsVerticalStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            seatsVerticalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])

        self.setupSearchToken(attachTo: seatsVerticalStack)
    }

    private func setupSearchToken(attachTo stack: UIStackView) {
        self.searchTokenLabel.text = self.flight.searchToken
        let tokenStack = CommonFunc().generateVerticalStack(with: (nameLabel: "Код поиска рейса", valuesLabel: self.searchTokenLabel))

        self.addSubview(tokenStack)

        NSLayoutConstraint.activate([
            tokenStack.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16),
            tokenStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            tokenStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
    }


    private func setupButton() {
        self.button.setTitleColor(.systemBackground, for: .normal)
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action:  #selector(buttonDidTap), for: .touchUpInside)

        self.addSubview(self.button)

        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            self.button.heightAnchor.constraint(equalToConstant: 40),
            self.button.widthAnchor.constraint(equalToConstant: 120)
        ])

        self.button.layer.cornerRadius = 10
        self.customizeButton()
    }

    private func customizeButton(){
        if self.flight.liked {
            self.button.setTitle("Не нравится", for: .normal)
            self.button.backgroundColor = #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1)
        } else {
            self.button.setTitle("Нравится", for: .normal)
            self.button.backgroundColor = #colorLiteral(red: 0.6, green: 0, blue: 0.6, alpha: 1)
        }
    }

    @objc private func buttonDidTap(){
        self.flight.liked = !self.flight.liked
        self.customizeButton()
        self.delegate.buttonDidTap()
    }

}
