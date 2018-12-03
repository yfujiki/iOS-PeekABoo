//
//  ViewController.swift
//  AnimalPeekABoo
//
//  Created by Yuichi Fujiki on 12/2/18.
//  Copyright © 2018 Yuichi Fujiki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Image {
        let indexInSprite: Int
        let image: UIImage
    }
    
    struct ImageView {
        let indexInSprite: Int
        let imageView: UIImageView
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var imageViews = [ImageView]()
    
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
    
    private func excludeIndexes() -> [Int] {
        return imageViews.map { (imageView) -> Int in
            imageView.indexInSprite
        }
    }
    
    private func prepareInitialImageViews() {
        
        (0..<5).forEach { (i) in
            let imageView = newImageViewAt(i)
            imageViews.append(ImageView(indexInSprite: imageView.indexInSprite, imageView: imageView.imageView))
        }
        
        for var imageView in imageViews {
            scrollView.addSubview(imageView.imageView)
        }
    }
    
    private func newImageViewAt(_ index: Int) -> ImageView {
        let image = fetcher.fetchRandomImage(exclude: excludeIndexes())
        let imageView = UIImageView(image: image!.1)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: scrollView.frame.size.width * CGFloat(index),
                                 y: 0,
                                 width: scrollView.frame.size.width,
                                 height: scrollView.frame.size.height)
        return ImageView(indexInSprite: image!.0, imageView: imageView)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let originalContentOffset = scrollView.contentOffset
        scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * 2, y: 0)
        
        for var imageView in imageViews {
            var frame = imageView.imageView.frame
            frame.origin.x += scrollView.contentOffset.x - originalContentOffset.x
            imageView.imageView.frame = frame
        }
        
        if (imageViews[0].imageView.frame.origin.x < 0) {
            imageViews.remove(at: 0)
            let imageView = newImageViewAt(4)
            imageViews.append(imageView)
            scrollView.addSubview(imageView.imageView)
        }

        if (imageViews[4].imageView.frame.origin.x > scrollView.frame.size.width * CGFloat(4)) {
            imageViews.remove(at: 4)
            let imageView = newImageViewAt(0)
            imageViews.insert(imageView, at: 0)
            scrollView.addSubview(imageView.imageView)
        }
    }
}

