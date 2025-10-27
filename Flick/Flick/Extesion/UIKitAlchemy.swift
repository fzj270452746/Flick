//
//  UIKitAlchemy.swift
//  Flick
//
//  Created by Zhao on 2025/10/21.
//

import UIKit

// MARK: - UIColor Extension
extension UIColor {
    static let obsidianOverlay = UIColor(white: 0, alpha: 0.65)
    static let celestialGlow = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
    static let verdantSuccess = UIColor(red: 0.3, green: 0.85, blue: 0.4, alpha: 1.0)
    static let crimsonFailure = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
    static let etherealWhite = UIColor(white: 1.0, alpha: 0.95)
    static let mysticBlue = UIColor(red: 0.2, green: 0.5, blue: 0.9, alpha: 1.0)
}

// MARK: - UIView Extension
extension UIView {
    func applyEtherealShadow(radius: CGFloat = 8, opacity: Float = 0.3, offset: CGSize = CGSize(width: 0, height: 4)) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func transmuteToCapsule(cornerRadius: CGFloat? = nil) {
        if let radius = cornerRadius {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = bounds.height / 2
        }
        layer.masksToBounds = true
    }
    
    func invokeSpringAnimation(scale: CGFloat = 0.95, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                self.transform = .identity
            }) { _ in
                completion?()
            }
        }
    }
    
    func conjurePulseAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.6
        animation.fromValue = 1.0
        animation.toValue = 1.1
        animation.autoreverses = true
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "pulse")
    }
    
    func banishAllAnimations() {
        layer.removeAllAnimations()
    }
}

// MARK: - UIButton Extension
extension UIButton {
    static func forgeArcaneButton(title: String, backgroundColor: UIColor, titleColor: UIColor = .white) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.transmuteToCapsule(cornerRadius: 25)
        button.applyEtherealShadow()
        return button
    }
    
    static func manifestReturnPortal() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("← Back", for: .normal)
        button.setTitleColor(.etherealWhite, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(white: 0, alpha: 0.4)
        button.transmuteToCapsule(cornerRadius: 20)
        button.applyEtherealShadow(radius: 5, opacity: 0.2)
        return button
    }
}

// MARK: - UILabel Extension
extension UILabel {
    static func scribeArcaneText(text: String, fontSize: CGFloat, color: UIColor = .white, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = isBold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
}

// MARK: - Gradient Layer Helper
class GradientAlchemy {
    static func conjureGradientLayer(colors: [UIColor], frame: CGRect) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = frame
        return gradientLayer
    }
}

