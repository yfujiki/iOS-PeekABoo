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
    
    private var imageViews = [UIImageView]()
    
    lazy private var fetcher: ImageFetcher = {
        return ImageFetcher()
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureScrollView()
        prepareInitialImageViews()
    }

    private func configureScrollView() {
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 5, height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * 2, y: 0)
    }
    
    private func prepareInitialImageViews() {
        
        (0..<5).forEach { (i) in
            let imageView = newImageViewAt(i)
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
    }
    
    private func newImageViewAt(_ index: Int) -> UIImageView {
        let image = fetcher.fetchRandomImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: scrollView.frame.size.width * CGFloat(index),
                                 y: 0,
                                 width: scrollView.frame.size.width,
                                 height: scrollView.frame.size.height)
        return imageView
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let originalContentOffset = scrollView.contentOffset
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * 2, y: 0)
        
        for var imageView in imageViews {
            var frame = imageView.frame
            frame.origin.x += scrollView.contentOffset.x - originalContentOffset.x
            imageView.frame = frame
        }
        
        if (imageViews[0].frame.origin.x < 0) {
            imageViews.remove(at: 0)
            let imageView = newImageViewAt(4)
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }

        if (imageViews[4].frame.origin.x > scrollView.frame.size.width * CGFloat(4)) {
            imageViews.remove(at: 4)
            let imageView = newImageViewAt(0)
            imageViews.insert(imageView, at: 0)
            scrollView.addSubview(imageView)
        }
    }
}

