//
//  QueryEntry.swift
//  WBTravel
//
//  Created by Лёха Небесный on 13.05.2023.
//

import UIKit
protocol QueryEntryDelegate {
    /// Обращение к NetworkService для получения ответа по перелётам
    /// - Parameter departureAirport: код аэропорта вылета
    func searchFlightsFrom(departureAirport: String)
}

final class QueryEntry: UIView {
    private let delegate: QueryEntryDelegate

    private lazy var textField = TextFieldWithPadding()
    private lazy var button = UIButton()

    init(delegate: QueryEntryDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.setupButton()
        self.setupTextField()
        self.checkCharacters()
        self.setupGestures()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTextField(){
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.backgroundColor = .systemBackground
        self.textField.attributedPlaceholder = NSAttributedString(
            string: "Код аэропорта (Пример: LED)",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        self.textField.delegate = self
        self.textField.font = textField.font?.withSize(15)
        self.textField.keyboardType = .asciiCapable
        self.textField.returnKeyType = .done
        self.textField.autocapitalizationType = .allCharacters

        self.addSubview(self.textField)
        self.textField.layer.cornerRadius = 12
        self.textField.layer.borderWidth = 1


        NSLayoutConstraint.activate([
            self.textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.textField.trailingAnchor.constraint(equalTo: self.button.leadingAnchor, constant: -8)
        ])
    }

    private func setupButton() {

        self.button.setTitle("Найти", for: .normal)
        self.button.setTitleColor(.systemBackground, for: .normal)
        self.button.backgroundColor = .systemGray
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.addTarget(self, action:  #selector(buttonDidTap), for: .touchUpInside)

        self.addSubview(self.button)

        NSLayoutConstraint.activate([
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.button.heightAnchor.constraint(equalToConstant: 40),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.button.widthAnchor.constraint(equalToConstant: 120)
        ])

        self.button.layer.cornerRadius = 10
    }

    private func checkCharacters() {
        guard self.textField.text?.count == 3 else {
            self.button.backgroundColor = .systemGray
            self.button.isUserInteractionEnabled = false
            return
        }
        self.button.backgroundColor = #colorLiteral(red: 0.6, green: 0, blue: 0.6, alpha: 1)
        self.button.isUserInteractionEnabled = true
    }

    @objc private func buttonDidTap(){
        guard let departureAirport: String = self.textField.text,
              self.textField.text?.count == 3 else {return}
        self.forcedHidingKeyboard()
        delegate.searchFlightsFrom(departureAirport: departureAirport)
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func forcedHidingKeyboard() {
        self.endEditing(true)
    }

}

extension QueryEntry: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        self.buttonDidTap()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.checkCharacters()
    }

}
