//
//  PlacementSettings.swift
//  Basar (iOS)
//
//  Created by CAKAP on 09/04/22.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    // When the user selecta a model in BrowseView, this property is set
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    // When user taps confirm in PlacementView, the value of selectedModel is assigned to confirmedModel
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            print("Setting confirmedModel to \(model.name)")
            
            self.recentlyPlaced.append(model)
        }
    }
    
    // This property retains a record of placed models in the scene. The last element in the array is the most recently placed model
    @Published var recentlyPlaced: [Model] = []
    
    
    // This property retains the cancellable object for our SceneEvents.Update subscriber
    var sceneObserver: Cancellable?
}
