//
//  CommonFunc.swift
//  WBTravel
//
//  Created by Лёха Небесный on 16.05.2023.
//

import UIKit

struct CommonFunc {
    /// Создание вертикального стека с двумя лейблами: лейбл для описания и лебл для значения
    /// - Parameter labels: кортеж из nameLabel - используется для отображения текста в лебле для описания, valuesLabel передаётся лейбл, который нужно добавить в стек
    /// - Returns: UIStackView
    func generateVerticalStack(with labels: (nameLabel: String, valuesLabel: UILabel)) -> UIStackView {
        let groupVerticalStack = UIStackView()
        groupVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        groupVerticalStack.axis = .vertical
        groupVerticalStack.spacing = 3
        groupVerticalStack.distribution = .fillProportionally
        groupVerticalStack.alignment = .fill

        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = labels.nameLabel
        nameLabel.textColor = .systemGray
        nameLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)

        groupVerticalStack.addArrangedSubview(nameLabel)

        labels.valuesLabel.textAlignment = .left
        labels.valuesLabel.numberOfLines = 2
        labels.valuesLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)

        groupVerticalStack.addArrangedSubview(labels.valuesLabel)

        return groupVerticalStack
    }

    /// Создание вертикального стека с лейблом для описания и стеком
    /// - Parameters:
    ///   - nameLabel: Название изпользуется для отображения в лебле описания
    ///   - stack: stackView, который нужно разместить внутри создаваемого стека
    /// - Returns: UIStackView
    func generateVerticalStack(with nameLabel: String, stack: UIStackView) -> UIStackView {
        let groupVerticalStack = UIStackView()
        groupVerticalStack.translatesAutoresizingMaskIntoConstraints = false
        groupVerticalStack.axis = .vertical
        groupVerticalStack.spacing = 3
        groupVerticalStack.distribution = .fillProportionally
        groupVerticalStack.alignment = .fill

        let labelabel = UILabel()
        labelabel.textAlignment = .left
        labelabel.text = nameLabel
        labelabel.textColor = .systemGray
        labelabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)

        groupVerticalStack.addArrangedSubview(labelabel)
        groupVerticalStack.addArrangedSubview(stack)

        return groupVerticalStack

    }
}
