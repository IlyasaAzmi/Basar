//
//  SessionSettings.swift
//  Basar (iOS)
//
//  Created by CAKAP on 10/04/22.
//

import SwiftUI

class SessionSettings: ObservableObject {
    @Published var isPeopleOcclusionEnabled: Bool = false
    @Published var isObjectOcclusionEnabled: Bool = false
    @Published var isLidarDebugEnabled: Bool = false
    @Published var isMultiUserEnabled: Bool = false
}
