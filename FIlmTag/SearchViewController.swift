//
//  SearchViewController.swift
//  FilmTag
//
//  Created by br3nd4nt on 09.03.2024.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {
    private var timer: Timer?
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil);
    private let table: UITableView = UITableView(frame: .zero)
    private var films: [FilmForDisplay] = [];
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = Colors.dark
        self.setupSearchController()
        self.configureTable()
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = Colors.dark
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        
        table.pin(to: view)
//        table.pinTop(to: searchController., 20)
        
        table.register(FilmTableCell.self, forCellReuseIdentifier: FilmTableCell.reuseId)
    }
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Input name of film here..."
        
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
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

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        var text: String = self.searchController.searchBar.text ?? ""
        if (text.isEmpty || text.count < 3) {
            self.timer?.invalidate()
            self.films = []
            return;
        }
        
        print("updated: ", text)
        let debouncedSearch = debounce(interval: 1.5) {  // Adjust delay as needed
            // Make your URL request using searchText here
            print("Searched: ", text)
            FilmAPIController.searchForFilm(text, completion: {response, error in
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
                                }
                            }
                        })
                        
                    }
                    
                    
                }
                
            })
          }
        debouncedSearch()
    }
    
    
    func debounce(interval: TimeInterval, operation: @escaping () -> Void) -> (() -> Void) {
      return {
          self.timer?.invalidate()
          self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false, block: { _ in
          operation()
        })
      }
    }
}

extension SearchViewController : UITableViewDelegate {
    
}

extension SearchViewController : UITableViewDataSource {
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
        
//        navigationController?.pushViewController(filmInfo, animated: true)
        present(filmInfo, animated: true)
//        let selectedTrail = trails[indexPath.row]
//        
//        if let viewController = storyboard?.instantiateViewController(identifier: "TrailViewController") as? TrailViewController {
//            viewController.trail = selectedTrail
//            navigationController?.pushViewController(viewController, animated: true)
//        }
    }
        
}

final class FilmTableCell: UITableViewCell {
    static let reuseId: String = "FilmTableCell"
    private let wrap: UIView = UIView()
    let posterView: UIImageView = UIImageView()
    let titleView: UILabel = UILabel()
    let overviewView: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        wrap.isUserInteractionEnabled = false
        posterView.isUserInteractionEnabled = false
        titleView.isUserInteractionEnabled = false
        overviewView.isUserInteractionEnabled = false
        
        configureUI()
    }
    
    
    @available(*, unavailable)
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with film: FilmForDisplay) {
        self.titleView.text = film.title
        self.overviewView.text = film.overview
        self.posterView.image = film.poster
    }
    
    private func configureUI() {
        selectionStyle = .blue
        backgroundColor = .clear
        
        self.addSubview(wrap)
        
        wrap.backgroundColor = Colors.placeholderColor
        wrap.layer.cornerRadius = 5
        wrap.pinVertical(to: self, 10)
        wrap.pinHorizontal(to: self, 10)
//        
        
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.clipsToBounds = true
        wrap.addSubview(posterView)
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.numberOfLines = 2
        wrap.addSubview(titleView)
        
        overviewView.translatesAutoresizingMaskIntoConstraints = false
        overviewView.lineBreakMode = .byTruncatingTail
        overviewView.numberOfLines = 10
        wrap.addSubview(overviewView)
        
        posterView.pinLeft(to: wrap)
        posterView.pinTop(to: wrap)
        posterView.pinBottom(to: wrap)
//        posterView.pinCenterY(to: wrap)
//        posterView.pinHeight(to: wrap)
        posterView.pinWidth(to: wrap.widthAnchor, 0.4)
        
        titleView.pinLeft(to: posterView.trailingAnchor)
        titleView.pinTop(to: wrap)
        titleView.pinRight(to: wrap)
        
        overviewView.pinLeft(to: posterView.trailingAnchor)
        overviewView.pinTop(to: titleView.bottomAnchor)
        overviewView.pinRight(to: wrap.trailingAnchor)
        overviewView.pinBottom(to: wrap.bottomAnchor)

        titleView.font = UIFont.boldSystemFont(ofSize: 30)
        titleView.textColor = Colors.white

        overviewView.textColor = Colors.white
        overviewView.font = UIFont.systemFont(ofSize: 16)
    
    }
}

