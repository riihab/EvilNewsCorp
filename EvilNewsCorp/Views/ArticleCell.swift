//
//  ArticleCell.swift
//  EvilNewsCorp
//
//  Created by Rihab Mehboob on 12/05/2024.
//

import Foundation
import UIKit
import Kingfisher

class ArticleCell: UICollectionViewCell {
    
    let titleBackground = UILabel()
    let titleLabel = UILabel()
    let idLabel = UILabel()
    let summaryLabel = UILabel()
    let dateLabel = UILabel()
    let imageView = UIImageView()
    
    let blurEffect = UIBlurEffect(style: .light)
    var visualEffectView = UIVisualEffectView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.contentView.layer.cornerRadius = frame.height*0.05
        visualEffectView.clipsToBounds = true
        visualEffectView.tintColor = .clear
        visualEffectView.backgroundColor = .clear
        visualEffectView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        visualEffectView.alpha = 1.0
        
        self.layer.borderColor = UIColor.black.withAlphaComponent(1).cgColor
        self.layer.borderWidth = 2
        
        titleBackground.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height*0.1)
        titleBackground.center.x = frame.width*0.5
        titleBackground.center.y = frame.height*0.05
        titleBackground.layer.backgroundColor = UIColor.white.withAlphaComponent(0.25).cgColor
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: frame.width*0.9, height: frame.height*0.2)
        titleLabel.center.x = frame.width*0.5
        titleLabel.center.y = frame.height*0.2
        titleLabel.font = FontKit.roundedFont(ofSize: frame.height*0.05, weight: .heavy)
        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor.black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 2
        titleLabel.accessibilityLabel = "Title"
        
        summaryLabel.frame = CGRect(x: 0, y: 0, width: frame.width*0.5, height: frame.height*0.675)
        summaryLabel.center.x = frame.width*0.3
        summaryLabel.center.y = frame.height*0.625
        summaryLabel.font = FontKit.roundedFont(ofSize: frame.height*0.1, weight: .regular)
        summaryLabel.textAlignment = .left
        summaryLabel.textColor = UIColor.black
        summaryLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        summaryLabel.adjustsFontSizeToFitWidth = true
        summaryLabel.numberOfLines = 0
        summaryLabel.accessibilityLabel = "Summary"
        
        dateLabel.frame = CGRect(x: 0, y: 0, width: frame.width*0.2, height: frame.height*0.05)
        dateLabel.center.x = frame.width*0.15
        dateLabel.center.y = frame.height*0.05
        dateLabel.font = FontKit.roundedFont(ofSize: frame.height*0.05, weight: .bold)
        dateLabel.textAlignment = .left
        dateLabel.textColor = UIColor.black
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.accessibilityLabel = "Date Published"
        
        idLabel.frame = CGRect(x: 0, y: 0, width: frame.width*0.2, height: frame.height*0.05)
        idLabel.center.x = frame.width*0.85
        idLabel.center.y = frame.height*0.05
        idLabel.font = FontKit.roundedFont(ofSize: frame.height*0.05, weight: .bold)
        idLabel.textAlignment = .right
        idLabel.textColor = UIColor.black
        idLabel.adjustsFontSizeToFitWidth = true
        idLabel.accessibilityLabel = "I.D"
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width*0.35, height: frame.width*0.35)
        imageView.center.x = frame.width*0.775
        imageView.center.y = frame.height*0.55
        imageView.layer.cornerRadius = frame.height*0.0875
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(1).cgColor
        imageView.layer.borderWidth = 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.accessibilityLabel = "Image"
        
        contentView.addSubview(visualEffectView)
        
        contentView.addSubview(titleBackground)
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(summaryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(idLabel)
        contentView.addSubview(imageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // Configuring the data in the CollectionViewCell
    func configure(with article: EvilDataNamespace.Datum) {
        let date = convertDateFormat(inputDate: article.datePublished)
        
        titleLabel.text = article.title
        summaryLabel.text = article.summary
        dateLabel.text = date // article.datePublished
        idLabel.text = "ID: \(article.id)"
        
        var url = "https://scheck.swipeandtap.co.uk\(article.image)?auth_token=LKjXmLlBmcMGdDOC"
        if article.image.contains("http") {
            url = article.image
        }
        setImageViaKF(urlString: url)
    }
    
    // Using KingFisher to help cache images
    func setImageViaKF(urlString: String?) {
        if let imageURL = urlString {
            imageView.isHidden = false
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: imageURL))
        } else {
            imageView.isHidden = true
        }
    }
    
    // Converting the date format
    func convertDateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let oldDate = olDateFormatter.date(from: inputDate)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd yyyy"
        
        return convertDateFormatter.string(from: oldDate!)
    }
}
