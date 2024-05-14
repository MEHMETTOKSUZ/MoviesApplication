//
//  CartViewController.swift
//  MoviesMVVM
//
//  Created by Mehmet ÖKSÜZ on 21.01.2024.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = CartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = confirmButton
        
        let nibName = UINib(nibName: "CartTableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CartTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadedCartDataMovies), name: NSNotification.Name(rawValue: "newMovies"), object: nil)
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.didFinishLoad = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.loadCartItems()
        updateBadgeValue()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeValue), name: NSNotification.Name(rawValue: "newMovies"), object: nil)
       
    }
    
    @objc func loadedCartDataMovies() {
        
        viewModel.loadCartItems()
       
    }
    
    @objc func updateBadgeValue() {
        
        if let items = tabBarController?.tabBar.items {
               let item = items[2]
               let count = viewModel.movies.count
               item.badgeValue = count > 0 ? String(count) : nil
           }
    }
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        
        if viewModel.movies.count > 0 {
            performSegue(withIdentifier: "toPaymentVC", sender: nil)
            
        } else {
            makeAlert(titleInput: "Bildirim", messageInput: "Sepetiniz Boş!")
        }
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItemInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.selectionStyle = .none
        
        guard let data = viewModel.item(at: indexPath.row) else {
            return cell
        }
        
        cell.itemFromCell(item: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteItem(indexPath: indexPath)
           
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Sil"
    }
    
    func makeAlert(titleInput: String , messageInput: String) {
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        
    }
}
