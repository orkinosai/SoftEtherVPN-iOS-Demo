//
//  AuditTrailTests.swift
//  IsmailWorxVPN
//
//  Unit tests for the audit trail functionality
//  Reference: devvm-PWD2025#
//

import XCTest
@testable import IsmailWorxVPN

class AuditTrailTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Clear audit trail before each test
        AuditTrailManager.shared.clearEntries()
    }

    override func tearDown() {
        // Clear audit trail after each test
        AuditTrailManager.shared.clearEntries()
        super.tearDown()
    }

    func testAuditTrailEntryCreation() {
        // Test creating an audit trail entry
        let entry = AuditTrailEntry(
            submissionDate: Date(),
            clientIPAddress: "192.168.1.100",
            formType: "Test Form",
            details: ["test_key": "test_value"]
        )
        
        XCTAssertEqual(entry.clientIPAddress, "192.168.1.100")
        XCTAssertEqual(entry.formType, "Test Form")
        XCTAssertEqual(entry.details["test_key"] as? String, "test_value")
    }
    
    func testAuditTrailManagerAddEntry() {
        // Test adding an entry to the audit trail manager
        let initialCount = AuditTrailManager.shared.getAllEntries().count
        
        AuditTrailManager.shared.recordFormSubmission(
            formType: "VPN Connection Test",
            details: ["server": "test.vpn.com"]
        )
        
        let entries = AuditTrailManager.shared.getAllEntries()
        XCTAssertEqual(entries.count, initialCount + 1)
        XCTAssertEqual(entries.last?.formType, "VPN Connection Test")
    }
    
    func testNetworkUtilityGetClientIP() {
        // Test getting client IP address
        let clientIP = NetworkUtility.getClientIPAddress()
        
        // IP should not be empty and should not be "Unknown" in most cases
        XCTAssertFalse(clientIP.isEmpty)
        print("Client IP: \(clientIP)")
    }
    
    func testPDFGeneration() {
        // Test PDF generation with sample audit trail entries
        AuditTrailManager.shared.recordFormSubmission(
            formType: "Test VPN Connection",
            details: ["server": "test.example.com", "port": 443]
        )
        
        AuditTrailManager.shared.recordFormSubmission(
            formType: "Test VPN Disconnection",
            details: ["reason": "user_initiated"]
        )
        
        let entries = AuditTrailManager.shared.getAllEntries()
        let pdfData = AuditTrailPDFGenerator.generatePDF(entries: entries, title: "Test Audit Trail")
        
        XCTAssertNotNil(pdfData)
        XCTAssertGreaterThan(pdfData?.count ?? 0, 0)
        print("Generated PDF size: \(pdfData?.count ?? 0) bytes")
    }
    
    func testVPNClientAuditTrailIntegration() {
        // Test VPN client integration with audit trail
        let vpnClient = SoftEtherVPNClient()
        
        let initialCount = vpnClient.getAuditTrailEntries().count
        
        // Simulate connection attempt (this will add audit trail entries)
        vpnClient.connect(to: "test.vpn.com") { success, error in
            // This completion handler will be called after the audit entries are added
        }
        
        // Check that audit trail entries were added
        let entries = vpnClient.getAuditTrailEntries()
        XCTAssertGreaterThan(entries.count, initialCount)
        
        // Verify that a PDF can be generated
        let pdfData = vpnClient.generateAuditTrailPDF()
        XCTAssertNotNil(pdfData)
    }
    
    func testClearAuditTrail() {
        // Test clearing audit trail
        AuditTrailManager.shared.recordFormSubmission(formType: "Test Entry")
        
        XCTAssertGreaterThan(AuditTrailManager.shared.getAllEntries().count, 0)
        
        AuditTrailManager.shared.clearEntries()
        
        XCTAssertEqual(AuditTrailManager.shared.getAllEntries().count, 0)
    }
    
    func testAuditTrailEntryContainsRequiredFields() {
        // Test that audit trail entries contain required fields from the issue
        AuditTrailManager.shared.recordFormSubmission(
            formType: "VPN Connection Request",
            details: ["server": "demo.vpn.com"]
        )
        
        let entries = AuditTrailManager.shared.getAllEntries()
        XCTAssertGreaterThan(entries.count, 0)
        
        let entry = entries.last!
        
        // Verify required fields from issue description
        // 1. Date/time the form was submitted
        XCTAssertTrue(entry.submissionDate.timeIntervalSinceNow < 1.0) // Should be recent
        
        // 2. Client IP address  
        XCTAssertFalse(entry.clientIPAddress.isEmpty)
        print("Entry timestamp: \(entry.submissionDate)")
        print("Entry client IP: \(entry.clientIPAddress)")
    }

}