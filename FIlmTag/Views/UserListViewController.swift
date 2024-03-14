//
//  UserListViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 09.03.2024.
//

import UIKit
import SDWebImage
import Cosmos

class UserListViewController: UIViewController {
    private let defaults = UserDefaults.standard
    private var username: String = ""
    private var reviews: [ReviewForDisplay] = []
    
    private let reviewsLabel: UILabel = UILabel()
    private let table: UITableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Colors.dark
        username = defaults.string(forKey: Constraints.loginKey)!
        self.configureLabel()
        self.configureTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getReviews()
    }
    
    private func getReviews() {
        FilmAPIController.getUserReviews(username: self.username, completion: {response, error in
            if let error = error {
              print("Error during getting reviews: \(error.localizedDescription)")
            } else {
                self.reviews = []
                for review in response {
                    let unwrapped = review ?? nil
                    if unwrapped == nil {
                        continue
                    }
                    
                    SDWebImageManager.shared.loadImage(with: URL(string: unwrapped!.poster_path), progress: nil, completed: { (image: UIImage?, _: Data?, _: Error?, _: SDImageCacheType, _: Bool, _: URL?) in
                        if let error = error {
                                print("Error downloading image:", error)
                        } else {
                            DispatchQueue.main.async {
                                let reviewToAdd = ReviewForDisplay(username: unwrapped!.username, title: unwrapped!.title, stars: unwrapped!.stars, text: unwrapped!.text, poster: image!.resize(to: UIImage(named: "placeholder")!.size)!)
                                self.reviews.append(reviewToAdd)
                                self.table.reloadData()
                            }
                        }
                    })
                }
            }
        })
    }
    
    private func configureLabel() {
        view.addSubview(reviewsLabel)
        reviewsLabel.text = "Your reviews: "
        reviewsLabel.font = UIFont.boldSystemFont(ofSize: 50)
        reviewsLabel.textColor = Colors.white
        reviewsLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        reviewsLabel.pinLeft(to: view, 10)
    }

    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = Colors.dark
        table.dataSource = self
        table.separatorStyle = .singleLine
        table.pinLeft(to: view)
        table.pinRight(to: view)
        table.pinTop(to: reviewsLabel.bottomAnchor, 10)
        table.pinBottom(to: view)
        table.register(ReviewTableCell.self, forCellReuseIdentifier: ReviewTableCell.reuseId)
    }

}

extension UserListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReviewTableCell.reuseId, for: indexPath) as! ReviewTableCell
        if indexPath.row < self.reviews.count{
            cell.configure(with: self.reviews[indexPath.row])
            return cell
        } else {
            return cell
        }
    }
}

final class ReviewTableCell: UITableViewCell {
    static let reuseId: String = "ReviewTableCell"
    private let wrap: UIView = UIView()
    let posterView: UIImageView = UIImageView()
    let titleView: UILabel = UILabel()
    let reviewView: UILabel = UILabel()
    let starsView: CosmosView = CosmosView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    func configure(with review: ReviewForDisplay) {
        self.posterView.image = review.poster
        self.titleView.text = review.title
        self.starsView.rating = review.stars
        self.reviewView.text = review.text
    }
    
    @available(*, unavailable)
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        self.addSubview(wrap)
        wrap.backgroundColor = Colors.placeholderColor
        wrap.layer.cornerRadius = 5
        wrap.pinVertical(to: self, 10)
        wrap.pinHorizontal(to: self, 10)
        
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.clipsToBounds = true
        wrap.addSubview(posterView)
        
        posterView.pinLeft(to: wrap)
        posterView.pinTop(to: wrap)
        posterView.pinBottom(to: wrap)
        posterView.pinWidth(to: wrap.widthAnchor, 0.4)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.numberOfLines = 2
        titleView.font = UIFont.systemFont(ofSize: 30)
        titleView.textColor = Colors.white
        wrap.addSubview(titleView)
        titleView.pinLeft(to: posterView.trailingAnchor)
        titleView.pinTop(to: wrap)
        titleView.pinRight(to: wrap, 10)
        
        wrap.addSubview(starsView)
        starsView.settings.updateOnTouch = false
        starsView.settings.filledColor = Colors.red
        starsView.settings.filledBorderColor = Colors.red
        starsView.settings.emptyBorderColor = Colors.white
        starsView.pinTop(to: titleView.bottomAnchor, 10)
        starsView.pinLeft(to: posterView.trailingAnchor, 10)
        
        reviewView.translatesAutoresizingMaskIntoConstraints = false
        reviewView.numberOfLines = 0
        reviewView.font = UIFont.systemFont(ofSize: 20)
        reviewView.textColor = Colors.white
        wrap.addSubview(reviewView)
        reviewView.pinTop(to: starsView.bottomAnchor, 10)
        reviewView.pinLeft(to: posterView.trailingAnchor, 10)
        reviewView.pinRight(to: wrap, 10)
    }
}
