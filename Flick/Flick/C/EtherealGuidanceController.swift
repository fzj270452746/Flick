//
//  EtherealGuidanceController.swift
//  Flick
//
//  Created by Zhao on 2025/10/21.
//

import UIKit

class EtherealGuidanceController: UIViewController {
    
    // MARK: - Properties
    private var etherealBackground: UIImageView!
    private var obsidianOverlay: UIView!
    private var returnPortal: UIButton!
    private var scrollChamber: UIScrollView!
    private var stackVessel: UIStackView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forgeInterface()
    }
    
    // MARK: - UI Setup
    private func forgeInterface() {
        // Background image
        etherealBackground = UIImageView(image: UIImage(named: "flickTu"))
        etherealBackground.contentMode = .scaleAspectFill
        etherealBackground.frame = view.bounds
        view.addSubview(etherealBackground)
        
        // Overlay with gradient
        obsidianOverlay = UIView()
        obsidianOverlay.frame = view.bounds
        let gradientLayer = GradientAlchemy.conjureGradientLayer(
            colors: [
                UIColor(red: 0.1, green: 0.05, blue: 0.2, alpha: 0.85),
                UIColor(red: 0.05, green: 0.1, blue: 0.25, alpha: 0.8)
            ],
            frame: view.bounds
        )
        obsidianOverlay.layer.addSublayer(gradientLayer)
        view.addSubview(obsidianOverlay)
        
        // Return button
        returnPortal = UIButton.manifestReturnPortal()
        returnPortal.addTarget(self, action: #selector(returnPortalTapped), for: .touchUpInside)
        view.addSubview(returnPortal)
        
        // Scroll view
        scrollChamber = UIScrollView()
        scrollChamber.showsVerticalScrollIndicator = false
        scrollChamber.showsHorizontalScrollIndicator = false
        scrollChamber.alwaysBounceVertical = true
        scrollChamber.alwaysBounceHorizontal = false
        view.addSubview(scrollChamber)
        
        // Stack view for content
        stackVessel = UIStackView()
        stackVessel.axis = .vertical
        stackVessel.alignment = .fill
        stackVessel.distribution = .equalSpacing
        stackVessel.spacing = 20
        scrollChamber.addSubview(stackVessel)
        
        createGuidanceContent()
        invokeConstraints()
    }
    
    private func invokeConstraints() {
        returnPortal.translatesAutoresizingMaskIntoConstraints = false
        scrollChamber.translatesAutoresizingMaskIntoConstraints = false
        stackVessel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            returnPortal.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            returnPortal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            returnPortal.widthAnchor.constraint(equalToConstant: 100),
            returnPortal.heightAnchor.constraint(equalToConstant: 40),
            
            scrollChamber.topAnchor.constraint(equalTo: returnPortal.bottomAnchor, constant: 20),
            scrollChamber.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollChamber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollChamber.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            
            stackVessel.topAnchor.constraint(equalTo: scrollChamber.topAnchor),
            stackVessel.leadingAnchor.constraint(equalTo: scrollChamber.leadingAnchor),
            stackVessel.trailingAnchor.constraint(equalTo: scrollChamber.trailingAnchor),
            stackVessel.bottomAnchor.constraint(equalTo: scrollChamber.bottomAnchor),
            stackVessel.widthAnchor.constraint(equalTo: scrollChamber.widthAnchor)
        ])
    }
    
    private func createGuidanceContent() {
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "How to Play"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 30)
        titleLabel.textColor = .celestialGlow
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        stackVessel.addArrangedSubview(titleLabel)
        
        // Add spacing
        stackVessel.addArrangedSubview(createSpacer(height: 10))
        
        // Introduction
        let introLabel = UILabel()
        introLabel.text = "Welcome to Mahjong Flick! Master the ancient tiles and test your quick thinking in two exciting game modes."
        introLabel.font = UIFont.systemFont(ofSize: 15)
        introLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
        introLabel.textAlignment = .center
        introLabel.numberOfLines = 0
        stackVessel.addArrangedSubview(introLabel)
        
        // Add spacing
        stackVessel.addArrangedSubview(createSpacer(height: 10))
        
        // Nebula Mode Section
        let nebulaContainer = createModeSection(
            title: "Nebula Mode",
            titleColor: .mysticBlue,
            description: "In Nebula Mode, each row displays a single mahjong tile.\n\nObjective: Swipe left to eliminate the tile with the HIGHEST value.\n\nScoring:\n• Correct choice: +10 points\n• Wrong choice: -5 points\n\nStrategy: Act quickly but carefully. The highest value tile will have a golden border to help guide you!"
        )
        stackVessel.addArrangedSubview(nebulaContainer)
        
        // Cosmos Mode Section
        let cosmosContainer = createModeSection(
            title: "✦ Cosmos Mode",
            titleColor: UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0),
            description: "In Cosmos Mode, each row displays 1-4 mahjong tiles.\n\nObjective: Swipe left to eliminate the row with the HIGHEST total sum.\n\nScoring:\n• Correct choice: +15 points\n• Wrong choice: -8 points\n\nStrategy: Calculate quickly! Add up the values and find the maximum sum. The Σ symbol shows each row's total."
        )
        stackVessel.addArrangedSubview(cosmosContainer)
        
        // General Tips
        let tipsContainer = createTipsSection()
        stackVessel.addArrangedSubview(tipsContainer)
        
        // Tile Values
        let valuesContainer = createValuesSection()
        stackVessel.addArrangedSubview(valuesContainer)
        
        // Bottom spacer
        stackVessel.addArrangedSubview(createSpacer(height: 20))
    }
    
    private func createModeSection(title: String, titleColor: UIColor, description: String) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = titleColor.cgColor
        container.applyEtherealShadow(radius: 6, opacity: 0.25)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(contentStack)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)
        
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        contentStack.addArrangedSubview(descLabel)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 250)
        ])
        
        return container
    }
    
    private func createTipsSection() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.verdantSuccess.cgColor
        container.applyEtherealShadow(radius: 6, opacity: 0.25)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(contentStack)
        
        let titleLabel = UILabel()
        titleLabel.text = "Pro Tips"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .verdantSuccess
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)
        
        let tipsText = """
        ✓ Your score can never go below 0
        
        ✓ Look for the glowing golden border - it indicates the maximum value!
        
        ✓ In Cosmos Mode, scroll horizontally to see all tiles in a row
        
        ✓ Your game time and score are recorded in Game Records
        
        ✓ Challenge yourself to beat your highest score!
        """
        
        let descLabel = UILabel()
        descLabel.text = tipsText
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        contentStack.addArrangedSubview(descLabel)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 250)
        ])
        
        return container
    }
    
    private func createValuesSection() -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        container.layer.cornerRadius = 16
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.celestialGlow.cgColor
        container.applyEtherealShadow(radius: 6, opacity: 0.25)
        
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(contentStack)
        
        let titleLabel = UILabel()
        titleLabel.text = "Tile Values"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .celestialGlow
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentStack.addArrangedSubview(titleLabel)
        
        let valuesText = """
        Each tile displays a number from 1 to 9.
        
        Three types of tiles:
        • Wan (Characters)
        • Tong (Dots)
        • Tiao (Bamboo)
        
        All tiles with the same number have equal value, regardless of type!
        """
        
        let descLabel = UILabel()
        descLabel.text = valuesText
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor(white: 1.0, alpha: 0.9)
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        contentStack.addArrangedSubview(descLabel)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        ])
        
        return container
    }
    
    private func createSpacer(height: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: height).isActive = true
        return spacer
    }
    
    // MARK: - Actions
    @objc private func returnPortalTapped() {
        dismiss(animated: true)
    }
}
