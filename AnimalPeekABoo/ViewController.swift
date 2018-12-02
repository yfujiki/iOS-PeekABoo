//
//  ViewController.swift
//  AnimalPeekABoo
//
//  Created by Yuichi Fujiki on 12/2/18.
//  Copyright © 2018 Yuichi Fujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    enum ImageViewPosition {
        case left
        case center
        case right
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var leftImage: (Int, UIImage)?
    private var centerImage: (Int, UIImage)?
    private var rightImage: (Int, UIImage)?
    
    lazy private var fetcher: ImageFetcher = {
        return ImageFetcher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        prepareImages()
    }

    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 3, height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
    }
    
    private func prepareImages() {
        if centerImage == nil {
            centerImage = fetcher.fetchRandomImage(exclude: nil)
        }
        
        leftImage = fetcher.fetchRandomImage(exclude: [centerImage!.0])
        rightImage = fetcher.fetchRandomImage(exclude: [centerImage!.0, leftImage!.0])
        
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width, y: 0)
        scrollView.addSubview(imageViewForImage(leftImage!.1, position: .left))
        scrollView.addSubview(imageViewForImage(centerImage!.1, position: .center))
        scrollView.addSubview(imageViewForImage(rightImage!.1, position: .right))
    }
    
    private func imageViewForImage(_ image: UIImage, position: ImageViewPosition) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        switch position {
        case .left:
            imageView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        case .center:
            imageView.frame = CGRect(x: scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        case .right:
            imageView.frame = CGRect(x: scrollView.frame.size.width * 2, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        }
        
        return imageView
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == scrollView.contentSize.width * 2 {
            // Scrolled to right
            centerImage = rightImage
            prepareImages()
        } else if scrollView.contentOffset.x == 0 {
            // Scrolled to left
            centerImage = leftImage
            prepareImages()
        } else {
            // Didn't move
        }
    }
}

