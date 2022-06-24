//
//  ThumbnailGenerator.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/22/22.
//

import UIKit
import AVFoundation
import CoreMedia

protocol ThumbnailGeneratable {
    var assetURL : URL? { get }
    func generateThumbnails(completion: @escaping (([UIImage]?) -> Void))
}

extension ThumbnailGeneratable {
    func generateThumbnails(completion: @escaping (([UIImage]?) -> Void)) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = assetURL else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let asset = AVAsset(url: url)
            let assetImgGenerate = AVAssetImageGenerator(asset: asset)
            assetImgGenerate.appliesPreferredTrackTransform = true
            
            var time : CMTime = CMTime(value: 1, timescale: 1)
            var images = [UIImage]()
            
            while time < asset.duration {
                do {
                    let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                    let thumbnail = UIImage(cgImage: img)
                    images.append(thumbnail)
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    assertionFailure("Failed to generate thumbnails")
                    return
                }
                time = CMTimeAdd(time, CMTime(value: 5, timescale: 1))
            }
            DispatchQueue.main.async {
                completion(images)
            }
            
        }
    }
}
