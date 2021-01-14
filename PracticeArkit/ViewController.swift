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
    
        //上記まででARSCNViewの設定と平面検出ができるようになっている//
    
    //画面がタップされたときの処理
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        // sceneView上でタップした座標を検出
        let tapPoint = sender.location(in: sceneView)
        let results = sceneView.hitTest(tapPoint, types: .existingPlaneUsingExtent)
        let hitPoint = results.first
        
        // 現実世界の座標に変換
        let point = SCNVector3()
        
        //タップされた場所にオブジェクトを設置
        let box = SCNBox(width: 0.25, height: 0.25, length: 0.25, chamferRadius: 0)
        let node = SCNNode(geometry: box)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    
    
    
    
    //    //平面を検出したらアンカー情報を元にノード(オブジェクト)を作成して、ルートノードに追加
    //    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    //        //引数anchorの値がnilでない場合に、createFloorを実行して、設置したオブジェクトをノードに追加
    //        guard let planeAnchor = anchor as? ARPlaneAnchor else { return  }
    //
    //        let floor = createFloor(from: planeAnchor)
    //        node.addChildNode(floor)
    //    }
        
        

        
    //    //平面に設置する板状のオブジェクトを生成
    //    func createFloor(from anchor: ARPlaneAnchor) -> SCNNode{
    //
    //        //表示させるオブジェクトのサイズに用いるためにアンカーをインスタンス化
    //        let anchorWidth  = CGFloat(anchor.extent.x)
    //        let anchorHeight = CGFloat(anchor.extent.z)
    //
    //        //ノードの形状を設定
    //        let planeGeometry = SCNPlane(width: anchorWidth, height: anchorHeight)
    //        //ノードの色を設定
    //        planeGeometry.firstMaterial?.diffuse.contents = UIColor.green
    //
    //        //ノードを設置
    //        let planeNode = SCNNode(geometry: planeGeometry)
    //        //X軸方向に-90度回転
    //        planeNode.eulerAngles.x = -Float.pi/2
    //        //透明度を設定
    //        planeNode.opacity = 0.6
    //
    //        return planeNode
    //    }
    
    
    
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
