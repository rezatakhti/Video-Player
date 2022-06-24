//
//  VideoPlayerVIew.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/23/22.
//

import UIKit
import AVFoundation

class VideoPlayerView : UIView{
    let playButton : UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        button.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let player : AVPlayer
    var videoIsPlaying = false
    let playerLayer : AVPlayerLayer
    
    init(player: AVPlayer){
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        super.init(frame: .zero)
        setupPlayer()
        setupViews()
        
    }
    
    private func setupViews() {
        addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
    }
    
    @objc private func playButtonPressed(){
        videoIsPlaying.toggle()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        if videoIsPlaying {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: largeConfig)?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlayer(){
        backgroundColor = .clear
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
    }
}
