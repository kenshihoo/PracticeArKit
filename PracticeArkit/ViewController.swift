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
        
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    //画面が呼ばれる直前の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //空間認識をするARWorldTrackingConfigurationをインスタンス化
        let configuration = ARWorldTrackingConfiguration()
        //平面の検出を有効化
        configuration.planeDetection = [.horizontal]
        //ARセッションを開始
        sceneView.session.run(configuration)
    }

    //viewの表示が終了(アプリが閉じられたり)した場合の処理
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //ARセッションを停止
        sceneView.session.pause()
    }
    
    
    
    
    //平面を検出したらアンカー情報を元にノード(オブジェクト)を作成して、ルートノードに追加
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //引数anchorの値がnilでない場合に、createFloorを実行して、設置したオブジェクトをノードに追加
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return  }

        let floor = createFloor(from: planeAnchor)
        node.addChildNode(floor)
    }
    
    
    //平面情報が更新されたときの処理
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
    
    
    //平面に板状のオブジェクトを配置
    func createFloor(from anchor: ARPlaneAnchor) -> SCNNode{
    
        //表示させるオブジェクトのサイズに用いるためにアンカーをインスタンス化
        let anchorWidth  = CGFloat(anchor.extent.x)
        let anchorHeight = CGFloat(anchor.extent.z)

        //ノードの形状を設定
        let planeGeometry = SCNPlane(width: anchorWidth, height: anchorHeight)
        //ノードの色を設定
        planeGeometry.firstMaterial?.diffuse.contents = UIColor.green

        //ノードを設置
        let planeNode = SCNNode(geometry: planeGeometry)
        //X軸方向に-90度回転
        planeNode.eulerAngles.x = -Float.pi/2
        //透明度を設定
        planeNode.opacity = 0.6

        //planeNodeを設置
        return planeNode
    }
    
    //画面がタップされたときの処理
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        guard let currentFrame = sceneView.session.currentFrame else { return  }
                
        
               let homeskun = SCNScene(named: "SceneKit Asset Catalog.scnassets/Homeskun.scn")!
        sceneView.scene = homeskun
                
        
//                let viewWidth  = sceneView.bounds.width
//                let viewHeight = sceneView.bounds.height
//                let imagePlane = SCNPlane(width: viewWidth/6000, height: viewHeight/6000)
//                imagePlane.firstMaterial?.diffuse.contents = sceneView.snapshot()
//                imagePlane.firstMaterial?.lightingModel = .constant
//
//                let planeNode = SCNNode(geometry: imagePlane)
//                sceneView.scene.rootNode.addChildNode(planeNode)
//
//                var translation = matrix_identity_float4x4
//                translation.columns.3.z = -0.1
//                planeNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
    }
    
        

}
