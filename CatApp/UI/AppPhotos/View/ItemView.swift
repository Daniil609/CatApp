//
//  CatView.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//

import Foundation
import SDWebImage
import UIKit

final public class ItemView: UIView {
    //MARK: - Private properties
    private var viewModel = AllPhotosVM()
    
    private var saveButton: UIButton!
    private var favoriteButton: UIButton!
    private var imageView: UIImageView!
    
    //MARK: - Internal Private
    var imageUrl: URL? {
        didSet {
            guard let url = imageUrl else {
                return
            }
            
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    //MARK: - Init
    public init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ItemView {
    //MARK: - Private methods
    func commonInit() {
        backgroundColor = .white
        
        favoriteButton = .init()
        favoriteButton.setImage(UIImage(systemName: Constants.favoriteButtonImageName), for: .normal)
        favoriteButton.layer.cornerRadius = Constants.buttonCornerRadius
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        addSubview(favoriteButton)
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.trailing.equalTo(-20)
            make.width.equalTo(50)
        }
        
        saveButton = .init()
        saveButton.backgroundColor = .clear
        saveButton.setImage(UIImage(systemName: Constants.saveButtonImageName), for: .normal)
        saveButton.layer.cornerRadius = Constants.buttonCornerRadius
        saveButton.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        
        addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.height.width.equalTo(favoriteButton)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(50)
        }
        
        imageView = .init()
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.clipsToBounds = true
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.leading.equalToSuperview().offset(40)
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    @objc func addToFavorite(sender: UIButton) {
        guard let imageURL = imageUrl else {
            return
        }

        viewModel.presAddToFavorite(imageURL: imageURL)
    }
    
    @objc func saveImage() {
        guard let imageURL = imageUrl else {
            return
        }
        
        viewModel.pressSaveButton(imageURL: imageURL)
    }
}

private extension ItemView {
    //MARK: - Constants
    struct Constants {
        static let buttonCornerRadius = CGFloat(5)
        static let favoriteButtonImageName = "star.fill"
        static let saveButtonImageName = "tray.and.arrow.down.fill"
        static let imageCornerRadius = CGFloat(10)
    }
}
