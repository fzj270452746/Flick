//
//  TesseraVortexCell.swift
//  Flick
//
//  Created by Zhao on 2025/10/21.
//

import UIKit

// Tessera Data Model for Cell
struct TesseraEssence {
    let obsidianTiles: [FlickTuModel]  // Mahjong tiles
    let cumulativeValue: Int  // Total value
    let isMaximum: Bool  // Is this the maximum value
}

class TesseraVortexCell: UITableViewCell {
    
    static let arcaneIdentifier = "TesseraVortexCell"
    
    private var containerVessel: UIView!
    private var tileScrollChamber: UIScrollView!
    private var valueRuneLabel: UILabel!
    private var obliterationPortal: UIView!
    private var obliterationIcon: UILabel!
    
    // Custom swipe components
    private var swipeBackdropView: UIView!
    private var swipeGradient: CAGradientLayer?
    private var swipeIconView: UIImageView!
    private var swipeTextLabel: UILabel!
    private var panRecognizer: UIPanGestureRecognizer!
    private var currentTranslationX: CGFloat = 0
    
    // Callback for deletion request
    var onObliterationRequested: (() -> Void)?
    
    private var tesseraData: TesseraEssence?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        forgeInterface()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func forgeInterface() {
        // Container
        containerVessel = UIView()
        containerVessel.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        containerVessel.layer.cornerRadius = 16
        containerVessel.layer.borderWidth = 2
        containerVessel.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        containerVessel.applyEtherealShadow(radius: 6, opacity: 0.25)
        contentView.addSubview(containerVessel)
        
        // Backdrop for custom swipe (behind container)
        swipeBackdropView = UIView()
        swipeBackdropView.isUserInteractionEnabled = false
        swipeBackdropView.layer.cornerRadius = 16
        swipeBackdropView.layer.masksToBounds = true
        swipeBackdropView.layer.borderWidth = 2
        swipeBackdropView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        contentView.insertSubview(swipeBackdropView, belowSubview: containerVessel)
        swipeBackdropView.alpha = 0.0
        swipeBackdropView.isHidden = true
        
        // Gradient for backdrop
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 1.0, green: 0.2, blue: 0.4, alpha: 1.0).cgColor,
            UIColor(red: 0.9, green: 0.1, blue: 0.6, alpha: 1.0).cgColor,
            UIColor(red: 0.7, green: 0.0, blue: 0.8, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.masksToBounds = true
        gradient.needsDisplayOnBoundsChange = true
        swipeBackdropView.layer.addSublayer(gradient)
        swipeGradient = gradient
        
        // Icon (rounded)
        swipeIconView = UIImageView(image: UIImage(systemName: "sparkles"))
        swipeIconView.tintColor = .white
        swipeIconView.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        swipeIconView.layer.cornerRadius = 12
        swipeIconView.clipsToBounds = true
        swipeBackdropView.addSubview(swipeIconView)
        
        // Text
        swipeTextLabel = UILabel()
        swipeTextLabel.text = "DELETE"
        swipeTextLabel.font = UIFont.boldSystemFont(ofSize: 14)
        swipeTextLabel.textColor = .white
        swipeTextLabel.textAlignment = .center
        swipeBackdropView.addSubview(swipeTextLabel)
        
        // Tile scroll view
        tileScrollChamber = UIScrollView()
        tileScrollChamber.showsHorizontalScrollIndicator = false
        tileScrollChamber.backgroundColor = .clear
        containerVessel.addSubview(tileScrollChamber)
        
        // Value label
        valueRuneLabel = UILabel()
        valueRuneLabel.textColor = .celestialGlow
        valueRuneLabel.font = UIFont.boldSystemFont(ofSize: 20)
        valueRuneLabel.textAlignment = .center
        valueRuneLabel.backgroundColor = UIColor(white: 0, alpha: 0.4)
        valueRuneLabel.layer.cornerRadius = 18
        valueRuneLabel.layer.masksToBounds = true
        containerVessel.addSubview(valueRuneLabel)
        
        invokeConstraints()
        configureSwipeGesture()
    }
    
    private func invokeConstraints() {
        containerVessel.translatesAutoresizingMaskIntoConstraints = false
        tileScrollChamber.translatesAutoresizingMaskIntoConstraints = false
        valueRuneLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerVessel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerVessel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerVessel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerVessel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerVessel.heightAnchor.constraint(equalToConstant: 94),
            
            tileScrollChamber.topAnchor.constraint(equalTo: containerVessel.topAnchor, constant: 12),
            tileScrollChamber.leadingAnchor.constraint(equalTo: containerVessel.leadingAnchor, constant: 12),
            tileScrollChamber.bottomAnchor.constraint(equalTo: containerVessel.bottomAnchor, constant: -12),
            tileScrollChamber.trailingAnchor.constraint(equalTo: valueRuneLabel.leadingAnchor, constant: -12),
            
            valueRuneLabel.trailingAnchor.constraint(equalTo: containerVessel.trailingAnchor, constant: -12),
            valueRuneLabel.centerYAnchor.constraint(equalTo: containerVessel.centerYAnchor),
            valueRuneLabel.widthAnchor.constraint(equalToConstant: 70),
            valueRuneLabel.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // Match backdrop frame to container frame
        layoutIfNeeded()
        updateSwipeBackdropLayout()
    }
    
    func manifestData(_ data: TesseraEssence, showValue: Bool = false) {
        self.tesseraData = data
        resetSwipePosition(animated: false)
        updateSwipeBackdropLayout()
        
        // Clear previous tiles
        tileScrollChamber.subviews.forEach { $0.removeFromSuperview() }
        
        // Add tiles - smaller size
        var accumulatedOffset: CGFloat = 0
        let tileSpacing: CGFloat = 8
        let tileHeight: CGFloat = 70  // Reduced from 96
        let tileWidth: CGFloat = 52   // Reduced from 70
        
        for (index, tile) in data.obsidianTiles.enumerated() {
            // Container for tile with border
            let tileContainer = UIView()
            tileContainer.frame = CGRect(x: accumulatedOffset, y: 0, width: tileWidth, height: tileHeight)
            tileContainer.backgroundColor = .clear
            tileContainer.layer.cornerRadius = 6
            tileContainer.layer.borderWidth = 2
            tileContainer.layer.borderColor = UIColor.black.cgColor
            tileContainer.layer.masksToBounds = true
            
            let tileImageView = UIImageView(image: tile.flickImage)
            tileImageView.contentMode = .scaleAspectFill
            tileImageView.frame = tileContainer.bounds
            tileImageView.layer.cornerRadius = 6
            tileImageView.layer.masksToBounds = true
            tileContainer.addSubview(tileImageView)
            
            // Add value label if showValue is true
            if showValue {
                let valueLabel = UILabel()
                valueLabel.text = "\(tile.flickFaceValue ?? 0)"
                valueLabel.font = UIFont.boldSystemFont(ofSize: 14)
                valueLabel.textColor = .white
                valueLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
                valueLabel.textAlignment = .center
                valueLabel.layer.cornerRadius = 10
                valueLabel.layer.masksToBounds = true
                valueLabel.frame = CGRect(x: tileWidth - 24, y: 4, width: 20, height: 20)
                tileContainer.addSubview(valueLabel)
            }
            
            tileContainer.applyEtherealShadow(radius: 4, opacity: 0.3)
            tileScrollChamber.addSubview(tileContainer)
            
            // Add subtle animation
            tileContainer.alpha = 0
            UIView.animate(withDuration: 0.3, delay: Double(index) * 0.1) {
                tileContainer.alpha = 1.0
            }
            
            accumulatedOffset += tileWidth + tileSpacing
        }
        
        tileScrollChamber.contentSize = CGSize(width: accumulatedOffset, height: tileHeight)
        
        // Set value - only show if showValue is true
        if showValue {
            valueRuneLabel.text = "Σ \(data.cumulativeValue)"
            valueRuneLabel.isHidden = false
        } else {
            valueRuneLabel.text = "Σ ?"
            valueRuneLabel.isHidden = false
        }
        
        // Highlight if maximum
        if data.isMaximum {
            containerVessel.layer.borderColor = UIColor.celestialGlow.cgColor
            if showValue {
                valueRuneLabel.conjurePulseAnimation()
            }
        } else {
            containerVessel.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
            valueRuneLabel.banishAllAnimations()
        }
    }
    
    // MARK: - Custom Swipe Handling
    private func configureSwipeGesture() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panRecognizer.maximumNumberOfTouches = 1
        containerVessel.addGestureRecognizer(panRecognizer)
        containerVessel.isUserInteractionEnabled = true
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: contentView)
        switch gesture.state {
        case .began, .changed:
            let dx = min(0, translation.x) // only left
            currentTranslationX = dx
            containerVessel.transform = CGAffineTransform(translationX: dx, y: 0)
            // Slight scale for feedback
            let progress = min(abs(dx) / 120.0, 1.0)
            containerVessel.layer.borderColor = UIColor.celestialGlow.withAlphaComponent(progress).cgColor
            if swipeBackdropView.isHidden {
                // Ensure correct size on first reveal
                self.contentView.layoutIfNeeded()
                self.updateSwipeBackdropLayout()
            }
            swipeBackdropView.isHidden = false
            swipeBackdropView.alpha = progress
        case .ended, .cancelled:
            let threshold: CGFloat = -100
            if currentTranslationX < threshold {
                triggerDeleteAnimation()
            } else {
                resetSwipePosition(animated: true)
            }
        default: break
        }
    }
    
    private func resetSwipePosition(animated: Bool) {
        let animations = {
            self.containerVessel.transform = .identity
            self.swipeBackdropView.alpha = 0.0
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: animations) { _ in
                self.swipeBackdropView.isHidden = true
            }
        } else {
            animations()
            self.swipeBackdropView.isHidden = true
        }
    }
    
    private func triggerDeleteAnimation() {
        // Haptic
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Particle in center
        playParticleBurst()
        
        // Slide out
        UIView.animate(withDuration: 0.22, delay: 0, options: .curveEaseIn, animations: {
            self.containerVessel.transform = CGAffineTransform(translationX: -self.contentView.bounds.width, y: 0)
            self.containerVessel.alpha = 0.2
        }) { _ in
            self.containerVessel.alpha = 1
            self.containerVessel.transform = .identity
            self.onObliterationRequested?()
        }
    }
    
    private func playParticleBurst() {
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: contentView.bounds.midX, y: contentView.bounds.midY)
        layer.emitterShape = .circle
        layer.emitterSize = CGSize(width: 6, height: 6)
        layer.renderMode = .additive
        
        let cell = CAEmitterCell()
        cell.birthRate = 220
        cell.lifetime = 0.8
        cell.velocity = 180
        cell.velocityRange = 80
        cell.emissionRange = .pi * 2
        cell.scale = 0.08
        cell.scaleRange = 0.05
        cell.alphaSpeed = -1.0
        cell.color = UIColor.celestialGlow.cgColor
        cell.contents = createDotImage(size: 16, color: .celestialGlow).cgImage
        layer.emitterCells = [cell]
        
        contentView.layer.addSublayer(layer)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { layer.birthRate = 0 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { layer.removeFromSuperlayer() }
    }
    
    private func createDotImage(size: CGFloat, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            color.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 0, y: 0, width: size, height: size))
        }
    }
    
    // Custom swipe action
    func conjureObliterationPortal() -> UIView {
        let portal = UIView()
        portal.backgroundColor = .crimsonFailure
        
        let iconLabel = UILabel()
        iconLabel.text = "✦"
        iconLabel.font = UIFont.systemFont(ofSize: 40)
        iconLabel.textColor = .white
        iconLabel.textAlignment = .center
        portal.addSubview(iconLabel)
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconLabel.centerXAnchor.constraint(equalTo: portal.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: portal.centerYAnchor)
        ])
        
        return portal
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueRuneLabel.banishAllAnimations()
        tileScrollChamber.subviews.forEach { $0.removeFromSuperview() }
        resetSwipePosition(animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSwipeBackdropLayout()
    }
    
    private func updateSwipeBackdropLayout() {
        swipeBackdropView.frame = containerVessel.frame
        swipeGradient?.frame = swipeBackdropView.bounds
        let iconSize: CGFloat = 44
        swipeIconView.frame = CGRect(x: swipeBackdropView.bounds.width - iconSize - 20,
                                     y: swipeBackdropView.bounds.midY - iconSize/2 - containerVessel.frame.minY - 10,
                                     width: iconSize,
                                     height: iconSize)
        swipeTextLabel.frame = CGRect(x: swipeBackdropView.bounds.width - 100,
                                      y: swipeBackdropView.bounds.height - 24,
                                      width: 80,
                                      height: 18)
    }
}

