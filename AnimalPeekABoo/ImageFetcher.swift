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

    func fetchRandomImage() -> UIImage {
        let randomIndex = Int.random(in: 0..<16)
        return fetchImageAt(index: randomIndex)
    }
    
    private func fetchImageAt(index: Int) -> UIImage {
        return UIImage(named: String(index))!
    }
}
