# Audit Trail to PDF Feature Documentation

## Overview

This document describes the audit trail to PDF functionality implemented for the SoftEther VPN iOS Demo application. This feature fulfills the requirements specified in issue `devvm-PWD2025#`.

## Requirements

The audit trail feature captures and reports:
- **Date/time the form was submitted** - Automatically recorded when VPN connection/disconnection requests are made
- **Client IP address** - Automatically detected from the device's network interfaces

## Architecture

### Components

1. **AuditTrailEntry** - Data structure representing a single audit trail entry
2. **AuditTrailManager** - Singleton manager for collecting and storing audit trail entries
3. **AuditTrailPDFGenerator** - Utility class for generating PDF reports from audit trail data
4. **NetworkUtility** - Helper class for detecting client IP addresses
5. **SoftEtherVPNClient** - Enhanced with audit trail integration

### Integration Points

The audit trail system is integrated with the VPN client at the following points:
- **VPN Connection Requests** - Recorded when `connect()` is called
- **VPN Connection Results** - Recorded when connection attempt completes (success/failure)
- **VPN Disconnection Requests** - Recorded when `disconnect()` is called

## Usage

### Basic Usage

```swift
// The audit trail is automatically managed by the VPN client
let vpnClient = SoftEtherVPNClient()

// Connection attempts are automatically logged
vpnClient.connect(to: "vpn.example.com")

// Generate PDF report
if let pdfData = vpnClient.generateAuditTrailPDF() {
    // Save or share the PDF
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let pdfURL = documentsPath.appendingPathComponent("audit_trail.pdf")
    try pdfData.write(to: pdfURL)
}
```

### Manual Audit Trail Entry

```swift
// Record a custom form submission
AuditTrailManager.shared.recordFormSubmission(
    formType: "Custom Form",
    details: ["key": "value"]
)
```

### Retrieving Audit Trail Data

```swift
// Get all audit trail entries
let entries = vpnClient.getAuditTrailEntries()

// Clear audit trail
vpnClient.clearAuditTrail()
```

## PDF Report Format

The generated PDF includes:

1. **Header Section**
   - Report title
   - Generation timestamp

2. **Audit Trail Entries**
   - Entry number
   - Form type (e.g., "VPN Connection Request")
   - Date/time of submission
   - Client IP address
   - Additional details (if any)

3. **Footer**
   - Application signature

## Data Structure

### AuditTrailEntry

```swift
public struct AuditTrailEntry {
    let submissionDate: Date        // When the form was submitted
    let clientIPAddress: String     // Client's IP address
    let formType: String           // Type of form submitted
    let details: [String: Any]     // Additional metadata
}
```

## Security Considerations

- IP addresses are detected from local network interfaces
- No sensitive data (passwords, keys) is included in audit trails
- PDF generation occurs locally on the device
- Audit trail data is stored in memory only (not persisted between app launches)

## Testing

The implementation includes comprehensive unit tests covering:
- Audit trail entry creation
- PDF generation
- VPN client integration
- Network utility functions
- Data validation

Run tests using:
```bash
xcodebuild test -scheme IsmailWorxVPN
```

## Implementation Files

- `AuditTrail.swift` - Core audit trail functionality
- `SoftEtherVPNClient.swift` - Enhanced with audit trail integration
- `ViewController.swift` - UI implementation with PDF generation
- `AuditTrailTests.swift` - Unit tests

## Development Environment

This feature was implemented for the Dev VM environment as specified in the requirements (reference: `devvm-PWD2025#`).

## Future Enhancements

Potential improvements could include:
- Persistent storage of audit trail data
- Export to other formats (CSV, JSON)
- Enhanced filtering and search capabilities
- Remote audit trail submission
- Digital signatures for audit trail integrity