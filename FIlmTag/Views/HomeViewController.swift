//
//  HomeViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 09.03.2024.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    private var username: String = ""
    private var films: [FilmForDisplay] = []
    private var shuffleButton: UIButton = {
      let button = UIButton(type: .custom)
      let configuration = UIImage.SymbolConfiguration(pointSize: 30) // Adjust pointSize as needed
        button.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: configuration)!.withRenderingMode(.alwaysTemplate), for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 160/255, green: 211/255, blue: 196/255, alpha: 1);
        button.tintColor = .white
      return button
    }()
    private let filmsToWatchLabel: UILabel = UILabel()
    private let table: UITableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.username = defaults.string(forKey: Constraints.loginKey)!
        self.view.backgroundColor = Colors.dark;
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func configureUI() {
        
        view.addSubview(filmsToWatchLabel)
        filmsToWatchLabel.text = "   Films for you to watch: "
        filmsToWatchLabel.font = UIFont.boldSystemFont(ofSize: 30)
        filmsToWatchLabel.textColor = Colors.white
        filmsToWatchLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        filmsToWatchLabel.pinLeft(to: view, 10)
        
        view.addSubview(table)
        table.backgroundColor = Colors.dark
        table.dataSource = self
        table.separatorStyle = .singleLine
        table.pinTop(to: filmsToWatchLabel.bottomAnchor, 10)
        table.pinLeft(to:  view)
        table.pinRight(to: view)
        table.pinBottom(to: view)
        table.register(FilmTableCell.self, forCellReuseIdentifier: FilmTableCell.reuseId)
        
        view.addSubview(shuffleButton)
        shuffleButton.translatesAutoresizingMaskIntoConstraints = false
          
          NSLayoutConstraint.activate([
            shuffleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20), // Adjust spacing as needed
            shuffleButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20), // Adjust spacing as needed
            shuffleButton.heightAnchor.constraint(equalToConstant: 60), // Adjust size as needed
            shuffleButton.widthAnchor.constraint(equalToConstant: 60) // Adjust size as needed
          ])
        shuffleButton.layer.cornerRadius = 30
        shuffleButton.addTarget(self, action: #selector(getRecomendedFilms), for: .touchUpInside)
        getRecomendedFilms()
        
    }
    
    @objc
    private func getRecomendedFilms() {
        shuffleButton.isEnabled = false
        var reviews: [Review] = []
        FilmAPIController.getUserReviews(username: self.username, completion: {response, error in
            
            if let error = error {
              print("Error during getting reviews: \(error.localizedDescription)")
              // Handle error appropriately (e.g., display an error message)
            } else {
                for review in response {
                    let unwrapped = review ?? nil
                    if unwrapped == nil {
                        continue
                    }
                    if unwrapped?.stars ?? 0 >= 3 {
                        print("appended")
                        reviews.append(unwrapped!)
                    }
                }
                if reviews.isEmpty {
                    print("no reviews good enough")
                    return
                }
                let goodFilm = reviews.randomElement()!.title
                FilmAPIController.getSimmilar(goodFilm, completion: {response, error in
                    if let error = error {
                      print("Error during search: \(error.localizedDescription)")
                      // Handle error appropriately (e.g., display an error message)
                    } else {
                        self.films = []
                        for film in response {
                            let unwrapped = film ?? nil
                            if unwrapped == nil {
                                continue
                            }
                            SDWebImageManager.shared.loadImage(with: URL(string: unwrapped!.poster_path), progress: nil, completed: { (image: UIImage?, _: Data?, _: Error?, _: SDImageCacheType, _: Bool, _: URL?) in
                                if let error = error {
                                        print("Error downloading image:", error)
                                        // Handle the error appropriately, e.g., display a placeholder image
                                } else {
                                    DispatchQueue.main.async {
                                        let filmToAdd = FilmForDisplay(title: unwrapped!.title, api_id: unwrapped!.api_id, overview: unwrapped!.overview, poster: self.resizeImage(image: image!, targetSize: UIImage(named: "placeholder")!.size)!, review_average: unwrapped!.review_average)
                                        self.films.append(filmToAdd)
                                        
                                        self.table.reloadData()
                                        self.shuffleButton.isEnabled = true
                                    }
                                }
                            })
                        }
                    }
                })
            }
        })
    }
    
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
      let format = UIGraphicsImageRendererFormat()
      format.scale = image.scale // Maintain image scale
      let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
      return renderer.image { context in
        image.draw(in: CGRect(origin: .zero, size: targetSize))
      }
    }
}

extension HomeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.films.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableCell.reuseId, for: indexPath) as! FilmTableCell
        if indexPath.row < self.films.count{
            cell.configure(with: self.films[indexPath.row])
            return cell
        } else {
            return cell;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected: ", indexPath.row)
        let filmInfo: FilmInfoController = FilmInfoController();
        
        filmInfo.film = films[indexPath.row]
        
        present(filmInfo, animated: true)
    }
        
}
