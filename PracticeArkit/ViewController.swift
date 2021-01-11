//
//  ViewController.swift
//  PracticeArkit
//
//  Created by Kenshiro on 2021/01/11.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return  }

        let floor = createFloor(from: planeAnchor)
        node.addChildNode(floor)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
                   let planeNode = node.childNodes.first,
                   let planeNodeGeometry = planeNode.geometry as? SCNPlane
            else { return }

        let updatedPosition = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.position = updatedPosition

        planeNodeGeometry.width  = CGFloat(planeAnchor.extent.x)
        planeNodeGeometry.height = CGFloat(planeAnchor.extent.z)
    }

    func createFloor(from anchor: ARPlaneAnchor) -> SCNNode{
        let anchorWidth  = CGFloat(anchor.extent.x)
        let anchorHeight = CGFloat(anchor.extent.z)

        let planeGeometry = SCNPlane(width: anchorWidth, height: anchorHeight)
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.green

        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.eulerAngles.x = -Float.pi/2
        planeNode.opacity = 0.25

        return planeNode
    }

}
