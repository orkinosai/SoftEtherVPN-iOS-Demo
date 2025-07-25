//
//  AuditTrail.swift
//  SoftEtherVPN-iOS
//
//  Audit trail functionality for tracking form submissions and generating PDF reports
//  Reference: devvm-PWD2025#
//

import Foundation
import UIKit
import PDFKit

#if canImport(Network)
import Network
#endif

#if os(iOS)
import ifaddrs
#endif

/// Audit trail entry containing submission details
public struct AuditTrailEntry {
    let submissionDate: Date
    let clientIPAddress: String
    let formType: String
    let details: [String: Any]
    
    public init(submissionDate: Date = Date(), 
                clientIPAddress: String, 
                formType: String, 
                details: [String: Any] = [:]) {
        self.submissionDate = submissionDate
        self.clientIPAddress = clientIPAddress
        self.formType = formType
        self.details = details
    }
}

/// Manager for audit trail functionality
public class AuditTrailManager {
    public static let shared = AuditTrailManager()
    private var auditEntries: [AuditTrailEntry] = []
    
    private init() {}
    
    /// Add a new audit trail entry
    /// - Parameter entry: The audit trail entry to add
    public func addEntry(_ entry: AuditTrailEntry) {
        auditEntries.append(entry)
        print("Audit Trail: Added entry for \(entry.formType) from IP \(entry.clientIPAddress)")
    }
    
    /// Record a form submission with audit trail
    /// - Parameters:
    ///   - formType: Type of form submitted (e.g., "VPN Connection Request")
    ///   - details: Additional details about the submission
    public func recordFormSubmission(formType: String, details: [String: Any] = [:]) {
        let clientIP = NetworkUtility.getClientIPAddress()
        let entry = AuditTrailEntry(
            clientIPAddress: clientIP,
            formType: formType,
            details: details
        )
        addEntry(entry)
    }
    
    /// Get all audit trail entries
    /// - Returns: Array of audit trail entries
    public func getAllEntries() -> [AuditTrailEntry] {
        return auditEntries
    }
    
    /// Clear all audit trail entries
    public func clearEntries() {
        auditEntries.removeAll()
    }
}

/// PDF generator for audit trail reports
public class AuditTrailPDFGenerator {
    
    /// Generate a PDF document with audit trail information
    /// - Parameters:
    ///   - entries: Array of audit trail entries to include
    ///   - title: Title for the PDF document
    /// - Returns: PDF data
    public static func generatePDF(entries: [AuditTrailEntry], title: String = "Audit Trail Report") -> Data? {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            let titleFont = UIFont.boldSystemFont(ofSize: 18)
            let headerFont = UIFont.boldSystemFont(ofSize: 14)
            let bodyFont = UIFont.systemFont(ofSize: 12)
            let smallFont = UIFont.systemFont(ofSize: 10)
            
            var yPosition: CGFloat = 50
            
            // Title
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: titleFont,
                .foregroundColor: UIColor.black
            ]
            let titleString = NSAttributedString(string: title, attributes: titleAttributes)
            let titleRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 30)
            titleString.draw(in: titleRect)
            yPosition += 50
            
            // Generation timestamp
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
            let timestampText = "Generated on: \(formatter.string(from: Date()))"
            let timestampAttributes: [NSAttributedString.Key: Any] = [
                .font: smallFont,
                .foregroundColor: UIColor.gray
            ]
            let timestampString = NSAttributedString(string: timestampText, attributes: timestampAttributes)
            let timestampRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 20)
            timestampString.draw(in: timestampRect)
            yPosition += 40
            
            // Audit trail header
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: headerFont,
                .foregroundColor: UIColor.black
            ]
            let headerString = NSAttributedString(string: "Audit Trail Entries", attributes: headerAttributes)
            let headerRect = CGRect(x: 50, y: yPosition, width: pageRect.width - 100, height: 25)
            headerString.draw(in: headerRect)
            yPosition += 35
            
            // Audit entries
            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: bodyFont,
                .foregroundColor: UIColor.black
            ]
            
            if entries.isEmpty {
                let noEntriesString = NSAttributedString(string: "No audit trail entries found.", attributes: bodyAttributes)
                let noEntriesRect = CGRect(x: 70, y: yPosition, width: pageRect.width - 120, height: 20)
                noEntriesString.draw(in: noEntriesRect)
            } else {
                for (index, entry) in entries.enumerated() {
                    // Check if we need a new page
                    if yPosition > pageRect.height - 150 {
                        context.beginPage()
                        yPosition = 50
                    }
                    
                    // Entry number
                    let entryNumberString = NSAttributedString(string: "\(index + 1). ", attributes: headerAttributes)
                    let entryNumberRect = CGRect(x: 50, y: yPosition, width: 30, height: 20)
                    entryNumberString.draw(in: entryNumberRect)
                    
                    // Form type
                    let formTypeString = NSAttributedString(string: "Form Type: \(entry.formType)", attributes: bodyAttributes)
                    let formTypeRect = CGRect(x: 80, y: yPosition, width: pageRect.width - 130, height: 20)
                    formTypeString.draw(in: formTypeRect)
                    yPosition += 20
                    
                    // Submission date/time
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .medium
                    let dateString = NSAttributedString(string: "Date/Time: \(formatter.string(from: entry.submissionDate))", attributes: bodyAttributes)
                    let dateRect = CGRect(x: 80, y: yPosition, width: pageRect.width - 130, height: 20)
                    dateString.draw(in: dateRect)
                    yPosition += 20
                    
                    // Client IP address
                    let ipString = NSAttributedString(string: "Client IP: \(entry.clientIPAddress)", attributes: bodyAttributes)
                    let ipRect = CGRect(x: 80, y: yPosition, width: pageRect.width - 130, height: 20)
                    ipString.draw(in: ipRect)
                    yPosition += 20
                    
                    // Additional details
                    if !entry.details.isEmpty {
                        let detailsString = NSAttributedString(string: "Details: \(entry.details.description)", attributes: bodyAttributes)
                        let detailsRect = CGRect(x: 80, y: yPosition, width: pageRect.width - 130, height: 40)
                        detailsString.draw(in: detailsRect)
                        yPosition += 40
                    }
                    
                    yPosition += 10 // Extra spacing between entries
                }
            }
            
            // Footer
            let footerText = "This audit trail was automatically generated by the SoftEther VPN iOS Demo application."
            let footerAttributes: [NSAttributedString.Key: Any] = [
                .font: smallFont,
                .foregroundColor: UIColor.gray
            ]
            let footerString = NSAttributedString(string: footerText, attributes: footerAttributes)
            let footerRect = CGRect(x: 50, y: pageRect.height - 50, width: pageRect.width - 100, height: 30)
            footerString.draw(in: footerRect)
        }
        
        return data
    }
}

/// Network utility for getting client IP address
public class NetworkUtility {
    
    /// Get the client's IP address
    /// - Returns: IP address as string, or "Unknown" if not available
    public static func getClientIPAddress() -> String {
        var address = ""
        
        // Get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return "Unknown" }
        guard let firstAddr = ifaddr else { return "Unknown" }
        
        // Iterate through linked list of interfaces
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" || name == "en1" || name == "pdp_ip0" || name == "pdp_ip1" {
                    
                    // Convert interface address to a human readable string
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                    
                    // Prefer IPv4 addresses
                    if addrFamily == UInt8(AF_INET) {
                        break
                    }
                }
            }
        }
        
        freeifaddrs(ifaddr)
        
        return address.isEmpty ? "Unknown" : address
    }
}