//
//  ViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 25.12.2023.3
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var genresButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = ListViewModel()
    let headerViewModel = HeaderViewModel()
    let collectionHeaderView = CollectionHeadersView().collectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = genresButton
        navigationItem.rightBarButtonItem = searchButton
        setUpTableAndHeader()
        headerViewModel.getUpcomingMovies()
        registerCell()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.getNowPlayingMovies()
        
        NotificationCenter.default.addObserver(self, selector: #selector(upgradeData), name: NSNotification.Name(rawValue: "MoviesAdded"), object: nil)
    }
    
    @objc func upgradeData() {
        tableView.reloadData()
    }
    
    @IBAction func genresButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toGenresFromHome", sender: nil)
    }
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toSearchButton", sender: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setUpTableAndHeader() {
            let headerView = CollectionHeadersView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 390))
            headerView.collectionView.delegate = self
            headerView.collectionView.dataSource = self
            tableView.tableHeaderView = headerView
            
            headerView.pageControl.numberOfPages = headerViewModel.numberOfItemInSection
        
            
            headerViewModel.didFinishLoad = {
                DispatchQueue.main.async {
                    headerView.collectionView.reloadData()
                    headerView.pageControl.numberOfPages = self.headerViewModel.numberOfItemInSection
                }
            }
        
        viewModel.didFinishLoad = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                FavoriteManager.shared.loadFavoriteMovies()
            }
        }
    }
    
    func registerCell() {
        
        let nibname = UINib(nibName: "HomeTableViewCell", bundle: nil)
        tableView.register(nibname, forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.layer.cornerRadius = 10
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        
        cell.itemFromCell(item: data)
        
        cell.favoritButtonClicked = {
            if let data = self.viewModel.item(at: indexPath.row) {
                FavoriteManager.shared.add(item: data.data)
                cell.itemFromCell(item: data)
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = viewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "detailsFromHome", sender: selected)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return headerViewModel.numberOfItemInSection
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! UpcomingMoviesHeaderCell
        
        guard let data = headerViewModel.item(at: indexPath.row) else {
            return cell
        }
        cell.itemFromCell(movie: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let apiUpData = headerViewModel.item(at: indexPath.row)
        let url = apiUpData?.image
        (cell as? UpcomingMoviesHeaderCell)?.imageView.downloaded(from: url!, contentMode: .scaleToFill)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = headerViewModel.item(at: indexPath.row)
        performSegue(withIdentifier: "detailsFromHomeCollection", sender: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageWidth = scrollView.frame.width - 32
            let currentPage = Int((scrollView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)
            if let headerView = tableView.tableHeaderView as? CollectionHeadersView {
                headerView.pageControl.currentPage = currentPage
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "detailsFromHome":
            if let indexPath = tableView.indexPathForSelectedRow {
                if let data = viewModel.item(at: indexPath.row) {
                    prepareDetailsViewController(for: segue.destination, with: data)
                }
                
            }
        case "detailsFromHomeCollection":
            if let indexPath = sender as? IndexPath {
                if let data = headerViewModel.item(at: indexPath.row) {
                    prepareDetailsViewController(for: segue.destination, with: data)
                    
                    prepareDetailsViewController(for: segue.destination, with: data)
                }
            }
        default:
            break
        }
    }
    
    func prepareDetailsViewController(for viewController: UIViewController, with data: HomeTableViewCell
        .ViewModel) {
            guard let destination = viewController as? DetailsViewController else { return }
            
            let viewModel = DetailsViewModel(selectedAgent: data)
            destination.viewModel = viewModel
            destination.selectedMovieId = String(viewModel.UIModel.id)
        }
}





