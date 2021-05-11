//
//  ColorsManager.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import Foundation
import RandomColorSwift


final class ColorsManager {
    public static let shared = ColorsManager()
    
    private var colorObservable: MultiObservable<Color>!
    
    public var currentColor: Color {
        colorObservable.value!
    }
    
    private init() {
        colorObservable = MultiObservable(
            randomColor(
                hue: .random,
                luminosity: .dark
            )
        )
    }
    
    public func bind(_ compeletion: @escaping ((Color) -> Void ) ) {
        colorObservable.bind { _ in
            let color = self.colorObservable.value!
            compeletion(color)
        }
    }
    
    public func updateColor() {
        colorObservable.value = randomColor(
            hue: .random,
            luminosity: .dark
        )
    }
}
