//
//  ScrubberCollectionView.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/22/22.
//

import Foundation
import UIKit


protocol ScrubberDelegate : AnyObject {
    func didScrub(scrollView : UIScrollView)
}

class ScrubberView : UIView {
    
    var images = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ScrubberImageCell.self, forCellWithReuseIdentifier: ScrubberImageCell.identifier)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let currentTimeIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.text = "00:00"
        return label
    }()
    
    weak var delegate : ScrubberDelegate?
    
    init(){
        super.init(frame: .zero)
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: frame.width/2, bottom: 0, right: frame.width/2)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrub(scrollView: scrollView)
    }
    
    
    func updateTimeLabel(time: Double){
        timeLabel.text = time.timeFormatted()
    }
    
    private func setupViews(){
        addSubview(collectionView)
        collectionView.constrain(toView: self, top: 32, left: 0, right: 0, bottom: 16)
        addSubview(currentTimeIndicatorView)
        currentTimeIndicatorView.constrain(toView: self, bottom: 0)
        currentTimeIndicatorView.topAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        currentTimeIndicatorView.widthAnchor.constraint(equalToConstant: 5).isActive = true
        currentTimeIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addSubview(timeLabel)
        timeLabel.constrain(toView: self, top: 0)
        timeLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 8).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ScrubberView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrubberImageCell.identifier, for: indexPath) as? ScrubberImageCell {
            cell.setup(with: images[indexPath.row])
            return cell
        }

        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.size.height)
    }
    
    
}

