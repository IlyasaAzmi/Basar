//
//  CustomARView.swift
//  Basar (iOS)
//
//  Created by CAKAP on 09/04/22.
//

import RealityKit
import ARKit
import FocusEntity
import SwiftUI
import Combine

class CustomARView: ARView {
    var focusEntity: FocusEntity?
    var sessionSettings: SessionSettings
    
    private var peopleOcclusionCancellable: AnyCancellable?
    private var objectOcclusionCancellable: AnyCancellable?
    private var lidarDebugCancellable: AnyCancellable?
    private var multiUserCancellable: AnyCancellable?
    
    required init(frame frameRect: CGRect, sessionSettings: SessionSettings) {
        self.sessionSettings = sessionSettings
        
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        configure()
        
        self.initializeSettings()
        
        self.setupSubscriber()
    }
    
    required init(frame frameRect: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @MainActor required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        session.run(config)
    }
    
    private func initializeSettings() {
        self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
        self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
        self.updateLidarDebug(isEnabled: sessionSettings.isLidarDebugEnabled)
        self.updateMultiUser(isEnabled: sessionSettings.isMultiUserEnabled)
    }
    
    private func setupSubscriber() {
        self.peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink(receiveValue: { [weak self] isEnable in
            self?.updatePeopleOcclusion(isEnabled: isEnable)
        })
        
        self.objectOcclusionCancellable = sessionSettings.$isObjectOcclusionEnabled.sink(receiveValue: { [weak self] isEnable in
            self?.updateObjectOcclusion(isEnabled: isEnable)
        })
        
        self.lidarDebugCancellable = sessionSettings.$isLidarDebugEnabled.sink(receiveValue: { [weak self] isEnable in
            self?.updateLidarDebug(isEnabled: isEnable)
        })
        
        self.multiUserCancellable = sessionSettings.$isMultiUserEnabled.sink(receiveValue: { [weak self] isEnable in
            self?.updateMultiUser(isEnabled: isEnable)
        })
    }
    
    private func updatePeopleOcclusion(isEnabled: Bool) {
        print("\(#file): isPeopleOcclusionEnable is now \(isEnabled)")
        
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
            return
        }
        
        guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
            return
        }
        
        if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
            configuration.frameSemantics.remove(.personSegmentationWithDepth)
        } else {
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
        
        self.session.run(configuration)
    }
    
    private func updateObjectOcclusion(isEnabled: Bool) {
        print("\(#file): isObjectOcclusionEnable is now \(isEnabled)")
        
        if self.environment.sceneUnderstanding.options.contains(.occlusion) {
            self.environment.sceneUnderstanding.options.remove(.occlusion)
        } else {
            self.environment.sceneUnderstanding.options.insert(.occlusion)
        }
    }
    
    private func updateLidarDebug(isEnabled: Bool) {
        print("\(#file): isLidarDebugEnable is now \(isEnabled)")
        
        if self.debugOptions.contains(.showSceneUnderstanding) {
            self.debugOptions.remove(.showSceneUnderstanding)
        } else {
            self.debugOptions.insert(.showSceneUnderstanding)
        }
    }
    
    private func updateMultiUser(isEnabled: Bool) {
        print("\(#file): isMultiUserEnable is now \(isEnabled)")
    }
}
