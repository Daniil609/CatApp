//
//  CatTableViewCell.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//
import SnapKit
import UIKit

final class AllPhotosTableViewCell: UITableViewCell {
    //MARK: - Private properties
    private var itemView: ItemView!
        
    //MARK: - Internal properties
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            
            itemView.imageUrl = model.imageURL
        }
    }
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AllPhotosTableViewCell {
    func commonInit()  {
        //MARK: - Private methods
        backgroundColor = .gray
        
        itemView = .init()
        
        contentView.addSubview(itemView)
        
        itemView?.snp.makeConstraints({ make in
            make.top.left.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-1)
        })
    }
}

extension AllPhotosTableViewCell {
    struct Model {
        var imageURL: URL

        init(imageURL: URL) {
            self.imageURL = imageURL
        }
    }
}
