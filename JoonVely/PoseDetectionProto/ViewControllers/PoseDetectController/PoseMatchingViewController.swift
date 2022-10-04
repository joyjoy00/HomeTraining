////
////  PoseMatchingViewController.swift
////  PoseEstimation-CoreML
////
////  Created by Doyoung Gwak on 13/08/2019.
////  Copyright © 2019 tucan9389. All rights reserved.
////
//
//import UIKit
//import CoreMedia
//import Vision
//
//class PoseMatchingViewController: UIViewController {
//
//    // MARK: modified by eunseo
//    var count = 0
//    var resultLabel: UILabel!
//    var capButton: UIButton!
//    var stage: String = "normal"
//
//    // MARK: - UI Property
//    @IBOutlet weak var videoPreview: UIView!
//    @IBOutlet weak var jointView: DrawingJointView!
//    @IBOutlet var capturedJointViews: [DrawingJointView]!
//    @IBOutlet var capturedJointConfidenceLabels: [UILabel]!
//    @IBOutlet var capturedJointBGViews: [UIView]!
//    var capturedPointsArray: [[CapturedPoint?]?] = []
//
//    var capturedIndex = 0
//
//    // MARK: - AV Property
//    var videoCapture: VideoCapture!
//    
//    // MARK: - ML Properties
//    // Core ML model
//    typealias EstimationModel = model_cpm
//
//    // Preprocess and Inference
//    var request: VNCoreMLRequest?
//    var visionModel: VNCoreMLModel?
//
//    // Postprocess
//    var postProcessor: HeatmapPostProcessor = HeatmapPostProcessor()
//    var mvfilters: [MovingAverageFilter] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        toResultViewButton()
//        // setup the drawing views
//        setUpCapturedJointView()
//
//        // setup the model
//        setUpModel()
//
//        // setup camera
//        setUpCamera()
//
//        capButtonGen()
//
//        countLabel()
//    }
//
//    func capButtonGen(){
//        capButton = UIButton(frame: CGRect(x: view.frame.width * 0.3,
//                                           y: view.frame.height * 0.5,
//                                           width: view.frame.width * 0.4,
//                                           height: view.frame.height * 0.1))
//        capButton.setTitle("Capture🕺", for: .normal)
//        capButton.setTitleColor(.systemBlue, for: .normal)
//        capButton.backgroundColor = .white
//
//        capButton.addTarget(self, action: #selector(tapCapture(_:)), for: UIControl.Event.touchUpInside)
//        view.addSubview(capButton)
//
//    }
//
//    func countLabel(){
//        resultLabel = UILabel(frame: CGRect(x: view.frame.width * 0.3,
//                                            y: view.frame.height * 0.1,
//                                            width: view.frame.width * 0.4,
//                                            height: view.frame.height * 0.1))
//
//        resultLabel.backgroundColor = .white
//        resultLabel.text = String(count)
//        resultLabel.textAlignment = .center
//        resultLabel.font = UIFont.systemFont(ofSize: 20)
//
//        view.addSubview(resultLabel)
//
//    }
//
//    func countUp(){
//        count += 1
//        resultLabel.text = String(count)
//        resultLabel.textColor = .systemBlue
//    }
//
//    func toResultViewButton(){
//        let button = UIButton(frame: CGRect(x: view.frame.width*0.35,
//                                            y: view.frame.height*0.8,
//                                            width: view.frame.width*0.3,
//                                            height: view.frame.height*0.1))
//        button.setTitle("Result", for: UIControl.State.normal)
//        button.setTitleColor(.white, for: UIControl.State.normal)
//        button.backgroundColor = .red
//        button.alpha = 0.7
//        button.addTarget(self, action: #selector(toResultView), for: UIControl.Event.touchUpInside)
//        view.addSubview(button)
//    }
//
//    @objc func toResultView(_ sender: Any){
//        self.performSegue(withIdentifier: "ResultViewSegue", sender: nil)
//        print("here")
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.videoCapture.start()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.videoCapture.stop()
//    }
//
//    // MARK: - Setup Captured Joint View
//    func setUpCapturedJointView() {
//        postProcessor.onlyBust = true
//
//        for capturedJointView in capturedJointViews {
//            capturedJointView.layer.borderWidth = 2
//            capturedJointView.layer.borderColor = UIColor.gray.cgColor
//        }
//
//        capturedPointsArray = capturedJointViews.map { _ in return nil }
//
//        for currentIndex in 0..<capturedPointsArray.count {
//            // retrieving a value for a key
//            if let data = UserDefaults.standard.data(forKey: "points-\(currentIndex)"),
//                let capturedPoints = NSKeyedUnarchiver.unarchiveObject(with: data) as? [CapturedPoint?] {
//                capturedPointsArray[currentIndex] = capturedPoints
//                capturedJointViews[currentIndex].bodyPoints = capturedPoints.map { capturedPoint in
//                    if let capturedPoint = capturedPoint { return PredictedPoint(capturePoint: capturedPoint) }
//                    else { return nil }
//                }
//            }
//        }
//    }
//
//    // MARK: - Setup Core ML
//    func setUpModel() {
//        if let visionModel = try? VNCoreMLModel(for: EstimationModel().model) {
//            self.visionModel = visionModel
//            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
//            request?.imageCropAndScaleOption = .centerCrop
//        } else {
//            fatalError("cannot load the ml model")
//        }
//    }
//
//    // MARK: - SetUp Video
//    func setUpCamera() {
//        videoCapture = VideoCapture()
//        videoCapture.delegate = self
//        videoCapture.fps = 30
//        videoCapture.setUp(sessionPreset: .vga640x480, cameraPosition: .front) { success in
//
//            if success {
//                // add preview view on the layer
//                if let  previewLayer = self.videoCapture.previewLayer {
//                    DispatchQueue.main.async {
//                        self.videoPreview.layer.addSublayer(previewLayer)
//                        self.resizePreviewLayer()
//                    }
//                }
//
//                // start video preview when setup is done
//                self.videoCapture.start()
//            }
//        }
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        resizePreviewLayer()
//    }
//
//    func resizePreviewLayer() {
//        videoCapture.previewLayer?.frame = videoPreview.bounds
//    }
//
//    // CAPTURE THE CURRENT POSE
//    @objc func tapCapture(_ sender: Any) {
//        let currentIndex = capturedIndex % capturedJointViews.count
//        let capturedJointView = capturedJointViews[currentIndex]
//
//        let predictedPoints = jointView.bodyPoints
//        capturedJointView.bodyPoints = predictedPoints
//        let capturedPoints: [CapturedPoint?] = predictedPoints.map { predictedPoint in
//            guard let predictedPoint = predictedPoint else { return nil }
//            return CapturedPoint(predictedPoint: predictedPoint)
//        }
//
//        print("index \(capturedIndex): ", capturedPoints.first)
//        capturedPointsArray[currentIndex] = capturedPoints
//
//        let encodedData = NSKeyedArchiver.archivedData(withRootObject: capturedPoints)
//        UserDefaults.standard.set(encodedData, forKey: "points-\(currentIndex)")
//        print(UserDefaults.standard.synchronize())
//
//        capturedIndex += 1
//    }
//}
//
//// MARK: - VideoCaptureDelegate
//extension PoseMatchingViewController: VideoCaptureDelegate {
//    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer, timestamp: CMTime) {
//        // the captured image from camera is contained on pixelBuffer
//        predictUsingVision(pixelBuffer: pixelBuffer)
//    }
//}
//
//extension PoseMatchingViewController {
//    // MARK: - Inferencing
//    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
//        guard let request = request else { fatalError() }
//        // vision framework configures the input size of image following our model's input configuration automatically
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
//        try? handler.perform([request])
//    }
//
//    // MARK: - Postprocessing
//    func visionRequestDidComplete(request: VNRequest, error: Error?) {
//        guard let observations = request.results as? [VNCoreMLFeatureValueObservation],
//            let heatmaps = observations.first?.featureValue.multiArrayValue else { return }
//
//        /* =================================================================== */
//        /* ========================= post-processing ========================= */
//
//        /* ------------------ convert heatmap to point array ----------------- */
//        var predictedPoints = postProcessor.convertToPredictedPoints(from: heatmaps, isFlipped: true)
//
//        /* --------------------- moving average filter ----------------------- */
//        if predictedPoints.count != mvfilters.count {
//            mvfilters = predictedPoints.map { _ in MovingAverageFilter(limit: 3) }
//        }
//        for (predictedPoint, filter) in zip(predictedPoints, mvfilters) {
//            filter.add(element: predictedPoint)
//        }
//        predictedPoints = mvfilters.map { $0.averagedValue() }
//        /* =================================================================== */
//
//        let matchingRatios = capturedPointsArray
//            .map { $0?.matchVector(with: predictedPoints) }
//            .compactMap { $0 }
//
//
//
//        /* =================================================================== */
//        /* ======================= display the results ======================= */
//        DispatchQueue.main.sync { [weak self] in
//            guard let self = self else { return }
//            // draw line
//            self.jointView.bodyPoints = predictedPoints
//
//            var topCapturedJointBGView: UIView?
//            var maxMatchingRatio: CGFloat = 0
//            for (matchingRatio, (capturedJointBGView, capturedJointConfidenceLabel)) in zip(matchingRatios, zip(self.capturedJointBGViews, self.capturedJointConfidenceLabels)) {
//                let text = String(format: "%.2f%", matchingRatio*100)
//                capturedJointConfidenceLabel.text = text
//                capturedJointBGView.backgroundColor = .clear
//                print("center: ",capturedJointBGView.center)
//
//                print("text: ", text)
//
//                if matchingRatio > 0.85 && capturedJointBGView == capturedJointBGViews[0]{
//                    if stage == "normal" || stage == "none" {
//                        print("view first: ", stage)
//                        stage = "normal"
//                    }else if stage == "motioning"{
//                        print("view motion: ", stage)
//                        countUp()
//                        stage = "normal"
//                    }
//
//                }else if matchingRatio > 0.85 && capturedJointBGView == capturedJointBGViews[1]{
//                    print("view motion")
//                    stage = "motioning"
//                }
//
//                if matchingRatio > 0.85 && maxMatchingRatio < matchingRatio {
//                    maxMatchingRatio = matchingRatio
//                    topCapturedJointBGView = capturedJointBGView
//                }
//            }
//            topCapturedJointBGView?.backgroundColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 0.4)
////            print(matchingRatios)
//        }
//        /* =================================================================== */
//    }
//}
