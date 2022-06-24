//
//  ScrubberImageCell.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/23/22.
//

import UIKit

class ScrubberImageCell : UICollectionViewCell {
    
    static let identifier = "ScrubberImageCellIdentifier"
    
    private let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(imageView)
        imageView.constrain(toView: self, top: 0, left: 0, right: 0, bottom: 0)
    }
    
    func setup(with image: UIImage?){
        self.imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
