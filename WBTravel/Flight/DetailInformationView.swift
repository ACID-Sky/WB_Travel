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
        self.serviceClassLabel.text = self.flight.serviceClass
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

        let seatsVerticalStack = CommonFunc().generateVerticalStack(with: "Доступные места", stack: groupHorizontalStack)

        self.flight.seats.forEach({
            let label = UILabel()
            label.text = String($0.count)
            let seatStack = CommonFunc().generateVerticalStack(with: (nameLabel: $0.passengerType, valuesLabel: label))
            groupHorizontalStack.addArrangedSubview(seatStack)
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
