//
//  FlightTemplateView.swift
//  WBTravel
//
//  Created by Лёха Небесный on 15.05.2023.
//

import UIKit

final class FlightTemplateView: UIView {
    enum Constant {
        static let color = #colorLiteral(red: 0.2823529412, green: 0.06666666667, blue: 0.4509803922, alpha: 1)
        static let height = CGFloat(40)
    }

    private lazy var headView = UIView()
    private lazy var likedImageView = UIImageView()
    private lazy var planeImageView = UIImageView()
    private lazy var footView = UIView()

    private let centralView: UIView


    init(with centralView: UIView){
        self.centralView = centralView
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.setupHeadView()
        self.setupPlaneImageView()
        self.setupLikedImageView()
        self.setupFootView()
        self.setupCentralView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHeadView() {
        self.headView.translatesAutoresizingMaskIntoConstraints = false
        self.headView.backgroundColor = Constant.color

        self.addSubview(self.headView)

        NSLayoutConstraint.activate([
            self.headView.topAnchor.constraint(equalTo: self.topAnchor),
            self.headView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.headView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.headView.heightAnchor.constraint(equalToConstant: Constant.height),
        ])
    }

    private func setupPlaneImageView() {
        self.planeImageView.translatesAutoresizingMaskIntoConstraints = false
        self.planeImageView.clipsToBounds = true
        self.planeImageView.backgroundColor = Constant.color
        self.planeImageView.contentMode = .center
        self.planeImageView.image = UIImage(named: "plane")?.withRenderingMode(.alwaysTemplate)
        self.planeImageView.tintColor = .systemBackground

        self.addSubview(self.planeImageView)

        NSLayoutConstraint.activate([
            self.planeImageView.centerYAnchor.constraint(equalTo: self.headView.bottomAnchor),
            self.planeImageView.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.height),
            self.planeImageView.widthAnchor.constraint(equalToConstant: Constant.height*3/2),
            self.planeImageView.heightAnchor.constraint(equalToConstant: Constant.height*3/2),
        ])

        self.planeImageView.layer.cornerRadius = Constant.height*3/4
        self.planeImageView.layer.borderColor = UIColor.systemBackground.cgColor
        self.planeImageView.layer.borderWidth = 3
    }
    private func setupLikedImageView(){
        self.likedImageView.translatesAutoresizingMaskIntoConstraints = false
        self.likedImageView.clipsToBounds = true
        self.likedImageView.backgroundColor = .clear
        self.likedImageView.contentMode = .center
        self.likedImageView.image = UIImage(systemName: "heart")
        self.likedImageView.tintColor = .white

        self.addSubview(self.likedImageView)

        NSLayoutConstraint.activate([
            self.likedImageView.centerYAnchor.constraint(equalTo: self.headView.centerYAnchor),
            self.likedImageView.centerXAnchor.constraint(equalTo: self.headView.trailingAnchor, constant: -Constant.height),
            self.likedImageView.widthAnchor.constraint(equalToConstant: Constant.height/2),
            self.likedImageView.heightAnchor.constraint(equalToConstant: Constant.height/2),
        ])
    }
    private func setupFootView() {
        self.footView.translatesAutoresizingMaskIntoConstraints = false
        self.footView.backgroundColor = Constant.color

        self.addSubview(self.footView)

        NSLayoutConstraint.activate([
            self.footView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.footView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.footView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.footView.heightAnchor.constraint(equalToConstant: Constant.height/2),
        ])
    }

    private func setupCentralView() {
        self.centralView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.centralView)

        NSLayoutConstraint.activate([
            self.centralView.topAnchor.constraint(equalTo: self.headView.bottomAnchor, constant: 8),
            self.centralView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            self.centralView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            self.centralView.bottomAnchor.constraint(equalTo: self.footView.topAnchor, constant: -8),
        ])
    }

}

extension FlightTemplateView {
    /// Изменение картинки, показывающей стоит лайк или нет
    /// - Parameter liked: передаётся true если лайк поставили и false если лайк снимается
    func changeLiked(to liked: Bool) {
        let likedImage = liked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        let likedColor: UIColor = liked ? .red : .white

        self.likedImageView.image = likedImage
        self.likedImageView.tintColor = likedColor
    }
}



