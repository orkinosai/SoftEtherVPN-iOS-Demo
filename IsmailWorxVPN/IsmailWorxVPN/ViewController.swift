//
//  ViewController.swift
//  IsmailWorxVPN
//
//  Created by MacAir2020 on 11/06/2025.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private let vpnClient = SoftEtherVPNClient()
    
    // MARK: - UI Elements
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var generatePDFButton: UIButton!
    @IBOutlet weak var auditTrailTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        vpnClient.delegate = self
    }
    
    private func setupUI() {
        // Create UI elements programmatically since storyboard is minimal
        view.backgroundColor = .systemBackground
        
        // Status Label
        statusLabel = UILabel()
        statusLabel.text = "Disconnected"
        statusLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // Host Text Field
        hostTextField = UITextField()
        hostTextField.placeholder = "Enter VPN server hostname (e.g., vpn.example.com)"
        hostTextField.borderStyle = .roundedRect
        hostTextField.text = "demo.vpn.softether.org"
        hostTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostTextField)
        
        // Connect Button
        connectButton = UIButton(type: .system)
        connectButton.setTitle("Connect", for: .normal)
        connectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        connectButton.backgroundColor = .systemBlue
        connectButton.setTitleColor(.white, for: .normal)
        connectButton.layer.cornerRadius = 8
        connectButton.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        connectButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectButton)
        
        // Generate PDF Button
        generatePDFButton = UIButton(type: .system)
        generatePDFButton.setTitle("Generate Audit Trail PDF", for: .normal)
        generatePDFButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        generatePDFButton.backgroundColor = .systemGreen
        generatePDFButton.setTitleColor(.white, for: .normal)
        generatePDFButton.layer.cornerRadius = 8
        generatePDFButton.addTarget(self, action: #selector(generatePDFButtonTapped), for: .touchUpInside)
        generatePDFButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(generatePDFButton)
        
        // Audit Trail Text View
        auditTrailTextView = UITextView()
        auditTrailTextView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        auditTrailTextView.backgroundColor = .systemGray6
        auditTrailTextView.layer.cornerRadius = 8
        auditTrailTextView.isEditable = false
        auditTrailTextView.text = "Audit trail entries will appear here..."
        auditTrailTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(auditTrailTextView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(equalToConstant: 30),
            
            hostTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 20),
            hostTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hostTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            hostTextField.heightAnchor.constraint(equalToConstant: 44),
            
            connectButton.topAnchor.constraint(equalTo: hostTextField.bottomAnchor, constant: 15),
            connectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            connectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            connectButton.heightAnchor.constraint(equalToConstant: 50),
            
            generatePDFButton.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 15),
            generatePDFButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            generatePDFButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            generatePDFButton.heightAnchor.constraint(equalToConstant: 50),
            
            auditTrailTextView.topAnchor.constraint(equalTo: generatePDFButton.bottomAnchor, constant: 20),
            auditTrailTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            auditTrailTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            auditTrailTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        updateAuditTrailDisplay()
    }
    
    @objc private func connectButtonTapped() {
        guard let host = hostTextField.text, !host.isEmpty else {
            showAlert(title: "Error", message: "Please enter a VPN server hostname")
            return
        }
        
        if vpnClient.isConnected() {
            vpnClient.disconnect()
        } else {
            vpnClient.connect(to: host) { [weak self] success, error in
                DispatchQueue.main.async {
                    if !success {
                        self?.showAlert(title: "Connection Failed", 
                                       message: error?.localizedDescription ?? "Unknown error occurred")
                    }
                    self?.updateAuditTrailDisplay()
                }
            }
        }
    }
    
    @objc private func generatePDFButtonTapped() {
        guard let pdfData = vpnClient.generateAuditTrailPDF() else {
            showAlert(title: "Error", message: "Failed to generate PDF")
            return
        }
        
        // Save PDF to Documents directory
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "audit_trail_\(Date().timeIntervalSince1970).pdf"
        let pdfURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: pdfURL)
            
            // Show activity view controller to share/save the PDF
            let activityVC = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
            
            // Configure for iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = generatePDFButton
                popover.sourceRect = generatePDFButton.bounds
            }
            
            present(activityVC, animated: true)
            
        } catch {
            showAlert(title: "Error", message: "Failed to save PDF: \(error.localizedDescription)")
        }
    }
    
    private func updateAuditTrailDisplay() {
        let entries = vpnClient.getAuditTrailEntries()
        
        if entries.isEmpty {
            auditTrailTextView.text = "No audit trail entries yet.\nTry connecting to a VPN server to generate entries."
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .medium
            
            var displayText = "Audit Trail Entries (\(entries.count)):\n\n"
            
            for (index, entry) in entries.enumerated() {
                displayText += "\(index + 1). \(entry.formType)\n"
                displayText += "   Date/Time: \(formatter.string(from: entry.submissionDate))\n"
                displayText += "   Client IP: \(entry.clientIPAddress)\n"
                if !entry.details.isEmpty {
                    displayText += "   Details: \(entry.details)\n"
                }
                displayText += "\n"
            }
            
            auditTrailTextView.text = displayText
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - SoftEtherVPNClient.ConnectionDelegate

extension ViewController: SoftEtherVPNClient.ConnectionDelegate {
    func connectionStateDidChange(_ state: SoftEtherVPNClient.ConnectionState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .connected:
                self?.connectButton.setTitle("Disconnect", for: .normal)
                self?.connectButton.backgroundColor = .systemRed
                self?.statusLabel.text = "Connected"
                self?.statusLabel.textColor = .systemGreen
            case .connecting:
                self?.statusLabel.text = "Connecting..."
                self?.statusLabel.textColor = .systemOrange
            case .disconnecting:
                self?.statusLabel.text = "Disconnecting..."
                self?.statusLabel.textColor = .systemOrange
            case .disconnected:
                self?.connectButton.setTitle("Connect", for: .normal)
                self?.connectButton.backgroundColor = .systemBlue
                self?.statusLabel.text = "Disconnected"
                self?.statusLabel.textColor = .systemGray
            case .error(let error):
                self?.statusLabel.text = "Error: \(error.localizedDescription)"
                self?.statusLabel.textColor = .systemRed
                self?.connectButton.setTitle("Connect", for: .normal)
                self?.connectButton.backgroundColor = .systemBlue
            }
            
            self?.updateAuditTrailDisplay()
        }
    }
}

