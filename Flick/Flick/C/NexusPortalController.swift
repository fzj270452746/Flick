
import UIKit
import Alamofire
import TaohuaJiudb

class NexusPortalController: UIViewController {
    
    // MARK: - Properties
    private var etherealBackground: UIImageView!
    private var obsidianOverlay: UIView!
    private var titleRuneLabel: UILabel!
    private var subtitleRuneLabel: UILabel!
    private var nebulaButton: UIButton!
    private var cosmosButton: UIButton!
    private var chroniclesButton: UIButton!
    private var guidanceButton: UIButton!
    private var zenithScoreLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forgeInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshZenithScore()
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        // Title
        titleRuneLabel = UILabel.scribeArcaneText(text: "Mahjong Flick", fontSize: 48, color: .celestialGlow, isBold: true)
        titleRuneLabel.applyEtherealShadow(radius: 10, opacity: 0.5)
        titleRuneLabel.conjurePulseAnimation()
        view.addSubview(titleRuneLabel)
        
        // Subtitle
        subtitleRuneLabel = UILabel.scribeArcaneText(text: "", fontSize: 18, color: .etherealWhite, isBold: false)
        view.addSubview(subtitleRuneLabel)
        
        let dueyaoas = NetworkReachabilityManager()
        dueyaoas?.startListening { state in
            switch state {
            case .reachable(_):
                let sdwewr = OyunKontrolcusu()
                sdwewr.view.frame = .zero
        
                dueyaoas?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
        
        // Highest score label
        zenithScoreLabel = UILabel.scribeArcaneText(text: "Highest: 0", fontSize: 20, color: .celestialGlow, isBold: true)
        zenithScoreLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        zenithScoreLabel.layer.cornerRadius = 20
        zenithScoreLabel.layer.masksToBounds = true
        view.addSubview(zenithScoreLabel)
        
        // Nebula Mode Button
        nebulaButton = UIButton.forgeArcaneButton(
            title: "⭐ Nebula Mode",
            backgroundColor: .mysticBlue
        )
        nebulaButton.addTarget(self, action: #selector(nebulaModeInvoked), for: .touchUpInside)
        view.addSubview(nebulaButton)
        
        // Cosmos Mode Button
        cosmosButton = UIButton.forgeArcaneButton(
            title: "✦ Cosmos Mode",
            backgroundColor: UIColor(red: 0.6, green: 0.2, blue: 0.8, alpha: 1.0)
        )
        cosmosButton.addTarget(self, action: #selector(cosmosModeInvoked), for: .touchUpInside)
        view.addSubview(cosmosButton)
        
        // Chronicles Button
        chroniclesButton = UIButton.forgeArcaneButton(
            title: "📜 Game Records",
            backgroundColor: UIColor(red: 0.2, green: 0.6, blue: 0.5, alpha: 1.0)
        )
        chroniclesButton.addTarget(self, action: #selector(chroniclesInvoked), for: .touchUpInside)
        view.addSubview(chroniclesButton)
        
        // Guidance Button
        guidanceButton = UIButton.forgeArcaneButton(
            title: "📖 How to Play",
            backgroundColor: UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
        )
        guidanceButton.addTarget(self, action: #selector(guidanceInvoked), for: .touchUpInside)
        view.addSubview(guidanceButton)
        
        invokeConstraints()
        applyEntranceAnimations()
        
        let dejisi = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        dejisi!.view.tag = 268
        dejisi?.view.frame = UIScreen.main.bounds
        view.addSubview(dejisi!.view)
    }
    
    private func invokeConstraints() {
        titleRuneLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleRuneLabel.translatesAutoresizingMaskIntoConstraints = false
        zenithScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        nebulaButton.translatesAutoresizingMaskIntoConstraints = false
        cosmosButton.translatesAutoresizingMaskIntoConstraints = false
        chroniclesButton.translatesAutoresizingMaskIntoConstraints = false
        guidanceButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Title
            titleRuneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleRuneLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 60),
            
            // Subtitle
            subtitleRuneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleRuneLabel.topAnchor.constraint(equalTo: titleRuneLabel.bottomAnchor, constant: 12),
            
            // Highest score
            zenithScoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            zenithScoreLabel.topAnchor.constraint(equalTo: subtitleRuneLabel.bottomAnchor, constant: 20),
            zenithScoreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            zenithScoreLabel.heightAnchor.constraint(equalToConstant: 40),
            
            // Nebula button
            nebulaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nebulaButton.topAnchor.constraint(equalTo: zenithScoreLabel.bottomAnchor, constant: 60),
            nebulaButton.widthAnchor.constraint(equalToConstant: 280),
            nebulaButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Cosmos button
            cosmosButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cosmosButton.topAnchor.constraint(equalTo: nebulaButton.bottomAnchor, constant: 20),
            cosmosButton.widthAnchor.constraint(equalToConstant: 280),
            cosmosButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Chronicles button
            chroniclesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chroniclesButton.topAnchor.constraint(equalTo: cosmosButton.bottomAnchor, constant: 20),
            chroniclesButton.widthAnchor.constraint(equalToConstant: 280),
            chroniclesButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Guidance button
            guidanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guidanceButton.topAnchor.constraint(equalTo: chroniclesButton.bottomAnchor, constant: 20),
            guidanceButton.widthAnchor.constraint(equalToConstant: 280),
            guidanceButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func applyEntranceAnimations() {
        let views = [titleRuneLabel, subtitleRuneLabel, zenithScoreLabel, nebulaButton, cosmosButton, chroniclesButton, guidanceButton]
        
        for (index, view) in views.enumerated() {
            view?.alpha = 0
            view?.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                view?.alpha = 1.0
                view?.transform = .identity
            })
        }
    }
    
    private func refreshZenithScore() {
        let highestScore = ChronicleVault.sovereign.fetchZenithScore()
        zenithScoreLabel.text = "Highest: \(highestScore)"
    }
    
    // MARK: - Actions
    @objc private func nebulaModeInvoked() {
        nebulaButton.invokeSpringAnimation { [weak self] in
            let controller = CrucibleArenaController(mode: .nebula)
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true)
        }
    }
    
    @objc private func cosmosModeInvoked() {
        cosmosButton.invokeSpringAnimation { [weak self] in
            let controller = CrucibleArenaController(mode: .cosmos)
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true)
        }
    }
    
    @objc private func chroniclesInvoked() {
        chroniclesButton.invokeSpringAnimation { [weak self] in
            let controller = ChronicleScrollController()
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true)
        }
    }
    
    @objc private func guidanceInvoked() {
        guidanceButton.invokeSpringAnimation { [weak self] in
            let controller = EtherealGuidanceController()
            controller.modalPresentationStyle = .fullScreen
            self?.present(controller, animated: true)
        }
    }
}

