//
//  CircleAvatarView.swift
//  welbe
//
//  Created by Ben Norris on 10/9/15.
//  Copyright © 2015 O.C. Tanner Corporation. All rights reserved.
//

//import Kingfisher
import UIKit


@IBDesignable open class CircleAvatarView: UIView {

    // MARK: - Properties

    fileprivate let initialsLabel = UILabel()
    fileprivate let imageView = UIImageView()
    fileprivate let margin: CGFloat = 2.0
    fileprivate var fullName: String?
    fileprivate var tapGestureRecognizer = UITapGestureRecognizer()


    // MARK: Inspectables

    @IBInspectable open var borderColor: UIColor = UIColor.white {
        didSet {
            updateColors()
        }
    }

    @IBInspectable open var innerBackgroundColor: UIColor = UIColor.grayOne {
        didSet {
            updateColors()
        }
    }

    @IBInspectable open var borderWidth: CGFloat = 0.0 {
        didSet {
            updateBorder()
        }
    }

    @IBInspectable open var isTappable: Bool = false {
        didSet {
            updateGestureRecognizers()
        }
    }


    // MARK: - Public Properties

    open var initialsFont = UIFont.systemFont(ofSize: 14)
    open var tapped: (() -> Void)? = nil
    open var smallInitalsFont = UIFont.systemFont(ofSize: 12)
    open var textColor: UIColor? = nil {
        didSet {
            updateColors()
        }
    }


    // MARK: - Initialization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }


    // MARK: - Public API

    func reset() {
        imageView.image = nil
        initialsLabel.text = nil
    }

    fileprivate func update(_ firstName: String, lastName: String, avatarURL: URL?) {
        configureInitials(firstName, lastName: lastName)
//        imageView.kf.setImage(with: avatarURL, placeholder: nil, options: [.keepCurrentImageWhileLoading], progressBlock: nil, completionHandler: log.kfCompletion())
    }

    func update(_ fullName: String, avatarURL: URL?) {
        self.fullName = fullName
        let names = fullName.components(separatedBy: " ")
        if names.count > 1 {
            update(names[0], lastName: names[1], avatarURL: avatarURL)
        } else {
            update(names[0], lastName: "", avatarURL: avatarURL)
        }
    }


    // MARK: - Customized view methods

    override open func prepareForInterfaceBuilder() {
        initialsLabel.text = "BN"
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        let minSideSize = min(frame.size.width, frame.size.height)
        layer.cornerRadius = minSideSize / 2.0
        if minSideSize <= 100 {
            initialsLabel.font = smallInitalsFont.withSize(minSideSize / 2.5)
        } else {
            initialsLabel.font = initialsFont.withSize(minSideSize / 2.5)
        }
    }

}


// MARK: - Private methods

private extension CircleAvatarView {

    func configureViews() {
        updateColors()
        updateBorder()
        updateGestureRecognizers()

        clipsToBounds = true

        let views = ["initialsLabel": initialsLabel, "imageView": imageView]
        let metrics = ["margin": margin]

        initialsLabel.translatesAutoresizingMaskIntoConstraints = false
        initialsLabel.textAlignment = .center
        addSubview(initialsLabel)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[initialsLabel]-(margin)-|", options: [], metrics: metrics, views: views))
        addConstraint(NSLayoutConstraint(item: initialsLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))

        // Add image as an overlay to hide initials once it's been downloaded
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]|", options: [], metrics: metrics, views: views))

    }

    @objc func tapped(_: UIGestureRecognizer) {
        tapped?()
    }

    func updateColors() {
        backgroundColor = innerBackgroundColor
        layer.borderColor = borderColor.cgColor
        initialsLabel.textColor = textColor ?? borderColor
    }

    func updateBorder() {
        layer.borderWidth = borderWidth
    }

    func updateGestureRecognizers() {
        gestureRecognizers?.removeAll()
        if isTappable {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
            tapGestureRecognizer.cancelsTouchesInView = true
            addGestureRecognizer(tapGestureRecognizer)
        }
    }

    func configureInitials(_ firstName: String, lastName: String) {
        initialsLabel.text = initials(firstName, lastName: lastName)

        imageView.image = nil
    }

    func initials(_ firstName: String, lastName: String) -> String {
        var initialsString = String()
        if let initial = firstName.first {
            initialsString += String(initial)
        }
        if let initial = lastName.first {
            initialsString += String(initial)
        }
        return initialsString.uppercased()
    }

}
