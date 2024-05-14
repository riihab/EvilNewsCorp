//
//  MainView.swift
//  EvilNewsCorp
//
//  Created by Rihab Mehboob on 11/05/2024.
//

import Foundation
import UIKit

class MainView : UIView {
    
    var hasLayoutSubviewsBeenCalled = false
    var layoutSubviewsCompletion: (() -> Void)?
    
    let title = UILabel()
    
    let informationButton = UIButton()
    
    let backgroundGradient = CAGradientLayer()
    var titleVisualEffectView = UIVisualEffectView()
    var bottomVisualEffectView = UIVisualEffectView()
    
    let switchButton = UIButton()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.tintColor = .clear
        visualEffectView.backgroundColor = .white.withAlphaComponent(0.5)
        visualEffectView.frame = self.frame
        visualEffectView.alpha = 1.0
        addSubview(visualEffectView)
        
        collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "ArticleCell")
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        addSubview(collectionView)
        
        titleVisualEffectView = UIVisualEffectView(effect: blurEffect)
        titleVisualEffectView.tintColor = .clear
        titleVisualEffectView.backgroundColor = .white.withAlphaComponent(0.5)
        titleVisualEffectView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height*0.175)
        titleVisualEffectView.alpha = 1.0
        addSubview(titleVisualEffectView)
        
        title.textAlignment = .center
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        addSubview(title)
        title.accessibilityLabel = "Evil News Corp"
        
        informationButton.backgroundColor = UIColor.clear
        informationButton.tintColor = .black.withAlphaComponent(1)
        informationButton.isEnabled = true
        informationButton.isExclusiveTouch = true
        informationButton.adjustsImageWhenHighlighted = false
        informationButton.imageView?.contentMode = .scaleAspectFit
        addSubview(informationButton)
        informationButton.accessibilityLabel = "Information"
        
        bottomVisualEffectView = UIVisualEffectView(effect: blurEffect)
        bottomVisualEffectView.tintColor = .clear
        bottomVisualEffectView.backgroundColor = .white.withAlphaComponent(0.5)
        bottomVisualEffectView.frame = CGRect(x: 0, y: self.bounds.height*0.85, width: self.bounds.width, height: self.bounds.height*0.3)
        bottomVisualEffectView.alpha = 1.0
        addSubview(bottomVisualEffectView)
        
        switchButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        switchButton.tintColor = .white.withAlphaComponent(0.5)
        switchButton.isEnabled = true
        switchButton.isExclusiveTouch = true
        switchButton.adjustsImageWhenHighlighted = false
        switchButton.imageView?.contentMode = .scaleAspectFit
        switchButton.contentHorizontalAlignment = .center
        switchButton.titleLabel?.adjustsFontSizeToFitWidth = true
        switchButton.titleLabel?.numberOfLines = 1
        switchButton.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        switchButton.layer.borderWidth = 5
        addSubview(switchButton)
        switchButton.accessibilityLabel = "Switch between real and fake data"
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLayoutSubviewsBeenCalled {
            hasLayoutSubviewsBeenCalled = true
            
            let height = superview?.frame.height ?? 0
            let width = superview?.frame.width ?? 0
            
            // Set the cell size
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.bounds.width + 4, height: self.bounds.height*0.35)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumLineSpacing = -2
            
            collectionView.contentInset = UIEdgeInsets(top: self.bounds.height*0.1, left: 0, bottom: self.bounds.height*0.15, right: 0)
            collectionView.collectionViewLayout = layout
            collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            collectionView.center.x = self.bounds.width*0.5
            collectionView.center.y = self.bounds.height*0.5
            
            title.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.5, height: self.bounds.height*0.15)
            title.center.x = self.bounds.width*0.285
            title.center.y = self.bounds.height*0.125
            let attributeTitle = Attribute.outline(string: "Evil News Corp", font: FontKit.roundedFont(ofSize: self.bounds.height*0.1, weight: .black), outlineSize: 0, textColor: .black, outlineColor: .black)
            title.attributedText = attributeTitle
            
            informationButton.frame = CGRect(x: 0, y: 0, width: self.bounds.width*0.1, height: self.bounds.width*0.1)
            informationButton.center.x = width*0.9125
            informationButton.center.y = self.bounds.height*0.125
            let infoImageConfig = UIImage.SymbolConfiguration(pointSize: (width*0.1), weight: .bold, scale: .large)
            let infoImage = UIImage(systemName: "info.square.fill", withConfiguration: infoImageConfig)
            informationButton.setImage(infoImage, for: .normal)
            
            switchButton.frame = CGRect(x: 0, y: 0, width: width*0.85, height: height*0.08)
            switchButton.center.x = width*0.5
            switchButton.center.y = height*0.915
            switchButton.layer.cornerRadius = height*0.0225
            let attributeswitchButton = Attribute.outline(string: "Switch to fake data", font: FontKit.roundedFont(ofSize: height*0.03, weight: .bold), outlineSize: 0, textColor: .black, outlineColor: .black)
            switchButton.setAttributedTitle(attributeswitchButton, for: .normal)
            
            layoutSubviewsCompletion?()
        }
        
    }
    
    // Create the subtle background animation
    @objc func backgroundAnimation() {
        
        let randomDouble = Double.random(in: 0...1)
        
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
        
        let symbol = ["square.fill"]
        for i in -1...25 {
            for j in -1...10 {
                let backgroundButton = UIButton()
                backgroundButton.frame = CGRect(x: self.bounds.width*0.15*CGFloat(j) - self.bounds.width*0.2, y: self.bounds.width*0.15*CGFloat(i) - self.bounds.width*0.2, width: self.bounds.width*0.2, height: self.bounds.width*0.2)
                let configuration = UIImage.SymbolConfiguration(pointSize: CGFloat(self.bounds.width*0.1), weight: .heavy, scale: .large)
                let image = UIImage(systemName: "\(symbol.randomElement() ?? "")", withConfiguration: configuration)?.withTintColor(UIColor(hue: CGFloat(Double.random(in: randomDouble...randomDouble)), saturation: CGFloat(Double.random(in: 1...1)), brightness: CGFloat(Double.random(in: 1...1)), alpha: 1).withAlphaComponent(1), renderingMode: .alwaysOriginal)
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = image
                let imageString = NSAttributedString(attachment: imageAttachment)
                backgroundButton.setAttributedTitle(imageString, for: .normal)
                addSubview(backgroundButton)
                backgroundButton.tag = 999
                backgroundButton.alpha = 0.0
                sendSubviewToBack(backgroundButton)
                backgroundButton.accessibilityElementsHidden = true
                
                backgroundButton.alpha = 0.5
                UIView.animate(withDuration: TimeInterval(Double.random(in: 1...2)), delay: TimeInterval(Double(Double(i)+1)/10), usingSpringWithDamping: 100, initialSpringVelocity: 0, options: [.allowAnimatedContent, .autoreverse, .transitionFlipFromRight, .repeat], animations: {
                    backgroundButton.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    // Stops the background animation
    @objc func stopBackgroundAnimation() {
        for view in self.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func buttonExit(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
    @objc func buttonDown(_ sender: UIButton) {
        
        let impact = UISelectionFeedbackGenerator()
        impact.selectionChanged()
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 100, initialSpringVelocity: 10, options: [.allowAnimatedContent, .allowUserInteraction], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
        }, completion: nil)
    }
    
}
