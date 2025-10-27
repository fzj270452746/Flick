//
//  CrucibleArenaController.swift
//  Flick
//
//  Created by Zhao on 2025/10/21.
//

import UIKit

enum ObsidianGameMode {
    case nebula  // Mode 1: Single tile
    case cosmos  // Mode 2: Multiple tiles
    
    var runicName: String {
        switch self {
        case .nebula: return "Nebula Mode"
        case .cosmos: return "Cosmos Mode"
        }
    }
}

class CrucibleArenaController: UIViewController {
    
    // MARK: - Properties
    private var etherealBackground: UIImageView!
    private var obsidianOverlay: UIView!
    private var returnPortal: UIButton!
    private var hintOracle: UIButton!
    private var zenithScoreLabel: UILabel!
    private var ephemeralTimerLabel: UILabel!
    private var tesseraTableView: UITableView!
    private var verdictFeedbackLabel: UILabel!
    
    private var currentMode: ObsidianGameMode
    private var zenithScore: Int = 0
    private var tesseraDataArray: [TesseraEssence] = []
    private var ephemeralStartTime: Date?
    private var chronometer: Timer?
    private var isValueRevealed: Bool = false
    
    private let allTiles: [FlickTuModel] = [
        flickTuwan1, flickTuwan2, flickTuwan3, flickTuwan4, flickTuwan5,
        flickTuwan6, flickTuwan7, flickTuwan8, flickTuwan9,
        flickTutong1, flickTutong2, flickTutong3, flickTutong4, flickTutong5,
        flickTutong6, flickTutong7, flickTutong8, flickTutong9,
        flickTutiao1, flickTutiao2, flickTutiao3, flickTutiao4, flickTutiao5,
        flickTutiao6, flickTutiao7, flickTutiao8, flickTutiao9
    ]
    
    // MARK: - Initialization
    init(mode: ObsidianGameMode) {
        self.currentMode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forgeInterface()
        initiateGameSequence()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manifestInitialGuidance()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chronometer?.invalidate()
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
        
        // Hint button
        hintOracle = UIButton(type: .system)
        hintOracle.setTitle("💡 Hint", for: .normal)
        hintOracle.setTitleColor(.etherealWhite, for: .normal)
        hintOracle.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        hintOracle.backgroundColor = UIColor(red: 0.9, green: 0.6, blue: 0.2, alpha: 0.9)
        hintOracle.transmuteToCapsule(cornerRadius: 20)
        hintOracle.applyEtherealShadow(radius: 5, opacity: 0.3)
        hintOracle.addTarget(self, action: #selector(hintOracleTapped), for: .touchUpInside)
        view.addSubview(hintOracle)
        
        // Score label
        zenithScoreLabel = UILabel.scribeArcaneText(text: "Score: 0", fontSize: 24, color: .celestialGlow, isBold: true)
        zenithScoreLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        zenithScoreLabel.layer.cornerRadius = 20
        zenithScoreLabel.layer.masksToBounds = true
        view.addSubview(zenithScoreLabel)
        
        // Timer label
        ephemeralTimerLabel = UILabel.scribeArcaneText(text: "⏱ 00:00", fontSize: 18, color: .etherealWhite, isBold: false)
        ephemeralTimerLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        ephemeralTimerLabel.layer.cornerRadius = 18
        ephemeralTimerLabel.layer.masksToBounds = true
        view.addSubview(ephemeralTimerLabel)
        
        // TableView
        tesseraTableView = UITableView(frame: .zero, style: .plain)
        tesseraTableView.backgroundColor = .clear
        tesseraTableView.separatorStyle = .none
        tesseraTableView.delegate = self
        tesseraTableView.dataSource = self
        tesseraTableView.register(TesseraVortexCell.self, forCellReuseIdentifier: TesseraVortexCell.arcaneIdentifier)
        tesseraTableView.showsVerticalScrollIndicator = false
        view.addSubview(tesseraTableView)
        
        // Feedback label
        verdictFeedbackLabel = UILabel.scribeArcaneText(text: "", fontSize: 28, color: .white, isBold: true)
        verdictFeedbackLabel.alpha = 0
        view.addSubview(verdictFeedbackLabel)
        
        invokeConstraints()
    }
    
    private func invokeConstraints() {
        returnPortal.translatesAutoresizingMaskIntoConstraints = false
        hintOracle.translatesAutoresizingMaskIntoConstraints = false
        zenithScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        ephemeralTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        tesseraTableView.translatesAutoresizingMaskIntoConstraints = false
        verdictFeedbackLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            returnPortal.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            returnPortal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            returnPortal.widthAnchor.constraint(equalToConstant: 100),
            returnPortal.heightAnchor.constraint(equalToConstant: 40),
            
            hintOracle.topAnchor.constraint(equalTo: returnPortal.bottomAnchor, constant: 12),
            hintOracle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            hintOracle.widthAnchor.constraint(equalToConstant: 100),
            hintOracle.heightAnchor.constraint(equalToConstant: 40),
            
            zenithScoreLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            zenithScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            zenithScoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
            zenithScoreLabel.heightAnchor.constraint(equalToConstant: 40),
            
            ephemeralTimerLabel.topAnchor.constraint(equalTo: zenithScoreLabel.bottomAnchor, constant: 12),
            ephemeralTimerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            ephemeralTimerLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            ephemeralTimerLabel.heightAnchor.constraint(equalToConstant: 36),
            
            tesseraTableView.topAnchor.constraint(equalTo: ephemeralTimerLabel.bottomAnchor, constant: 20),
            tesseraTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tesseraTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tesseraTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            
            verdictFeedbackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verdictFeedbackLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Game Logic
    private func initiateGameSequence() {
        ephemeralStartTime = Date()
        chronometer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateChronometer()
        }
        
        conjureTesseraData()
        tesseraTableView.reloadData()
    }
    
    private func conjureTesseraData() {
        tesseraDataArray.removeAll()
        
        let count = currentMode == .nebula ? 5 : 4
        
        for _ in 0..<count {
            if currentMode == .nebula {
                // Single tile per cell
                let tile = allTiles.randomElement()!
                let essence = TesseraEssence(obsidianTiles: [tile], cumulativeValue: tile.flickFaceValue ?? 0, isMaximum: false)
                tesseraDataArray.append(essence)
            } else {
                // Multiple tiles (1-4) per cell
                let tileCount = Int.random(in: 1...4)
                var tiles: [FlickTuModel] = []
                var totalValue = 0
                
                for _ in 0..<tileCount {
                    let tile = allTiles.randomElement()!
                    tiles.append(tile)
                    totalValue += tile.flickFaceValue ?? 0
                }
                
                let essence = TesseraEssence(obsidianTiles: tiles, cumulativeValue: totalValue, isMaximum: false)
                tesseraDataArray.append(essence)
            }
        }
        
        // Mark the maximum value
        if let maxValue = tesseraDataArray.max(by: { $0.cumulativeValue < $1.cumulativeValue })?.cumulativeValue {
            for i in 0..<tesseraDataArray.count {
                if tesseraDataArray[i].cumulativeValue == maxValue {
                    tesseraDataArray[i] = TesseraEssence(
                        obsidianTiles: tesseraDataArray[i].obsidianTiles,
                        cumulativeValue: tesseraDataArray[i].cumulativeValue,
                        isMaximum: true
                    )
                    break
                }
            }
        }
    }
    
    private func updateChronometer() {
        guard let startTime = ephemeralStartTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        ephemeralTimerLabel.text = String(format: "⏱ %02d:%02d", minutes, seconds)
    }
    
    private func evaluateVerdict(for index: Int) {
        let selectedEssence = tesseraDataArray[index]
        let isCorrect = selectedEssence.isMaximum
        
        // Calculate score
        let reward = ZenithOracle.computeVerdictReward(for: currentMode.runicName, isCorrect: isCorrect)
        zenithScore = max(0, zenithScore + reward)
        
        // Update UI
        zenithScoreLabel.text = "Score: \(zenithScore)"
        zenithScoreLabel.invokeSpringAnimation()
        
        // Show feedback
        manifestVerdict(isCorrect: isCorrect)
        
        // Remove the swiped cell and add new one
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.tesseraDataArray.remove(at: index)
            self?.conjureSingleTessera()
            self?.tesseraTableView.reloadData()
        }
    }
    
    private func conjureSingleTessera() {
        if currentMode == .nebula {
            let tile = allTiles.randomElement()!
            let essence = TesseraEssence(obsidianTiles: [tile], cumulativeValue: tile.flickFaceValue ?? 0, isMaximum: false)
            tesseraDataArray.append(essence)
        } else {
            let tileCount = Int.random(in: 1...4)
            var tiles: [FlickTuModel] = []
            var totalValue = 0
            
            for _ in 0..<tileCount {
                let tile = allTiles.randomElement()!
                tiles.append(tile)
                totalValue += tile.flickFaceValue ?? 0
            }
            
            let essence = TesseraEssence(obsidianTiles: tiles, cumulativeValue: totalValue, isMaximum: false)
            tesseraDataArray.append(essence)
        }
        
        // Re-mark maximum
        if let maxValue = tesseraDataArray.max(by: { $0.cumulativeValue < $1.cumulativeValue })?.cumulativeValue {
            for i in 0..<tesseraDataArray.count {
                tesseraDataArray[i] = TesseraEssence(
                    obsidianTiles: tesseraDataArray[i].obsidianTiles,
                    cumulativeValue: tesseraDataArray[i].cumulativeValue,
                    isMaximum: tesseraDataArray[i].cumulativeValue == maxValue
                )
            }
        }
    }
    
    private func manifestVerdict(isCorrect: Bool) {
        verdictFeedbackLabel.text = isCorrect ? "✓ Correct!" : "✗ Wrong!"
        verdictFeedbackLabel.textColor = isCorrect ? .verdantSuccess : .crimsonFailure
        verdictFeedbackLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.verdictFeedbackLabel.alpha = 1.0
            self.verdictFeedbackLabel.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.5, animations: {
                self.verdictFeedbackLabel.alpha = 0
            })
        }
    }
    
    // MARK: - Initial Guidance
    private func manifestInitialGuidance() {
        let guidanceKey = "hasShownGameGuidance_\(currentMode.runicName)"
        
        // Only show once per game mode
        if UserDefaults.standard.bool(forKey: guidanceKey) {
            return
        }
        
        let alertTitle = "How to Play"
        let alertMessage = currentMode == .nebula 
            ? "Find the highest tile.\nSwipe left to eliminate it!"
            : "Find the highest sum.\nSwipe left to eliminate it!"
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Got it!", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: guidanceKey)
        }
        
        alert.addAction(okAction)
        
        // Style the alert
        if let titleFont = UIFont(name: "HelveticaNeue-Bold", size: 18) {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.black
            ]
            let titleString = NSAttributedString(string: alertTitle, attributes: titleAttributes)
            alert.setValue(titleString, forKey: "attributedTitle")
        }
        
        if let messageFont = UIFont(name: "HelveticaNeue", size: 15) {
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .font: messageFont,
                .foregroundColor: UIColor.darkGray
            ]
            let messageString = NSAttributedString(string: alertMessage, attributes: messageAttributes)
            alert.setValue(messageString, forKey: "attributedMessage")
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    @objc private func returnPortalTapped() {
        chronometer?.invalidate()
        
        // Save record
        if zenithScore > 0, let startTime = ephemeralStartTime {
            let duration = Date().timeIntervalSince(startTime)
            let record = ArcaneRecord(
                zenithScore: zenithScore,
                epochTimestamp: Date(),
                obsidianMode: currentMode.runicName,
                ephemeralDuration: duration
            )
            ChronicleVault.sovereign.inscribeRecord(record)
        }
        
        dismiss(animated: true)
    }
    
    @objc private func hintOracleTapped() {
        isValueRevealed = !isValueRevealed
        
        // Update button appearance
        if isValueRevealed {
            hintOracle.setTitle("🔒 Hide", for: .normal)
            hintOracle.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
        } else {
            hintOracle.setTitle("💡 Hint", for: .normal)
            hintOracle.backgroundColor = UIColor(red: 0.9, green: 0.6, blue: 0.2, alpha: 0.9)
        }
        
        hintOracle.invokeSpringAnimation()
        
        // Reload table to update all cells
        tesseraTableView.reloadData()
    }
}

// MARK: - TableView DataSource & Delegate
extension CrucibleArenaController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tesseraDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TesseraVortexCell.arcaneIdentifier, for: indexPath) as! TesseraVortexCell
        cell.manifestData(tesseraDataArray[indexPath.row], showValue: isValueRevealed)
        // Bridge custom swipe deletion back to controller logic
        cell.onObliterationRequested = { [weak self] in
            guard let self = self else { return }
            self.evaluateVerdict(for: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    // Disable system trailing swipe to avoid conflicting visuals; use custom swipe in cell instead
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    // No system swipe styling since we use custom swipe in the cell
    
    private func createSwipeActionImage() -> UIImage? {
        let size = CGSize(width: 100, height: 110)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            // Multi-layer gradient background
            let colors = [
                UIColor(red: 1.0, green: 0.2, blue: 0.4, alpha: 1.0).cgColor,
                UIColor(red: 0.9, green: 0.1, blue: 0.6, alpha: 1.0).cgColor,
                UIColor(red: 0.7, green: 0.0, blue: 0.8, alpha: 1.0).cgColor
            ]
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: colors as CFArray,
                                     locations: [0.0, 0.5, 1.0])!
            context.cgContext.drawLinearGradient(gradient,
                                                 start: CGPoint(x: 0, y: 0),
                                                 end: CGPoint(x: size.width, y: size.height),
                                                 options: [])
            
            // Add glow effect around edges
            let glowPath = UIBezierPath(roundedRect: rect.insetBy(dx: 5, dy: 5), cornerRadius: 10)
            context.cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.5).cgColor)
            context.cgContext.setLineWidth(3)
            context.cgContext.addPath(glowPath.cgPath)
            context.cgContext.strokePath()
            
            // Draw main icon with shadow
            context.cgContext.saveGState()
            context.cgContext.setShadow(offset: CGSize(width: 0, height: 2),
                                       blur: 5,
                                       color: UIColor.black.withAlphaComponent(0.5).cgColor)
            
            let iconSize: CGFloat = 50
            let iconRect = CGRect(x: (size.width - iconSize) / 2,
                                 y: (size.height - iconSize) / 2 - 10,
                                 width: iconSize,
                                 height: iconSize)
            
            if let sparkleImage = UIImage(systemName: "sparkles",
                                         withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)) {
                UIColor.white.setFill()
                // Draw rounded-corner icon by clipping to rounded rect
                let rounded = UIBezierPath(roundedRect: iconRect, cornerRadius: 12)
                rounded.addClip()
                sparkleImage.withTintColor(.white, renderingMode: .alwaysTemplate).draw(in: iconRect)
            }
            context.cgContext.restoreGState()
            
            // Add "DELETE" text
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.white,
                .kern: 1.5
            ]
            let text = "DELETE"
            let textSize = text.size(withAttributes: textAttributes)
            let textRect = CGRect(x: (size.width - textSize.width) / 2,
                                 y: size.height - textSize.height - 10,
                                 width: textSize.width,
                                 height: textSize.height)
            text.draw(in: textRect, withAttributes: textAttributes)
        }
    }

    // Recursively find and style internal swipe action views created by the system
    private func styleSwipeActionViews(for cell: UITableViewCell) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.applyGradientRecursively(in: cell)
        }
    }

    private func applyGradientRecursively(in view: UIView) {
        for sub in view.subviews {
            let className = String(describing: type(of: sub))
            if className.contains("UISwipeActionStandardButton") || className.contains("UISwipeActionPullView") {
                self.decorateSwipeBackground(for: sub)
            }
            applyGradientRecursively(in: sub)
        }
    }

    private func decorateSwipeBackground(for container: UIView) {
        container.layer.cornerRadius = 14
        container.layer.masksToBounds = true
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        // Remove previous gradient if any
        container.layer.sublayers?.removeAll(where: { $0.name == "swipeGradientLayer" })
        
        let gradient = CAGradientLayer()
        gradient.name = "swipeGradientLayer"
        gradient.colors = [
            UIColor(red: 1.0, green: 0.2, blue: 0.4, alpha: 1.0).cgColor,
            UIColor(red: 0.9, green: 0.1, blue: 0.6, alpha: 1.0).cgColor,
            UIColor(red: 0.7, green: 0.0, blue: 0.8, alpha: 1.0).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = container.bounds
        gradient.cornerRadius = 14
        container.layer.insertSublayer(gradient, at: 0)

        // Round internal image if present
        if let imageView = container.subviews.compactMap({ $0 as? UIImageView }).first {
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        }
    }
    
    private func conjureObliterationAnimation(at indexPath: IndexPath, in tableView: UITableView, completion: @escaping () -> Void) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            completion()
            return
        }
        
        // Clean up any existing particle containers and star views first
        cell.contentView.subviews.forEach { subview in
            if subview.tag == 9999 || subview.tag == 8888 {
                subview.removeFromSuperview()
            }
        }
        
        // Create multiple particle emitters with different colors
        let colors: [(UIColor, CGFloat)] = [
            (.celestialGlow, 0.0),           // Gold particles
            (.crimsonFailure, 0.3),          // Red particles
            (.verdantSuccess, 0.6),          // Green particles
            (UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0), 0.9)  // Orange particles
        ]
        
        for (color, delay) in colors {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay * 0.1) {
                self.createParticleExplosion(in: cell, color: color)
            }
        }
        
        // Create star burst effect
        createStarBurst(in: cell)
        
        // Flash animation with multiple pulses
        var flashCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true) { timer in
            flashCount += 1
            if flashCount > 3 {
                timer.invalidate()
                return
            }
            
            UIView.animate(withDuration: 0.08, animations: {
                cell.backgroundColor = UIColor.celestialGlow.withAlphaComponent(0.5)
            }) { _ in
                UIView.animate(withDuration: 0.08) {
                    cell.backgroundColor = .clear
                }
            }
        }
        
        // Scale and fade out animation
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).rotated(by: 0.1)
            cell.alpha = 0
        }) { _ in
            cell.transform = .identity
            cell.alpha = 1.0
            completion()
        }
    }
    
    private func createParticleExplosion(in cell: UITableViewCell, color: UIColor) {
        // Create a container view for particles to prevent duplication
        let particleContainer = UIView(frame: cell.contentView.bounds)
        particleContainer.backgroundColor = .clear
        particleContainer.isUserInteractionEnabled = false
        particleContainer.tag = 9999  // Tag to identify and remove later
        cell.contentView.addSubview(particleContainer)
        
        let particleLayer = CAEmitterLayer()
        // Position at center of the container
        particleLayer.emitterPosition = CGPoint(x: particleContainer.bounds.width / 2, 
                                               y: particleContainer.bounds.height / 2)
        particleLayer.emitterShape = .point
        particleLayer.renderMode = .additive
        particleLayer.emitterSize = CGSize(width: 1, height: 1)
        
        // Create multiple particle cells for variety
        var particles: [CAEmitterCell] = []
        
        // Main particles
        let mainParticle = CAEmitterCell()
        mainParticle.birthRate = 80
        mainParticle.lifetime = 1.2
        mainParticle.lifetimeRange = 0.4
        mainParticle.velocity = 180
        mainParticle.velocityRange = 80
        mainParticle.emissionRange = .pi * 2
        mainParticle.spin = 2
        mainParticle.spinRange = 4
        mainParticle.scale = 0.12
        mainParticle.scaleRange = 0.08
        mainParticle.scaleSpeed = -0.1
        mainParticle.alphaSpeed = -0.8
        mainParticle.color = color.cgColor
        mainParticle.contents = createCircleParticle(size: 20, color: color).cgImage
        particles.append(mainParticle)
        
        // Sparkle particles
        let sparkle = CAEmitterCell()
        sparkle.birthRate = 40
        sparkle.lifetime = 0.8
        sparkle.velocity = 120
        sparkle.velocityRange = 60
        sparkle.emissionRange = .pi * 2
        sparkle.scale = 0.06
        sparkle.scaleRange = 0.04
        sparkle.alphaSpeed = -1.2
        sparkle.color = UIColor.white.cgColor
        sparkle.contents = createStarParticle(size: 20).cgImage
        particles.append(sparkle)
        
        particleLayer.emitterCells = particles
        particleContainer.layer.addSublayer(particleLayer)
        
        // Stop emitting after a short time and remove
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            particleLayer.birthRate = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            particleLayer.removeFromSuperlayer()
            particleContainer.removeFromSuperview()
        }
    }
    
    private func createStarBurst(in cell: UITableViewCell) {
        let starCount = 8
        let centerX = cell.contentView.bounds.width / 2
        let centerY = cell.contentView.bounds.height / 2
        
        for i in 0..<starCount {
            let angle = (CGFloat(i) / CGFloat(starCount)) * .pi * 2
            let starView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            starView.center = CGPoint(x: centerX, y: centerY)
            starView.tag = 8888  // Tag for star views
            
            // Add star icon
            let starLabel = UILabel(frame: starView.bounds)
            starLabel.text = "✦"
            starLabel.font = UIFont.systemFont(ofSize: 22)
            starLabel.textColor = .celestialGlow
            starLabel.textAlignment = .center
            starLabel.layer.shadowColor = UIColor.celestialGlow.cgColor
            starLabel.layer.shadowRadius = 5
            starLabel.layer.shadowOpacity = 0.8
            starLabel.layer.shadowOffset = .zero
            starView.addSubview(starLabel)
            
            cell.contentView.addSubview(starView)
            
            let distance: CGFloat = 100
            let endX = centerX + cos(angle) * distance
            let endY = centerY + sin(angle) * distance
            
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
                starView.center = CGPoint(x: endX, y: endY)
                starView.alpha = 0
                starView.transform = CGAffineTransform(scaleX: 2.5, y: 2.5).rotated(by: .pi)
            }) { _ in
                starView.removeFromSuperview()
            }
        }
    }
    
    private func createCircleParticle(size: CGFloat, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            // Draw gradient circle
            let rect = CGRect(x: 0, y: 0, width: size, height: size)
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                     colors: [color.cgColor, color.withAlphaComponent(0.3).cgColor] as CFArray,
                                     locations: [0.0, 1.0])!
            
            context.cgContext.drawRadialGradient(gradient,
                                                startCenter: CGPoint(x: size/2, y: size/2),
                                                startRadius: 0,
                                                endCenter: CGPoint(x: size/2, y: size/2),
                                                endRadius: size/2,
                                                options: [])
        }
    }
    
    private func createStarParticle(size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { context in
            UIColor.white.setFill()
            
            // Draw 4-point star
            let path = UIBezierPath()
            let center = CGPoint(x: size/2, y: size/2)
            let outerRadius = size/2
            let innerRadius = size/4
            
            for i in 0..<8 {
                let angle = CGFloat(i) * .pi / 4 - .pi / 2
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                let x = center.x + cos(angle) * radius
                let y = center.y + sin(angle) * radius
                
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.close()
            path.fill()
        }
    }
}

