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

    @IBOutlet weak var frameImageViewAspectRatioConstraintLandscape: NSLayoutConstraint!

    @IBOutlet weak var frameImageViewAspectRatioConstraintPortrait: NSLayoutConstraint!

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewConstraints(to: view.frame.size)
    }

    private func updateViewConstraints(to size: CGSize) {
        var frameWidthRatio = CGFloat(1.0)
        var frameHeightRatio = CGFloat(1.0)
        if (size.width > size.height) {
            // landscape
            frameImageView.image = UIImage(named: "green-frame-landscape")
            frameWidthRatio = 456.0
            frameHeightRatio = 385.0

            frameImageViewAspectRatioConstraintPortrait.isActive = false
            frameImageViewAspectRatioConstraintLandscape.isActive = true
        } else {
            // portrait
            frameImageView.image = UIImage(named: "green-frame-portrait")
            frameWidthRatio = 385.0
            frameHeightRatio = 456.0
            frameImageViewAspectRatioConstraintPortrait.isActive = true
            frameImageViewAspectRatioConstraintLandscape.isActive = false
        }

        let frameAspectRatio = frameHeightRatio / frameWidthRatio

        let viewAspectRatio = size.height / size.width

        if (viewAspectRatio > frameAspectRatio) {
            frameImageViewLeftConstraint.constant = 32
        } else {
            let r = (size.height - 2 * 32) / frameHeightRatio
            let x = (size.width - r * frameWidthRatio) / 2
            frameImageViewLeftConstraint.constant = x
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateViewConstraints(to: size)
        })
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

