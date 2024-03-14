//
//  FilmInfoController.swift
//  FilmTag
//
//  Created by br3nd4nt on 10.03.2024.
//

import UIKit
import Cosmos

class FilmInfoController: UIViewController, UITextFieldDelegate {
    var film: FilmForDisplay? = nil
    
    private var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    private let posterView: UIImageView = UIImageView()
    private let titleView: UILabel = UILabel()
    private let descriptionView: UILabel = UILabel()
    private let starRating: CosmosView = CosmosView();
    private let userReview: UITextField = UITextField();
    private let sendReviewButton: UIButton = UIButton();
    private let scrollView: UIScrollView = UIScrollView();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userReview.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false  // Optional: Allow taps to go through to underlying views
        view.addGestureRecognizer(tapGesture)
        starRating.settings.filledColor = Colors.red
        starRating.settings.filledBorderColor = Colors.red
        starRating.settings.emptyBorderColor = Colors.white
        starRating.settings.minTouchRating = 1
        starRating.settings.starSize = 40
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
        }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardValue.cgRectValue
        let keyboardHeight = keyboardFrame.height

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInset

        scrollView.scrollIndicatorInsets = contentInset
        scrollView.setContentOffset(CGPoint(x: 0, y: userReview.frame.maxY - keyboardHeight), animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (film == nil) {
            return
        }
        posterView.image = film?.poster
        titleView.text = film?.title
        descriptionView.text = film?.overview
    }

    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.pinRight(to: view)
        scrollView.pinLeft(to: view)
        scrollView.pinTop(to: view)
        scrollView.pinBottom(to: view)

        view.backgroundColor = Colors.dark
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.clipsToBounds = true
        scrollView.addSubview(posterView)
        posterView.pinCenterX(to: scrollView)
        posterView.pinTop(to: scrollView, 10)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.clipsToBounds = true
        scrollView.addSubview(titleView)
        titleView.pinCenterX(to: scrollView)
        titleView.pinTop(to: posterView.bottomAnchor, 10)
        titleView.font = UIFont.boldSystemFont(ofSize: 40)
        titleView.textColor = Colors.white
        titleView.numberOfLines = 0
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.clipsToBounds = true
        scrollView.addSubview(descriptionView)
        descriptionView.pinCenterX(to: scrollView)
        descriptionView.pinLeft(to:scrollView, 10)
        descriptionView.pinRight(to: scrollView, 10)
        descriptionView.pinTop(to: titleView.bottomAnchor, 10)
        descriptionView.lineBreakMode = .byTruncatingTail
        descriptionView.font = UIFont.systemFont(ofSize: 24)
        descriptionView.textColor = Colors.white
        descriptionView.numberOfLines = 0
        
        starRating.translatesAutoresizingMaskIntoConstraints = false
        starRating.clipsToBounds = true
        scrollView.addSubview(starRating)
        starRating.pinCenterX(to: scrollView)
        starRating.pinTop(to: descriptionView.bottomAnchor, 10)
        starRating.rating = 5
        
        scrollView.addSubview(userReview)
        userReview.translatesAutoresizingMaskIntoConstraints = false
        userReview.clipsToBounds = true
        userReview.pinTop(to: starRating.bottomAnchor, 10)
        userReview.pinLeft(to: scrollView, 10)
        userReview.pinRight(to: scrollView, 10)
        userReview.placeholder = "Input your review for this film"
        userReview.layer.cornerRadius = 10
        userReview.backgroundColor = Colors.placeholderColor
        userReview.setHeight(40)
        
        sendReviewButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(sendReviewButton)
        sendReviewButton.backgroundColor = Colors.blue
        sendReviewButton.setTitle("   Leave a review   ", for: .normal)
        sendReviewButton.pinTop(to: userReview.bottomAnchor, 10)
        sendReviewButton.pinCenterX(to: scrollView)
        sendReviewButton.addTarget(self, action: #selector(sendReviewButtonPressed), for: .touchUpInside)
    }
    
    @objc
    private func sendReviewButtonPressed() {
        if (userReview.text == nil || userReview.text!.isEmpty) {
            return
        }
        
        if starRating.rating < 1 {
            return
        }
        FilmAPIController.leaveReview(film: self.film!, reviewNumber: starRating.rating, reviewText: userReview.text!)
        dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
