//
//  ViewController.swift
//  AnimalPeekABoo
//
//  Created by Yuichi Fujiki on 12/2/18.
//  Copyright © 2018 Yuichi Fujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    private var scrollViewSize: CGSize = .zero

    private var images = [UIImage]()
    
    lazy private var imageViews = {
        [
            UIImageView(frame: .zero),
            UIImageView(frame: .zero),
            UIImageView(frame: .zero)
        ]
    }()
    
    lazy private var fetcher: ImageFetcher = {
        return ImageFetcher()
    }()
    
    private var firstLoad = true

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareImagesAndViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // This is the first point you know for sure that scroll view size is correctly figured out,
        // because all of the constraints and layouts are already calculated.
        // Refer https://qiita.com/shtnkgm/items/f133f73baaa71172efb2 (Sorry, Japanese reference)
        if (firstLoad) {
            scrollViewSize = scrollView.frame.size
            scrollView.contentSize = CGSize(width: scrollViewSize.width * 3, height: scrollViewSize.height)
            scrollView.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
            layoutImages()
            firstLoad = false
        }
    }
    
    private func prepareImagesAndViews() {
        (0..<3).forEach { i in
            let image = fetcher.fetchRandomImage()
            images.append(image)
            imageViews[i].image = image
            scrollView.addSubview(imageViews[i])
        }
    }
    
    private func layoutImages() {
        imageViews.enumerated().forEach { (index: Int, imageView: UIImageView) in
            imageView.image = images[index]
            imageView.frame = CGRect(x: scrollViewSize.width * CGFloat(index),
                                     y: 0,
                                     width: scrollViewSize.width,
                                     height: scrollViewSize.height)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        
        if (offsetX > scrollView.frame.size.width * 1.5) {
            let newImage = fetcher.fetchRandomImage()
            images.remove(at: 0)
            images.append(newImage)
            layoutImages()
            scrollView.contentOffset.x -= scrollViewSize.width
        }

        if (offsetX < scrollView.frame.size.width * 0.5) {
            let newImage = fetcher.fetchRandomImage()
            images.removeLast()
            images.insert(newImage, at: 0)
            layoutImages()
            scrollView.contentOffset.x += scrollViewSize.width
        }
    }
}

