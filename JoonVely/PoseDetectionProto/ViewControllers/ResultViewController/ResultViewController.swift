//
//  ResultViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/12/02.
//

import Foundation
import UIKit

class ResultViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        toSelectViewButton()
        showResult()
    }
    
    func showResult(){
        let inform = UIImage(named: "result")
        let informview = UIImageView(frame: CGRect(x: view.frame.minX - 10,
                                                   y: view.frame.minY,
                                                   width: view.frame.width,
                                                   height: view.frame.height * 0.8))
        informview.contentMode = .scaleAspectFit
        informview.image = inform
        
        view.addSubview(informview)
    }
    
    func toSelectViewButton(){
        let button = UIButton(frame: CGRect(x: view.frame.width*0.35,
                                            y: view.frame.height*0.8,
                                            width: view.frame.width*0.3,
                                            height: view.frame.height*0.1))
        button.setTitle("selectEX", for: UIControl.State.normal)
        button.setTitleColor(.white, for: UIControl.State.normal)
        button.backgroundColor = .red
        button.alpha = 0.7
        button.addTarget(self, action: #selector(toSelectView), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
    }
    
    @objc func toSelectView(_ sender: Any){
        self.performSegue(withIdentifier: "SelectViewSegue2", sender: nil)
        print("here")
    }
}
