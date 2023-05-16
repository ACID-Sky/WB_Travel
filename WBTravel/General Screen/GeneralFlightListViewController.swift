//
//  GeneralFlightListViewController.swift
//  WBTravel
//
//  Created by Лёха Небесный on 12.05.2023.
//

import UIKit

final class GeneralFlightListViewController: UIViewController {

    private let networkService: NetworkServicePorotocol
    private lazy var queryEntryView = QueryEntry(delegate: self)
    private lazy var searchResultView = SearchResultView(delegate: self)

    init(networkService: NetworkServicePorotocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = BackgroundView()
        self.setupView()
        self.setupQueryEntryView()
        self.setupSearchResultView()
    }

    private func setupView() {
        self.navigationController?.navigationBar.tintColor = .label
        self.view.backgroundColor = .clear
        self.navigationItem.title = "Поиск билетов по аэропорту отправления."
    }

    private func setupQueryEntryView(){
        self.queryEntryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.queryEntryView)

        NSLayoutConstraint.activate([
            self.queryEntryView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.queryEntryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.queryEntryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.queryEntryView.heightAnchor.constraint(equalToConstant: 80),
        ])
    }

    private func setupSearchResultView(){
        self.searchResultView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.searchResultView)

        NSLayoutConstraint.activate([
            self.searchResultView.topAnchor.constraint(equalTo: self.queryEntryView.bottomAnchor),
            self.searchResultView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.searchResultView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.searchResultView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func showAlertWith(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert
            )



            let yesAction = UIAlertAction(title: "Ok", style: .default)

            alert.addAction(yesAction)
            self.present(alert, animated: true)
        }
    }

}

extension GeneralFlightListViewController: QueryEntryDelegate {
    func searchFlightsFrom(departureAirport: String) {
        self.searchResultView.updateLoadingAnimation(isLoading: true)
        guard let urlRequest = self.networkService.URLRequestFor(departureAirport: departureAirport) else { return }

        self.networkService.fetchFlights(usingURLRequest: urlRequest) {result in
            DispatchQueue.main.async {
                self.searchResultView.updateLoadingAnimation(isLoading: false)
            }
            switch result {
            case .success(let answer):
                if answer.flights.count == 0 {

                    self.showAlertWith(title: "Ничего не нашлось!", message: "По Вашему запросу нет билетов, попробуйте другой аэропорт вылета.")
                }
                DispatchQueue.main.async {
                    self.searchResultView.setupParams(with: answer.flights)
                }

            case .failure:
                self.showAlertWith(title: "Ошибка.", message: "Упс, что-то пошло не так.")

            }
        }
    }
}

extension GeneralFlightListViewController: SearchResultViewDelegate {
    func openDetails(for flightIndex: Int, flight: Flights) {
        let vc = DetailsViewController(flightIndex: flightIndex, flight: flight, delegate: self)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

extension GeneralFlightListViewController: DetailsViewControllerDelegate {
    func likeFlight(with index: Int, liked: Bool) {
        self.searchResultView.changeFlight(index: index, to: liked)
    }
}
