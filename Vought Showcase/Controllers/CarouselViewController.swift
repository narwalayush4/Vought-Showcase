//
//  CarouselViewController.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import Foundation
import UIKit


final class CarouselViewController: UIViewController {
    
    /// Container view for the carousel
    @IBOutlet private weak var containerView: UIView!
    
    /// Carousel control with page indicator
    @IBOutlet private weak var carouselControl: UIPageControl!


    /// Page view controller for carousel
    private var pageViewController: UIPageViewController?
    
    /// Carousel items
    private var items: [CarouselItem] = []
    
    private let images: [UIImage] = CarouselItemDataSourceProvider.getImages()
    
    /// Image View showing the image
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// Top Progress Bar View
    private var segmentedProgressBar: SegmentedProgressBar
    
    /// Duration of each segment's animation
    private let duration: TimeInterval = 1.0
    
    /// Current item index
    private var currentItemIndex: Int = 0 {
        didSet {
            // Update carousel control page
            self.carouselControl.currentPage = currentItemIndex
        }
    }

    /// Initializer
    /// - Parameter items: Carousel items
    public init(items: [CarouselItem]) {
        self.items = items
        self.segmentedProgressBar = SegmentedProgressBar(numberOfSegments: self.images.count, duration: duration)
        super.init(nibName: "CarouselViewController", bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initPageViewController()
//        initCarouselControl()
        initImageViewControllers()
        initProgressBar()
        setupTapGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        segmentedProgressBar.startAnimation()
    }
    
    
    /// Initialize page view controller
    private func initPageViewController() {

        // Create pageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal,
        options: nil)

        // Set up pageViewController
        pageViewController?.dataSource = self
        pageViewController?.delegate = self
        pageViewController?.setViewControllers(
            [getController(at: currentItemIndex)], direction: .forward, animated: true)

        guard let theController = pageViewController else {
            return
        }
        
        // Add pageViewController in container view
        add(asChildViewController: theController,
            containerView: containerView)
    }

    /// Initialize carousel control
    private func initCarouselControl() {
        // Set page indicator color
        carouselControl.currentPageIndicatorTintColor = UIColor.darkGray
        carouselControl.pageIndicatorTintColor = UIColor.lightGray
        
        // Set number of pages in carousel control and current page
        carouselControl.numberOfPages = items.count
        carouselControl.currentPage = currentItemIndex
        
        // Add target for page control value change
        carouselControl.addTarget(
                    self,
                    action: #selector(updateCurrentPage(sender:)),
                    for: .valueChanged)
    }
    
    /// Initialize Image View Controllers
    private func initImageViewControllers() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        imageView.image = images[currentItemIndex]
    }
    
    /// Initialize progress bar
    private func initProgressBar() {
        segmentedProgressBar.delegate = self
        view.addSubview(segmentedProgressBar)
        segmentedProgressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedProgressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedProgressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedProgressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedProgressBar.heightAnchor.constraint(equalToConstant: 5)
        ])
        view.bringSubviewToFront(segmentedProgressBar)
    }
    
    /// Handle Tap Gestures
    private func setupTapGestures() {
        
    }

    /// Update current page
    /// Parameter sender: UIPageControl
    @objc func updateCurrentPage(sender: UIPageControl) {
        // Get direction of page change based on current item index
        let direction: UIPageViewController.NavigationDirection = sender.currentPage > currentItemIndex ? .forward : .reverse
        
        // Get controller for the page
        let controller = getController(at: sender.currentPage)
        
        // Set view controller in pageViewController
        pageViewController?.setViewControllers([controller], direction: direction, animated: true, completion: nil)
        
        // Update current item index
        currentItemIndex = sender.currentPage
    }
    
    /// Get controller at index
    /// - Parameter index: Index of the controller
    /// - Returns: UIViewController
    private func getController(at index: Int) -> UIViewController {
        return items[index].getController()
    }

}

// MARK: UIPageViewControllerDataSource methods
extension CarouselViewController: UIPageViewControllerDataSource {
    
    /// Get previous view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
            // Check if current item index is first item
            // If yes, return last item controller
            // Else, return previous item controller
            if currentItemIndex == 0 {
                return items.last?.getController()
            }
            return getController(at: currentItemIndex-1)
        }

    /// Get next view controller
    /// - Parameters:
    ///  - pageViewController: UIPageViewController
    ///  - viewController: UIViewController
    /// - Returns: UIViewController
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
           
            // Check if current item index is last item
            // If yes, return first item controller
            // Else, return next item controller
            if currentItemIndex + 1 == items.count {
                return items.first?.getController()
            }
            return getController(at: currentItemIndex + 1)
        }
}

// MARK: UIPageViewControllerDelegate methods
extension CarouselViewController: UIPageViewControllerDelegate {
    
    /// Page view controller did finish animating
    /// - Parameters:
    /// - pageViewController: UIPageViewController
    /// - finished: Bool
    /// - previousViewControllers: [UIViewController]
    /// - completed: Bool
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = items.firstIndex(where: { $0.getController() == visibleViewController }){
                currentItemIndex = index
            }
        }
}

// MARK: SegmentedProgressBarDelegate methods
extension CarouselViewController : SegmentedProgressBarDelegate {
    
    func segmentedProgressBarChangedIndex(index: Int) {
        imageView.image = images[index]
    }
    
    func segmentedProgressBarFinished() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
