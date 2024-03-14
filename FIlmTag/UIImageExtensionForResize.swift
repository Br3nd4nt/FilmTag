//
//  UIImageExtensionForResize.swift
//  FilmTag
//
//  Created by br3nd4nt on 14.03.2024.
//

import UIKit

extension UIImage {
  func resize(to targetSize: CGSize) -> UIImage? {
    let format = UIGraphicsImageRendererFormat()
    format.scale = self.scale // Maintain image scale
    let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

    return renderer.image { context in
      self.draw(in: CGRect(origin: .zero, size: targetSize))
    }
  }
}
