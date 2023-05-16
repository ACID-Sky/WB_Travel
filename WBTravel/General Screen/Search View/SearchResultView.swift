//
//  SearchResultView.swift
//  WBTravel
//
//  Created by Лёха Небесный on 13.05.2023.
//

import UIKit

protocol SearchResultViewDelegate: AnyObject {
    /// Функция для открытия страницы с дополнительной информацией
    /// - Parameters:
    ///   - flightIndex: индекс прелета, по которому нужно открыть доп информацию
    ///   - flight: экземпляр перелета, по которому открываем доп информацию
    func openDetails(for flightIndex: Int, flight: Flights)
}

final class SearchResultView: UIView {
    enum Constants {
        static let flightCollectionViewCell = "FlightCollectionViewCell"
        static let defaultCellID = "DefaultCellID"

        static let inset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        static let spacing: CGFloat = 16
    }

    private let delegate: SearchResultViewDelegate
    private var fligts: [Flights] = []


    private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
    private lazy var layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: self.layout)

    init(delegate: SearchResultViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.setupActivityIndicator()
        self.setupLayout()
        self.setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActivityIndicator() {
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.isHidden = true
        self.activityIndicator.color = .white

        self.addSubview(self.activityIndicator)

        NSLayoutConstraint.activate([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }

    private func setupLayout() {
        self.layout.scrollDirection = .vertical
        self.layout.minimumInteritemSpacing = Constants.spacing
    }

    private func setupCollectionView() {
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.isHidden = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.defaultCellID)
        self.collectionView.register(FlightCollectionViewCell.self, forCellWithReuseIdentifier: Constants.flightCollectionViewCell)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.backgroundColor = .clear

        self.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

    private func updateCollectionViewVisibility(isHidden: Bool) {
        self.collectionView.isHidden = isHidden
        self.activityIndicator.isHidden = !isHidden
    }
}

extension SearchResultView {
    /// Функция, через которую передаётся информация о том, происходит ли сейчас процесс загрузки. Меняется видимость индикатора згрузки и его активность и видимость колекшенвью
    /// - Parameter isLoading: Если загрузка происходит передаётся true иначе передаётся false
    func updateLoadingAnimation(isLoading: Bool) {
        self.updateCollectionViewVisibility(isHidden: isLoading)
        isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
    }

    /// Передаётся корректные данные по полётам для отображения в колекшенвью
    /// - Parameter flights: массив перелётом
    func setupParams(with flights: [Flights]) {
        self.fligts = flights
        self.collectionView.reloadData()
    }

    /// Функция меняет параметр liked у перелета и перезагружает ячейку колекшенвью
    /// - Parameters:
    ///   - index: индекс перелёта, которому нужно изменить параметр liked
    ///   - liked: Если лайк поставили передаётся true иначе false
    func changeFlight(index: Int, to liked: Bool) {
        self.fligts[index].liked = liked
        self.collectionView.reloadItems(at: [[0,index]])
    }
}

extension SearchResultView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.fligts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.flightCollectionViewCell, for: indexPath) as? FlightCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }
        let flight = self.fligts[indexPath.row]

        cell.setup(for: flight)
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }
}

extension SearchResultView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return Constants.inset
        }

        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width - 2*Constants.inset.left
        let itemHeight = CGFloat(200)
        return CGSize(width: width, height: itemHeight)
    }

}

extension SearchResultView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let flight = self.fligts[indexPath.row]
        self.delegate.openDetails(for: indexPath.row, flight: flight)
    }
}
