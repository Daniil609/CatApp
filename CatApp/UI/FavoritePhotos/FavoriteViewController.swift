//
//  FavoriteViewController.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - Private properties
    private var tableView: UITableView!
    private var alert: UIAlertController!
    
    private var viewModel = FavoriteVM()
    
    //MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupVM()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension FavoriteViewController {
    //MARK: - Private methods
    func setupVM() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else {
                return
            }
            
            switch state {
            case .dateSetup(let isSetUp):
                if isSetUp {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
        }
        
        viewModel.launch()
    }
    
    func setupUI() {
        tableView = .init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        
        alert = .init(title: Constants.alertTitle, message: Constants.alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle, style: .cancel, handler: nil ))
        
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - table DataSourse, Delegat
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.favoritePhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? FavoriteTableViewCell else {
            return .init()
        }
        
        cell.config(image: viewModel.favoritePhotos[indexPath.row])
        return cell
    }
}

private extension FavoriteViewController {
    //MARK: - Constants
    struct Constants {
        static let alertButtonTitle = "Cancel"
        static let alertTitle = "No images in favorite gallery"
        static let alertMessage = "Plese return to main screen and add photos to favorite"
        static let cellId = "favoriteCell"
    }
}
