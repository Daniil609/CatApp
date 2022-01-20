//
//  LoadingViewCell.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 20/01/2022.
//

import UIKit

final class LoadingViewCell: UITableViewCell {
    //MARK: - Internal properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
