//
//  View+Extensions.swift
//  Basar (iOS)
//
//  Created by CAKAP on 09/04/22.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
