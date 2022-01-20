//
//  FavoriteTableViewCell.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 20/01/2022.
//

import UIKit

final class FavoriteTableViewCell: UITableViewCell {
    //MARK: - Private properties
    private var imageview: UIImageView!

    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal methods
    func config(image: UIImage) {
        imageview.image = image
    }
}

private extension FavoriteTableViewCell {
    //MARK: - Private methods
    func commonInit() {
        backgroundColor = .gray
        
        imageview = .init()
        imageview.layer.cornerRadius = Constants.cornerRadius
        imageview.clipsToBounds = true
        
        contentView.addSubview(imageview)
        
        imageview.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}

private extension FavoriteTableViewCell {
    //MARK: - Constants
    struct Constants {
        static var cornerRadius = CGFloat(10)
    }
}
