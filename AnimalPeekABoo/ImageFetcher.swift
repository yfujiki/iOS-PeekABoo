//
//  ImageFetcher.swift
//  AnimalPeekABoo
//
//  Created by Yuichi Fujiki on 12/2/18.
//  Copyright © 2018 Yuichi Fujiki. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class ImageFetcher {
    private static let imageRects: [CGRect] = [
        CGRect(x: 0, y: 0, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 464 * UIScreen.main.scale, y: 0, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 928 * UIScreen.main.scale, y: 0, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 1392 * UIScreen.main.scale, y: 0, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 0, y: 463 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 464 * UIScreen.main.scale, y: 463 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 928 * UIScreen.main.scale, y: 463 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 1392 * UIScreen.main.scale, y: 463 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 0, y: 926 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 464 * UIScreen.main.scale, y: 926 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 928 * UIScreen.main.scale, y: 926 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 1392 * UIScreen.main.scale, y: 926 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 0, y: 1389 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 464 * UIScreen.main.scale, y: 1389 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 928 * UIScreen.main.scale, y: 1389 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
        CGRect(x: 1392 * UIScreen.main.scale, y: 1389 * UIScreen.main.scale, width: 464 * UIScreen.main.scale, height: 463 * UIScreen.main.scale),
    ]
    
    func fetchRandomImage() -> UIImage? {
        let randomIndex = Int.random(in: 0..<16)
        return fetchImageAt(index: randomIndex)
    }
    
    private func fetchImageAt(index: Int) -> UIImage? {
        let image = #imageLiteral(resourceName: "animals")
        let cgImage = image.cgImage
        let partCgImage = cgImage?.cropping(to: type(of:self).imageRects[index])
        
        guard let finalCgImage = partCgImage else {
            return nil
        }
        
        return UIImage(cgImage: finalCgImage)
    }
}
