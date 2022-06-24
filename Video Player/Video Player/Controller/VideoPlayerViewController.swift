//
//  AVPlayerViewController.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/21/22.
//

import UIKit
import AVFoundation

class VideoPlayerViewController : UIViewController, ThumbnailGeneratable {
    let videoView : VideoPlayerView
    let scrubberView : ScrubberView
    var observerToken : Any?
    let assetURL : URL?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        startObserving()
        resetTimer()
        setupTapGestureRecognizer()
        generateThumbnails()
    }
    
    init(){
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "video", ofType:"mov") ?? "")
        videoView = VideoPlayerView(player: AVPlayer(url: url))
        scrubberView = ScrubberView()
        self.assetURL = url
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupPlayer(){
        view.addSubview(videoView)
        view.addSubview(scrubberView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            videoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1)
        ])
        
        scrubberView.delegate = self
        scrubberView.constrain(toView: self.view, left: 0, right: 0, bottom: 0)
        scrubberView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func setupTapGestureRecognizer(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleControls))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func generateThumbnails(){
        generateThumbnails { [weak self] images in
            guard let self = self else { return }
            if let images = images {
                self.scrubberView.images = images
            }
        }
    }
    
    @objc private func toggleControls(){
        videoView.playButton.isHidden ? showControls() : hideControls()
        resetTimer()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(hideControls), userInfo: nil, repeats: false)
    }
    
    
    private func showControls(){
        self.videoView.playButton.isHidden = false
        self.scrubberView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.videoView.playButton.alpha = 1
            self.scrubberView.alpha = 1
        }
    }
    
    @objc private func hideControls(){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.videoView.playButton.alpha = 0
            self.scrubberView.alpha = 0
            
        } completion: { _ in
            self.videoView.playButton.isHidden = true
            self.scrubberView.isHidden = true
        }
    }
    
    private func startObserving(){
        let interval = CMTime(seconds: 0.05, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        self.observerToken = videoView.player.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { (time) in
            guard !self.scrubberView.collectionView.isDragging else { return }
            
            let duration = self.videoView.player.currentItem!.duration.seconds
            let seekTime = self.videoView.player.currentTime().seconds
            let contentSize = self.scrubberView.collectionView.contentSize
            
            self.scrubberView.updateTimeLabel(time: self.videoView.player.currentTime().seconds)
            self.scrubberView.collectionView.bounds.origin = CGPoint(x: -self.scrubberView.collectionView.contentInset.left + (seekTime / duration) * contentSize.width, y: 0)
        })
    }
    
    
}

extension VideoPlayerViewController : ScrubberDelegate {
    func didScrub(scrollView : UIScrollView) {
        guard let currentItem = videoView.player.currentItem, scrollView.contentSize.width > 0 else { return }
        let currentOffset = scrollView.contentOffset.x + self.scrubberView.collectionView.contentInset.left
        let offsetPercentage = currentOffset/scrollView.contentSize.width
        let seekTime = offsetPercentage * currentItem.duration.seconds
        self.scrubberView.updateTimeLabel(time: currentItem.currentTime().seconds)
        let time = CMTime(value: CMTimeValue(seekTime), timescale: 1)
        videoView.player.seek(to: time)
    }
}
