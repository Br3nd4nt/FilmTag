//
//  StarRatingView.swift
//  FilmTag
//
//  Created by br3nd4nt on 10.03.2024.
//

import UIKit

class StarRatingView: UIView {

  // Define properties
    let emptyStarImage: UIImage? = UIImage(named: "star")
    let filledStarImage: UIImage? = UIImage(named: "star.fill")
    let spacing: CGFloat = 10
    let rating: Double = 5

  // Initializer
    override init(frame: CGRect) {
//    self.spacing = spacing
//    self.rating = rating
    super.init(frame: frame)
    setupStars()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Function to setup star images
  private func setupStars() {
    let starWidth = (frame.width - (spacing * CGFloat(numberOfStars - 1))) / CGFloat(numberOfStars)
    for starIndex in 0..<numberOfStars {
      let imageView = UIImageView(frame: CGRect(x: CGFloat(starIndex) * (starWidth + spacing), y: 0, width: starWidth, height: starWidth))
      imageView.image = rating >= Double(starIndex + 1) ? filledStarImage : emptyStarImage
      self.addSubview(imageView)
    }
  }

  // Define number of stars (can be adjusted)
  private var numberOfStars: Int {
    return 5
  }
}


