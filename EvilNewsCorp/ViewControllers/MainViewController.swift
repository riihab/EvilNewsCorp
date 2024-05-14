//
//  MainViewController.swift
//  EvilNewsCorp
//
//  Created by Rihab Mehboob on 11/05/2024.
//

import Foundation
import UIKit
import Speech

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var mainView = MainView()
    
    var articles: [EvilDataNamespace.Datum] = []
    
    var audioEngine: AVAudioEngine!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let recognizer = SFSpeechRecognizer()
    var previousRecognizedText = ""
    
    var defaults = UserDefaults.standard
    var appOpenCount = 0
    
    var isUsingRealData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        view.backgroundColor = UIColor.white
        
        mainView = MainView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        mainView.center.x = view.bounds.width*0.5
        mainView.center.y = view.bounds.height*0.5
        mainView.alpha = 0
        view.addSubview(mainView)
        
        mainView.layoutSubviewsCompletion = {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
                self.mainView.alpha = 1
            }, completion: nil)
            self.mainView.backgroundAnimation()
            
            self.postRequest()
            self.startRecording()
            
            self.appOpenCount = self.defaults.value(forKey: "appOpenCount") as? Int ?? 0
            self.appOpenCount += 1
            self.defaults.set(self.appOpenCount, forKey: "appOpenCount")
            self.defaults.synchronize()
            switch self.appOpenCount {
            case 1:
                self.howToInfo()
            default:
                break;
            }
        }
        
        self.mainView.collectionView.dataSource = self
        self.mainView.collectionView.delegate = self
        
        mainView.informationButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        mainView.informationButton.addTarget(self, action: #selector(informationAction(_:)), for: .touchUpInside)
        mainView.informationButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
        mainView.switchButton.addTarget(self, action: #selector(buttonDown(_:)), for: .touchDown)
        mainView.switchButton.addTarget(self, action: #selector(switchAction(_:)), for: .touchUpInside)
        mainView.switchButton.addTarget(self, action: #selector(buttonExit(_:)), for: .touchDragExit)
        
    }
    
    // Calling the API for latest articles
    func postRequest() {
        EvilNewsCorp.postRequest() { (result, error) in
            if let result = result {
                print("success: \(result)")
                self.articles = result.articles.data
                DispatchQueue.main.async {
                    self.mainView.collectionView.reloadData()
                }
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // Getting the JSON data from the BasicJSONData file
    func loadArticlesFromJSON() {
        guard let url = Bundle.main.url(forResource: "BasicJSONData", withExtension: "json") else {
            print("JSON file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let articlesData = try JSONDecoder().decode(EvilDataNamespace.EvilData.self, from: data)
            self.articles = articlesData.articles.data
            DispatchQueue.main.async {
                self.mainView.collectionView.reloadData()
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    // Called when the screen is shaken
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shake Gesture Detected")
            mainView.backgroundAnimation()
        }
    }
    
    // Starts recognising audio and acts on it
    @objc func startRecording() {
        audioEngine = AVAudioEngine()
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognizer?.supportsOnDeviceRecognition = true
        
        guard let recognitionRequest = recognitionRequest else { return }
        
        let inputNode = audioEngine.inputNode
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
        
        recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
            
            // Handle recognition results and errors
            if let result = result {
                let newRecognizedText = result.bestTranscription.formattedString
                let newWords = newRecognizedText.replacingOccurrences(of: self.previousRecognizedText, with: "")
                print("New words added: \(newWords)")
                self.previousRecognizedText = newRecognizedText
                
                if newWords.lowercased().contains("up") {
                    print("Word 'Up' detected!")
                    let contentOffset = CGFloat(floor(self.mainView.collectionView.contentOffset.y - self.view.bounds.size.height*0.35 + 2))
                    self.mainView.collectionView.setContentOffset(CGPoint(x: self.mainView.collectionView.contentOffset.x, y: contentOffset), animated: true)
                } else if newWords.lowercased().contains("down") {
                    print("Word 'Down' detected!")
                    let contentOffset = CGFloat(floor(self.mainView.collectionView.contentOffset.y + self.view.bounds.size.height*0.35 - 2))
                    self.mainView.collectionView.setContentOffset(CGPoint(x: self.mainView.collectionView.contentOffset.x, y: contentOffset), animated: true)
                }
                
            } else if let error = error {
                print("Recognition error: \(error)")
            }
        }
    }
    
    // When tapping on the switch button
    @objc func switchAction(_ sender: UIButton) {
        mainView.buttonExit(sender)
        if isUsingRealData {
            isUsingRealData = false
            self.loadArticlesFromJSON()
            let attributeAddButton = Attribute.outline(string: "Switch to real data", font: FontKit.roundedFont(ofSize: self.view.bounds.height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            self.mainView.switchButton.setAttributedTitle(attributeAddButton, for: .normal)
        } else {
            isUsingRealData = true
            self.postRequest()
            let attributeAddButton = Attribute.outline(string: "Switch to fake data", font: FontKit.roundedFont(ofSize: self.view.bounds.height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            self.mainView.switchButton.setAttributedTitle(attributeAddButton, for: .normal)
        }
    }
    
    // When tapping on the information button
    @objc func informationAction(_ sender: UIButton) {
        mainView.buttonExit(sender)
        howToInfo()
    }
    
    // Information popup
    @objc func howToInfo() {
        let title = "Information"
        let description = "View the latest stories in a feed!\n\nFeatures:\n- Shake the device to change the theme\n- Say 'Down'/'Up' to control the feed"
        let alert = UIAlertController(title: "\(title)", message: "\(description)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: { action in
            switch action.style {
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            default:
                print("default")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        cell.configure(with: articles[indexPath.row])
        return cell
    }
    
    // Tapped on a CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EvilNewsCorp.postRequest(id: articles[indexPath.row].id) { (result, error) in
            if let result = result {
                print("success: \(result)")
                let body = result.article.body.html2AttributedString
                DispatchQueue.main.async {
                    let title = "Full Article"
                    let description = body
                    let alert = UIAlertController(title: "\(title)", message: description, preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "I've finished reading", style: .default, handler: { action in
                        switch action.style {
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        default:
                            print("default")
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func buttonExit(_ sender: UIButton) {
        mainView.buttonExit(sender)
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        mainView.buttonDown(sender)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func didEnterForeground(_ notification: Notification) {
        mainView.backgroundAnimation()
    }
    
}

extension String {
    var html2AttributedString: String? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
}
