//
//  Model.swift
//  Basar (iOS)
//
//  Created by CAKAP on 09/04/22.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case furniture
    case animal
    case fruit
    case vehicle
    
    var label: String {
        get {
            switch self {
            case .furniture:
                return "Furniture"
            case .animal:
                return "Animal"
            case .fruit:
                return "Fruit"
            case .vehicle:
                return "Vehicle"
            }
        }
    }
}

class Model {
    var name: String
    var category: ModelCategory
    var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity() {
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: {loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            }, receiveValue: { modelEntity in
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("model entity for \(self.name) has been loaded")
            })
    }
}

struct Models {
    var all: [Model] = []
    
    init() {
        let redChair = Model(name: "chair_swan", category: .furniture, scaleCompensation: 50 / 100)
        
        self.all += [redChair]
    }
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter({$0.category == category})
    }
}
