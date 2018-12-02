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
        CGRect(x: 0, y: 0, width: 464, height: 463),
        CGRect(x: 464, y: 0, width: 464, height: 463),
        CGRect(x: 928, y: 0, width: 464, height: 463),
        CGRect(x: 1392, y: 0, width: 464, height: 463),
        CGRect(x: 0, y: 463, width: 464, height: 463),
        CGRect(x: 464, y: 463, width: 464, height: 463),
        CGRect(x: 928, y: 463, width: 464, height: 463),
        CGRect(x: 1392, y: 463, width: 464, height: 463),
        CGRect(x: 0, y: 926, width: 464, height: 463),
        CGRect(x: 464, y: 926, width: 464, height: 463),
        CGRect(x: 928, y: 926, width: 464, height: 463),
        CGRect(x: 1392, y: 926, width: 464, height: 463),
        CGRect(x: 0, y: 1389, width: 464, height: 463),
        CGRect(x: 464, y: 1389, width: 464, height: 463),
        CGRect(x: 928, y: 1389, width: 464, height: 463),
        CGRect(x: 1392, y: 1389, width: 464, height: 463),
    ]
    
    func fetchImageAt(index: Int) -> UIImage? {
        let image = #imageLiteral(resourceName: "animals")
        let cgImage = image.cgImage
        let partCgImage = cgImage?.cropping(to: type(of:self).imageRects[index])
        
        guard let finalCgImage = partCgImage else {
            return nil
        }
        
        return UIImage(cgImage: finalCgImage)
    }
}
