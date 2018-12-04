//
//  ViewController.swift
//  AnimalPeekABoo
//
//  Created by Yuichi Fujiki on 12/2/18.
//  Copyright © 2018 Yuichi Fujiki. All rights reserved.
//

import UIKit
import os

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var frameImageView: UIImageView!

    @IBOutlet weak var frameImageViewAspectRatioConstraint: NSLayoutConstraint!

    @IBOutlet weak var frameImageViewLeftConstraint: NSLayoutConstraint!

    @IBOutlet weak var frameImageViewTopConstraint: NSLayoutConstraint!

    private var scrollViewSize: CGSize = .zero

    private var images = [UIImage]()

    private var dragging = false

    lazy private var imageViews: [UIImageView] = {
        let imageViews = [
            UIImageView(frame: .zero),
            UIImageView(frame: .zero),
            UIImageView(frame: .zero)
        ]
        imageViews.forEach({ imageView in
            imageView.contentMode = .scaleAspectFit
        })
        return imageViews
    }()

    lazy private var fetcher: ImageFetcher = {
        return ImageFetcher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareImagesAndViews()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        if (size.width > size.height) {
            // landscape
            frameImageView.image = UIImage(named: "green-frame-landscape")
            frameImageViewAspectRatioConstraint.constant = 385.0/456.0;
            frameImageViewLeftConstraint.constant = 120
        } else {
            // portrait
            frameImageView.image = UIImage(named: "green-frame-portrait")
            frameImageViewAspectRatioConstraint.constant = 456.0/385.0
            frameImageViewLeftConstraint.constant = 32
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // This is the first point you know for sure that scroll view size is correctly figured out,
        // because all of the constraints and layouts are already calculated.
        // Refer https://qiita.com/shtnkgm/items/f133f73baaa71172efb2 (Sorry, Japanese reference)
        scrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: scrollViewSize.width * 3, height: scrollViewSize.height)
        scrollView.contentOffset = CGPoint(x: scrollViewSize.width, y: 0)
        layoutImages()
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
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        dragging = true
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        dragging = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !dragging {
            return
        }

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

