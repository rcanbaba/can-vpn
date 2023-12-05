//
//  CustomAnnotationView.swift
//  canvpn
//
//  Created by Can Babaoğlu on 2.12.2023.
//

import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    private var titleLabel: UILabel
    private var pinImageView: UIImageView

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.titleLabel = UILabel()
        self.pinImageView = UIImageView()

        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        setupTitleLabel()
        setupPinImageView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.shadowOffset = CGSize(width: 2, height: 2)
        titleLabel.shadowColor = .black
        titleLabel.textColor = .white
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5), // Adjust as needed
            titleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }

    private func setupPinImageView() {
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        pinImageView.contentMode = .scaleAspectFit
        pinImageView.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(UIColor.Custom.orange.withAlphaComponent(0.6), renderingMode: .alwaysOriginal)
        addSubview(pinImageView)

        NSLayoutConstraint.activate([
            pinImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            pinImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -5), // Adjust as needed
            pinImageView.widthAnchor.constraint(equalToConstant: 24), // Adjust size as needed
            pinImageView.heightAnchor.constraint(equalToConstant: 24)  // Adjust size as needed
        ])
    }
    
    override var annotation: MKAnnotation? {
        willSet {
            super.annotation = newValue
            if let customAnnotation = newValue as? CustomAnnotation {
                titleLabel.text = customAnnotation.title
                if customAnnotation.isPremium {
                    pinImageView.image = UIImage(named: "pro-crown-icon")?.withRenderingMode(.alwaysOriginal)
                  //  pinImageView.tintColor = UIColor.Custom.goPreButtonGold
                } else {
                    pinImageView.image = UIImage(systemName: "mappin.and.ellipse")?.withRenderingMode(.alwaysTemplate)
                    pinImageView.tintColor = UIColor.Custom.green
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Determine the total height of the pin image and the label
        let totalHeight = pinImageView.frame.size.height + titleLabel.frame.size.height

        // Set the frame of the annotation view
        self.frame.size = CGSize(width: max(pinImageView.frame.size.width, titleLabel.frame.size.width),
                                 height: totalHeight)

        // Adjust the positions
        pinImageView.frame.origin.y = 0
        titleLabel.frame.origin.y = pinImageView.frame.size.height

        // Center the subviews horizontally
        pinImageView.center.x = self.frame.size.width / 2
        titleLabel.center.x = self.frame.size.width / 2
    }
}


class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var isPremium: Bool

    init(name: String, coordinate: CLLocationCoordinate2D, isPremium: Bool) {
        self.title = name
        self.coordinate = coordinate
        self.isPremium = isPremium
        super.init()
    }
}
