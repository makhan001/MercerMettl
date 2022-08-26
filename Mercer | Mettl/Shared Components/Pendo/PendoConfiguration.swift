//
//  File.swift
//  Dev_Mercer_Mettl
//
//  Created by apple on 30/05/22.
//

import Foundation
import UIKit

class PendoConfiguration: NSObject {
    // swiftlint:disable line_length
    static let pendoAppKey = "eyJhbGciOiJSUzI1NiIsImtpZCI6IiIsInR5cCI6IkpXVCJ9.eyJkYXRhY2VudGVyIjoidXMiLCJrZXkiOiJiNWZjNzE5Nzg2MmRhMmIzZDkxMDdmMmQ2NGU5YzJhNDFjY2RiZjcxNTNiOGEyZDk5ZDI5NmNkNGFkZjJmOGFkOWFjMTgxZTBhMDVhMWY4NDNhNTE4OTU0N2FhZmViZDNkZDkwYjQ1NGYxNzMxMjhhODlhMmJmOTgxOWRmNDIwOS45MzhmZDZiOTU5MzIwYWUyYTRmYjMwODg0OTlhMDkzNi4xNzkzYjFiNTQ4ZDYxNTJjYzExODdhOTQxNjVhMDdlY2I1YjRiM2Q0NzAyY2MwMDdhOGJjNzljOWU1NTQ3MzAwIn0.bME5RTJK2oMTnlutoiPq6S27re0JyGn7_63qDrrX1gU8bhGddx-nfGAgGUah8Ams0I5ylTWEhKiqAD5-bh4IVs4dz-ncJtV6ODs8N78i1V-RWWybypfvmLsQXSH1YFC_uKT_gUCVTGMd8puitwRhbS6vOaHraHNmkErP-_m83cs"
    static let visitorId = "ios-\(String(describing: UIDevice.current.identifierForVendor?.uuidString ?? ""))"
}
