//
//  CustomARView.swift
//  AugmentedCity
//
//  Created by Jared Waldroff on 2023-12-22.
//

// Importing necessary frameworks.
// ARKit for augmented reality capabilities.
// RealityKit for rendering 3D content.
// SwiftUI for using this view in a SwiftUI app.
import ARKit
import Combine
import RealityKit
import SwiftUI

// CustomARView is a class that inherits from ARView, which is provided by RealityKit.
// ARView is the main view for displaying AR content.
class CustomARView: ARView {
    // This initializer is used when creating an instance of CustomARView with a specific frame size.
    // 'frameRect' represents the rectangle in which the AR content will be displayed.
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    // This initializer is required by the NSCoder, used primarily when the view is being loaded from a storyboard or XIB.
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Convenience initializer for creating an instance of CustomARView.
    // This initializer does not require any parameters and initializes the view with the main screen's bounds.
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        subscribeToActionStream()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                    case .placeBlock(let color):
                    self?.placeBlueBlock(ofColor: color)
                    
                    case .removeAllAnchors:
                    self?.scene.anchors.removeAll()
                    
                    case .loadHabScene:
                    self?.loadHabEnScene()
                    
                    case .loadRoverScene:
                    self?.loadRoverScene()
                    
                    case .loadSpacesuitScene:
                    self?.loadSpacesuitScene()
                    
                    case .loadPancake:
                    self?.loadPancake()
                    
                    case .loadDrummer:
                    self?.loadDrummer()
                    
                    case .loadTV:
                    self?.loadTV()
                    
                    case .loadChair:
                    self?.loadChair()
                    
                    case .loadPlant:
                    self?.loadPlant()
                    
                    case .loadCup:
                    self?.loadCup()
                    
                    case.loadTeapot:
                    self?.loadTeapot()
                    
                }
            }
            .store(in: &cancellables)
    }
    
    func loadHabEnScene() {
        do {
            let habEnScene = try Experience.loadHab()
            self.scene.anchors.append(habEnScene)
        } catch {
            print("Error loading hab_en.reality file: \(error)")
        }
    }
    
    func loadRoverScene() {
        do {
            let roverScene = try Experience.loadRover()
            self.scene.anchors.append(roverScene)
        } catch {
            print("Error loading rover file: \(error)")
        }
    }
    
    func loadSpacesuitScene() {
        do {
            let spacesuitScene = try Experience.loadSpacesuit()
            self.scene.anchors.append(spacesuitScene)
        } catch {
            print("Error loading spacesuit file: \(error)")
        }
    }
    
    func loadPancake() {
        do {
            let pancake = try Experience.loadPancake()
            self.scene.anchors.append(pancake)
        } catch {
            print("Error loading pancake file: \(error)")
        }
    }
    
    func loadDrummer() {
        do {
            let drummer = try Experience.loadDrummer()
            self.scene.anchors.append(drummer)
        } catch {
            print("Error loading drummer file: \(error)")
        }
    }
    
    func loadTV() {
        do {
            let TV = try Experience.loadTV()
            self.scene.anchors.append(TV)
        } catch {
            print("Error loading TV file: \(error)")
        }
    }
    
    func loadChair() {
        do {
            let chair = try Experience.loadChair()
            self.scene.anchors.append(chair)
        } catch {
            print("Error loading chair file: \(error)")
        }
    }
    
    func loadPlant() {
        do {
            let plant = try Experience.loadPlant()
            self.scene.anchors.append(plant)
        } catch {
            print("Error loading plant file: \(error)")
        }
    }
    
    func loadCup() {
        do {
            let cup = try Experience.loadCup()
            self.scene.anchors.append(cup)
        } catch {
            print("Error loading cup file: \(error)")
        }
    }
    
    func loadTeapot() {
        do {
            let teapot = try Experience.loadTeapot()
            self.scene.anchors.append(teapot)
        } catch {
            print("Error loading teapot file: \(error)")
        }
    }
    
    func configurationExamples() {
        //Tracks the device relative to it's environment
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration)
        
        //Not supported in all regions, tracks w.r.t. global coordinates
        let _ = ARGeoTrackingConfiguration()
        
        //Tracks faces in the scene
        let _ = ARFaceTrackingConfiguration()
        
        //Tracks bodies in the scene
        let _ = ARBodyTrackingConfiguration()
    }
    
    func anchorExamples() {
        //Attach anchors at specifc coordinates in the iPhone-centered coordinate system
        let coordinateAnchor = AnchorEntity(world: .zero)
        
        //Attach anchors to detected planes (this works best on devices with a LIDAR sensor
        let _ = AnchorEntity(plane: .horizontal)
        let _ = AnchorEntity(plane: .vertical)
        
        //Attach anchors to tracked body parts, such as the face
        let _ = AnchorEntity(.face)
        
        //Attach anchors to tracked images, such as markers or visual codes
        let _ = AnchorEntity(.image(group: "group", name: "name"))
        
        //Add an anchor to the scene
        scene.addAnchor(coordinateAnchor)
    }
    
    func entityExamples() {
        // Load an entity from a usdz file
        let _ = try? Entity.load(named: "usdzFileName")
        
        // Load an entity from a reality file
        let _ = try? Entity.load(named: "realityFileName")
        
        // Generate an entity with code
        let box = MeshResource.generateBox(size: 1)
        let entity = ModelEntity(mesh: box)
        
        // Add entity to an anchor, so it's placed in the scene
        let anchor = AnchorEntity()
        anchor.addChild(entity)
    }
    
    func placeBlueBlock(ofColor color: Color) {
        // Create block from mesh resource with edge size of 1m
        let block = MeshResource.generateBox(size: 0.1)
        // Make the block blue and metallic which will reflect light from environment
        let material = SimpleMaterial(color: UIColor(color), isMetallic: false)
        let entity = ModelEntity(mesh: block, materials: [material])
        
        // When app is open it will look for any horizontal plane to place anchor
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(entity)
        
        scene.addAnchor(anchor)
    }
    
}
