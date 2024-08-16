//
//  CarouselItemDataSourceProvider.swift
//  Vought Showcase
//
//  Created by Burhanuddin Rampurawala on 06/08/24.
//

import UIKit

class CarouselItemDataSourceProvider: CarouselItemDataSourceProviderType {
    func items() -> [CarouselItem] {
        return [
            HomeLanderCarouselItem(),
            MaeveCarouselItem(),
            BlackNoirCarouselItem(),
            ATrainCarouselItem(),
        ]
    }
    
    static func getImages() -> [UIImage] {
        let names = ["butcher", "frenchie", "hughei", "mm"]
        var arr: [UIImage] = []
        for idx in 0..<4 {
            if let image = UIImage(named: names[idx]) {
                arr.append(image)
            }
        }
        return arr
    }
}
