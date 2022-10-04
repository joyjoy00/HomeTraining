//
//  startViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/22.
//
import UIKit
import Foundation

class SelectViewController: UIViewController{
    
    
    var requireExer: UILabel!
    var plankButton: UIButton!
    var squatButton: UIButton!
    var lungeButton: UIButton!
    var burpeeButton: UIButton!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        createOutlet()
        selectExerButton()
    }
    
    func createOutlet(){
        
        requireExer = UILabel(frame: CGRect(x: view.frame.width*0.1,
                                            y: view.frame.height*0.15,
                                            width: view.frame.width*0.8,
                                            height: view.frame.height*0.1))
        requireExer.backgroundColor = .clear
        
        requireExer.text = "Select Exerciese!"
        requireExer.font = UIFont(name: "Apple Color Emoji", size: 25)
        requireExer.textColor = .black
        requireExer.textAlignment = .center
        
        view.addSubview(requireExer)
        
    }
    
    func selectExerButton(){
        
        plankButton = UIButton(frame: CGRect(x: view.frame.width*0.1,
                                             y: view.frame.height*0.3,
                                             width: view.frame.width*0.8,
                                             height: view.frame.height*0.1))
        
        plankButton.setImage(UIImage(named: "plank"), for: UIControl.State.normal)
        plankButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        squatButton = UIButton(frame: CGRect(x: view.frame.width*0.1,
                                             y: view.frame.height*0.45,
                                             width: view.frame.width*0.8,
                                             height: view.frame.height*0.1))
        
        squatButton.setImage(UIImage(named: "squat"), for: UIControl.State.normal)
        squatButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)

        
        lungeButton = UIButton(frame: CGRect(x: view.frame.width*0.1,
                                             y: view.frame.height*0.6,
                                             width: view.frame.width*0.8,
                                             height: view.frame.height*0.1))
        
        lungeButton.setImage(UIImage(named: "lunge"), for: UIControl.State.normal)
        lungeButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        burpeeButton = UIButton(frame: CGRect(x: view.frame.width*0.1,
                                             y: view.frame.height*0.75,
                                             width: view.frame.width*0.8,
                                             height: view.frame.height*0.1))
        
        burpeeButton.setImage(UIImage(named: "burpee"), for: UIControl.State.normal)
        burpeeButton.addTarget(self, action: #selector(toDetectView), for: UIControl.Event.touchUpInside)
        
        view.addSubview(plankButton)
        view.addSubview(squatButton)
        view.addSubview(lungeButton)
        view.addSubview(burpeeButton)
        
    }
    
    @objc func toDetectView(_ sender: UIButton){
        performSegue(withIdentifier: "InformViewSegue", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "InformViewSegue" {
            if let vc = segue.destination as? InformViewController {
                let button = sender as? UIButton
                if button == plankButton {
                    vc.exerKind = "PLANK"
                }else if button == squatButton {
                    vc.exerKind = "SQUAT"
                }else if button == lungeButton {
                    vc.exerKind = "LUNGE"
                }else if button == burpeeButton {
                    vc.exerKind = "BURPEE"
                }else{
                    fatalError("anything came into")
                }
            }
        }
    }
    

}
