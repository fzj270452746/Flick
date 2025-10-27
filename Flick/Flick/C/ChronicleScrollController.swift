//
//  ChronicleScrollController.swift
//  Flick
//
//  Created by Zhao on 2025/10/21.
//

import UIKit

class ChronicleScrollController: UIViewController {
    
    // MARK: - Properties
    private var etherealBackground: UIImageView!
    private var obsidianOverlay: UIView!
    private var returnPortal: UIButton!
    private var titleRuneLabel: UILabel!
    private var chronicleTableView: UITableView!
    private var emptyStateLabel: UILabel!
    private var purgeButton: UIButton!
    
    private var chronicles: [ArcaneRecord] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forgeInterface()
        loadChronicles()
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
        
        // Title
        titleRuneLabel = UILabel.scribeArcaneText(text: "", fontSize: 32, color: .celestialGlow, isBold: true)
        view.addSubview(titleRuneLabel)
        
        // TableView
        chronicleTableView = UITableView(frame: .zero, style: .plain)
        chronicleTableView.backgroundColor = .clear
        chronicleTableView.separatorStyle = .none
        chronicleTableView.delegate = self
        chronicleTableView.dataSource = self
        chronicleTableView.register(ChronicleVesselCell.self, forCellReuseIdentifier: ChronicleVesselCell.runicIdentifier)
        chronicleTableView.showsVerticalScrollIndicator = false
        view.addSubview(chronicleTableView)
        
        // Empty state
        emptyStateLabel = UILabel.scribeArcaneText(text: "No records yet\nStart playing to create history!", fontSize: 18, color: .etherealWhite, isBold: false)
        emptyStateLabel.alpha = 0
        view.addSubview(emptyStateLabel)
        
        // Purge button
        purgeButton = UIButton.forgeArcaneButton(title: "🗑 Clear Records", backgroundColor: .crimsonFailure)
        purgeButton.addTarget(self, action: #selector(purgeChronicles), for: .touchUpInside)
        view.addSubview(purgeButton)
        
        invokeConstraints()
    }
    
    private func invokeConstraints() {
        returnPortal.translatesAutoresizingMaskIntoConstraints = false
        titleRuneLabel.translatesAutoresizingMaskIntoConstraints = false
        chronicleTableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        purgeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            returnPortal.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            returnPortal.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            returnPortal.widthAnchor.constraint(equalToConstant: 100),
            returnPortal.heightAnchor.constraint(equalToConstant: 40),
            
            titleRuneLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            titleRuneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chronicleTableView.topAnchor.constraint(equalTo: titleRuneLabel.bottomAnchor, constant: 50),
            chronicleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chronicleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chronicleTableView.bottomAnchor.constraint(equalTo: purgeButton.topAnchor, constant: -16),
            
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            purgeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            purgeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            purgeButton.widthAnchor.constraint(equalToConstant: 240),
            purgeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: - Data Management
    private func loadChronicles() {
        chronicles = ChronicleVault.sovereign.fetchChronicles()
        chronicleTableView.reloadData()
        
        emptyStateLabel.alpha = chronicles.isEmpty ? 1.0 : 0
        purgeButton.isEnabled = !chronicles.isEmpty
        purgeButton.alpha = chronicles.isEmpty ? 0.5 : 1.0
    }
    
    // MARK: - Actions
    @objc private func returnPortalTapped() {
        dismiss(animated: true)
    }
    
    @objc private func purgeChronicles() {
        let alert = UIAlertController(title: "Clear Records", message: "Are you sure you want to delete all game records?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            ChronicleVault.sovereign.obliterateChronicles()
            self?.loadChronicles()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension ChronicleScrollController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chronicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChronicleVesselCell.runicIdentifier, for: indexPath) as! ChronicleVesselCell
        cell.manifestRecord(chronicles[indexPath.row], rank: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - Chronicle Cell
class ChronicleVesselCell: UITableViewCell {
    
    static let runicIdentifier = "ChronicleVesselCell"
    
    private var containerVessel: UIView!
    private var rankLabel: UILabel!
    private var scoreLabel: UILabel!
    private var modeLabel: UILabel!
    private var dateLabel: UILabel!
    private var durationLabel: UILabel!
    
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
        containerVessel = UIView()
        containerVessel.backgroundColor = UIColor(white: 1.0, alpha: 0.12)
        containerVessel.layer.cornerRadius = 16
        containerVessel.layer.borderWidth = 1.5
        containerVessel.layer.borderColor = UIColor(white: 1.0, alpha: 0.25).cgColor
        containerVessel.applyEtherealShadow(radius: 5, opacity: 0.2)
        contentView.addSubview(containerVessel)
        
        rankLabel = UILabel()
        rankLabel.font = UIFont.boldSystemFont(ofSize: 28)
        rankLabel.textColor = .celestialGlow
        rankLabel.textAlignment = .center
        containerVessel.addSubview(rankLabel)
        
        scoreLabel = UILabel()
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 32)
        scoreLabel.textColor = .verdantSuccess
        scoreLabel.textAlignment = .left
        containerVessel.addSubview(scoreLabel)
        
        modeLabel = UILabel()
        modeLabel.font = UIFont.systemFont(ofSize: 14)
        modeLabel.textColor = .mysticBlue
        modeLabel.textAlignment = .left
        containerVessel.addSubview(modeLabel)
        
        dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .etherealWhite
        dateLabel.textAlignment = .right
        containerVessel.addSubview(dateLabel)
        
        durationLabel = UILabel()
        durationLabel.font = UIFont.systemFont(ofSize: 13)
        durationLabel.textColor = UIColor(white: 0.9, alpha: 0.8)
        durationLabel.textAlignment = .right
        containerVessel.addSubview(durationLabel)
        
        invokeConstraints()
    }
    
    private func invokeConstraints() {
        containerVessel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerVessel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerVessel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerVessel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerVessel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            rankLabel.leadingAnchor.constraint(equalTo: containerVessel.leadingAnchor, constant: 16),
            rankLabel.centerYAnchor.constraint(equalTo: containerVessel.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),
            
            scoreLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 16),
            scoreLabel.topAnchor.constraint(equalTo: containerVessel.topAnchor, constant: 16),
            
            modeLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            modeLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 8),
            
            dateLabel.trailingAnchor.constraint(equalTo: containerVessel.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: containerVessel.topAnchor, constant: 16),
            
            durationLabel.trailingAnchor.constraint(equalTo: containerVessel.trailingAnchor, constant: -16),
            durationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6)
        ])
    }
    
    func manifestRecord(_ record: ArcaneRecord, rank: Int) {
        rankLabel.text = "#\(rank)"
        scoreLabel.text = "\(record.zenithScore)"
        modeLabel.text = "⭐ \(record.obsidianMode)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy HH:mm"
        dateLabel.text = formatter.string(from: record.epochTimestamp)
        
        let minutes = Int(record.ephemeralDuration) / 60
        let seconds = Int(record.ephemeralDuration) % 60
        durationLabel.text = String(format: "⏱ %02d:%02d", minutes, seconds)
        
        // Highlight top 3
        if rank <= 3 {
            let colors: [UIColor] = [
                UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0),  // Gold
                UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0), // Silver
                UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)     // Bronze
            ]
            containerVessel.layer.borderColor = colors[rank - 1].cgColor
            rankLabel.textColor = colors[rank - 1]
        } else {
            containerVessel.layer.borderColor = UIColor(white: 1.0, alpha: 0.25).cgColor
            rankLabel.textColor = .celestialGlow
        }
    }
}

