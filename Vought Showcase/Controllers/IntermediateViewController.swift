//
//  IntermediateViewController.swift
//  Vought Showcase
//
//  Created by Ayush Narwal on 16/08/24.
//

import UIKit

class IntermediateViewController: UIViewController {
    
    /// Button redirecting to the CarouselVIewController
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Carousel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
    }
    
    private func createViews() {
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        let carouselItemProvider = CarouselItemDataSourceProvider()
        let carouselViewController = CarouselViewController(items: carouselItemProvider.items())
        add(asChildViewController: carouselViewController, containerView: view)
    }
    
}
