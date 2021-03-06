//
//  ControlView.swift
//  Basar (iOS)
//
//  Created by CAKAP on 09/04/22.
//

import SwiftUI

struct ControlView: View {
    @Binding var isControlVisible: Bool
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        VStack {
            ControlVisibilityToggleButton(isControlVisible: $isControlVisible)
            Spacer()
            if isControlVisible {
                ControlButtonBar(showBrowse: $showBrowse, showSettings: $showSettings)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View {
    @Binding var isControlVisible: Bool
    var body: some View {
        HStack {
            Spacer()
            ZStack {
                Color.black.opacity(0.25)
                Button(action: {
                    print("Control visibility toggle button pressed")
                    self.isControlVisible.toggle()
                }) {
                    Image(systemName: self.isControlVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                        .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top, 45)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowse: Bool
    @Binding var showSettings: Bool
    
    var body: some View {
        HStack {
            // Most Recently Button
            MostRecentlyPlacedButton()
                .hidden(self.placementSettings.recentlyPlaced.isEmpty)
            
            Spacer()
            
            // Browse button
            ControlButton(systemIconName: "square.grid.2x2") {
                print("Browse button tapped")
                self.showBrowse.toggle()
            }.sheet(isPresented: $showBrowse, content: {
                // BrowseView
                BrowseView(showBrowse: $showBrowse)
            })
            
            Spacer()
            
            // Settings button
            ControlButton(systemIconName: "slider.horizontal.3") {
                print("Settings button tapped")
                self.showSettings.toggle()
            }.sheet(isPresented: $showSettings) {
                SettingsView(showSettings: $showSettings)
            }
        }
        .frame(maxWidth: 500)
        .padding(30)
        .background(Color.black
            .opacity(0.25))
    }
}

struct ControlButton: View {
    let systemIconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: systemIconName)
                .font(.system(size: 25))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
    }
}

struct MostRecentlyPlacedButton: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    
    var body: some View {
        Button(action: {
            print("Most recently Placed button pressed")
            self.placementSettings.selectedModel = self.placementSettings.recentlyPlaced.last
        }) {
            if let mostRecentlyPlaced = self.placementSettings.recentlyPlaced.last {
                Image(uiImage: mostRecentlyPlaced.thumbnail)
                    .resizable()
                    .frame(width: 46)
                    .aspectRatio(1/1, contentMode: .fit)
            } else {
                Image(systemName: "clock.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 50, height: 50)
        .background(Color.white)
        .cornerRadius(8)
    }
}
