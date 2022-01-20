//
//  ViewController.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//


import SnapKit
import UIKit

class AllPhotosViewController: UIViewController {
    //MARK: - Private Properties
    private var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView!
    private var alert: UIAlertController!
    
    private var viewModel = AllPhotosVM()
    private var isLoading = false
    
    //MARK: - VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupVM()
    }
}

private extension AllPhotosViewController {
    //MARK: - Pivate methods
    func setupVM() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else {
                return
            }
            
            switch state {
            case .dateSetup(let isSetUp):
                guard isSetUp else{
                    return
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .loadongState(let isLoad):
                if isLoad {
                    DispatchQueue.main.async {
                        self.activityIndicator.startAnimating()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
        
        viewModel.launch()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadAddToFavorite), name: NSNotification.Name(NotificationName.addToFavorite.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadImage), name: NSNotification.Name(NotificationName.load.rawValue), object: nil)
    }
    
    func setupUI() {
        tableView = .init(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllPhotosTableViewCell.self, forCellReuseIdentifier: Constants.cellId)
        let tableViewLoadingCellNib = UINib(nibName: Constants.loadNibName, bundle: nil)
        tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: Constants.loadCellId)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-80)
        }
        
        activityIndicator = .init()
        
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        alert = .init(title: .init(), message: .init(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle, style: .default, handler: nil))
    }
    
    @objc func loadAddToFavorite() {
        alert.title = Constants.addFavoriteAlertTitle
        self.present(self.alert, animated: true, completion: nil)
    }
    
    @objc func loadImage() {
        alert.title = Constants.downloadedAlertTitle
        self.present(self.alert, animated: true, completion: nil)
    }
}

extension AllPhotosViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - Table Delegat, DataSourse
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.dataModel.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.cellId, for: indexPath) as? AllPhotosTableViewCell else {
                return .init()
            }
            
            cell.model = .init(imageURL: URL(string: viewModel.dataModel[indexPath.row].url)!)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.loadCellId, for: indexPath) as? LoadingViewCell else {
                return .init()
            }
            
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
    }
    
    func loadMoreData() {
            if !self.isLoading {
                self.isLoading = true
                DispatchQueue.global().async {
                    sleep(2)
                    self.setupVM()
                    self.isLoading = false
                }
            }
        }
}

private extension AllPhotosViewController {
    //MARK: - Constants
    struct Constants {
        static let addFavoriteAlertTitle = "Image added to favorite gallery"
        static let downloadedAlertTitle = "Image downloaded"
        static let alertButtonTitle = "Ok"
        static let cellId = "AllPhotosCell"
        static let loadCellId = "LoadingCell"
        static let loadNibName = "LoadingViewCell"
        static let notificationName = "finish_Loaded"
    }
}

