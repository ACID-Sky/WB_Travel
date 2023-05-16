//
//  DetailsViewController.swift
//  WBTravel
//
//  Created by Лёха Небесный on 15.05.2023.
//

import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    /// Функция меняем значение параметра liked у перелета для отображения информации на предыдущем экране
    /// - Parameters:
    ///   - index: индекс перелета
    ///   - liked: какое значение должно стать (true если лайк поставили и false если сняли)
    func likeFlight(with index: Int, liked: Bool)
}

class DetailsViewController: UIViewController {

    private let flightIndex: Int
    private var flight: Flights
    private let delegate: DetailsViewControllerDelegate

    private lazy var detailView = DetailView(for: self.flight, delegate: self)
    private lazy var flightTemplateView = FlightTemplateView(with: detailView)


    init(flightIndex: Int, flight: Flights, delegate: DetailsViewControllerDelegate){
        self.flightIndex = flightIndex
        self.flight = flight
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = BackgroundView()
        self.setupFlightTemplateView()
        self.checkLikedFlight()
    }

    private func setupFlightTemplateView() {
        self.flightTemplateView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(self.flightTemplateView)
        NSLayoutConstraint.activate([
            self.flightTemplateView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            self.flightTemplateView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.flightTemplateView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.flightTemplateView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -48)
        ])
    }


    private func checkLikedFlight(){
        self.flightTemplateView.changeLiked(to: self.flight.liked)
    }

}

extension DetailsViewController: DetailInformationViewDelegate {
    func buttonDidTap() {
        self.delegate.likeFlight(with: self.flightIndex, liked: !self.flight.liked)
        self.flight.liked = !self.flight.liked
        self.checkLikedFlight()
    }


}
