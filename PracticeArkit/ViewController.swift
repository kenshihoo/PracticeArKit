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
    
    //画面が呼ばれる直前の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //平面を検出
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        //セッションを開始
        sceneView.session.run(configuration)
    }

    //画面遷移が完了し、画面表示がされた際の処理
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //セッションを停止
        sceneView.session.pause()
    }
    
    
    //平面を検出したらアンカー情報を元にノード(オブジェクト)を作成して、ルートノードに追加
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return  }

        let floor = createFloor(from: planeAnchor)
        node.addChildNode(floor)
    }

    
    //平面に板状のオブジェクトを配置
    func createFloor(from anchor: ARPlaneAnchor) -> SCNNode{
    
        //表示させるオブジェクトのサイズに用いるアンカーをインスタンス化
        let anchorWidth  = CGFloat(anchor.extent.x)
        let anchorHeight = CGFloat(anchor.extent.z)

        //プレーンノードを設定
        let planeGeometry = SCNPlane(width: anchorWidth, height: anchorHeight)
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.green

        //プレーンノードを元にオブジェクトを作成
        let planeNode = SCNNode(geometry: planeGeometry)
        //X軸方向に-90度回転
        planeNode.eulerAngles.x = -Float.pi/2
        //透明度を設定
        planeNode.opacity = 0.25

        return planeNode
    }
    //    //平面情報が更新されたときの処理
    //    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    //        guard let planeAnchor = anchor as? ARPlaneAnchor,
    //                   let planeNode = node.childNodes.first,
    //                   let planeNodeGeometry = planeNode.geometry as? SCNPlane
    //            else { return }
    //
    //        let updatedPosition = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
    //        planeNode.position = updatedPosition
    //
    //        planeNodeGeometry.width  = CGFloat(planeAnchor.extent.x)
    //        planeNodeGeometry.height = CGFloat(planeAnchor.extent.z)
    //    }

}
