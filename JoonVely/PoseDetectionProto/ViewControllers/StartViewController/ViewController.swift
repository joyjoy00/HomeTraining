//
//  ViewController.swift
//  PoseDetectionProto
//
//  Created by 정은서 on 2021/11/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Interface Variables
    var apptitle: UILabel!
    var logoImgView: UIImageView!
    var logoImg: UIImage!
    var startButton: UIButton!
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        loadAppTitle()
        loadLogoimg()
        addButton()
    }
    
    func loadAppTitle(){
        apptitle = UILabel(frame: CGRect(x: view.frame.width*0.2,
                                         y: view.frame.height*0.2,
                                         width: view.frame.width*0.6,
                                         height: view.frame.height/16))
       
        //apptitle 박스에 대한 속성
        apptitle.backgroundColor = .blue
        apptitle.alpha = 0.7
        apptitle.layer.shadowOffset = CGSize(width: 5, height: 5)
        apptitle.layer.shadowOpacity = 0.7
        apptitle.layer.shadowRadius = 5
        apptitle.layer.shadowColor = UIColor.gray.cgColor
//        apptitle.layer.cornerRadius = 10
//        apptitle.clipsToBounds = true
        
        //apptitle text에 대한 속성
        apptitle.text = "AI HomeTrainer"
        apptitle.font = UIFont(name: "Apple Color Emoji", size: 20)
        apptitle.textColor = .white
        apptitle.textAlignment = .center

//        apptitle.layer.cornerRadius = 300
        view.addSubview(apptitle)
    }
    
    func loadLogoimg(){
        logoImg = UIImage(named: "logo")
        
        logoImgView = UIImageView(frame: CGRect(x: view.frame.width * 0.2,
                                                y: view.frame.height * 0.35,
                                                width: view.frame.width * 0.6,
                                                height: view.frame.height/8))
        logoImgView.backgroundColor = .white
        logoImgView.image = logoImg
        logoImgView.contentMode = .scaleAspectFill
        
        // 둥근 테두리
//        logoImgView.layer.cornerRadius = 100
//        logoImgView.clipsToBounds = true
    
        // 그림자 clipsToBounds하니까 그림자까지 잘림
        logoImgView.layer.shadowOffset = CGSize(width: 5, height: 5)
        logoImgView.layer.shadowOpacity = 0.7
        logoImgView.layer.shadowRadius = 5
        logoImgView.layer.shadowColor = UIColor.gray.cgColor
        
        
        view.addSubview(logoImgView)
        print("here")
    }
    
    func addButton(){
        startButton = UIButton(frame: CGRect(x: view.frame.midX * 0.75,
                                             y: view.frame.midY * 1.5,
                                             width: view.frame.width/4,
                                             height: view.frame.height/16))
        startButton.backgroundColor = .red
        startButton.alpha = 0.7
        
        startButton.setTitle("START", for: UIControl.State.normal)
        startButton.titleLabel?.font = UIFont(name: "Apple Color Emoji", size: 20)
        
        startButton.addTarget(self, action: #selector(toSelectView), for: UIControl.Event.touchUpInside)
        view.addSubview(startButton)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "SelectViewSegue" {
            if let vc = segue.destination as? SelectViewController {

            }
        }
    }

    @objc func toSelectView(_ sender: Any){
        self.performSegue(withIdentifier: "SelectViewSegue", sender: nil)
        print("here")
    }

}

