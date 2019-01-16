//
//  ApartementTableViewCell.swift
//  YallaSa7el
//
//  Created by Eyad Shokry on 1/13/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class ApartementTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var apartementImageView: UIImageView!
    @IBOutlet weak var apartementTitle: UILabel!
    
    
    // MARK: - Filling Cell's Data
    
    func setMyCell(apartement: Apartement) {
        apartementImageView.image = apartement.apartementImage as? UIImage
        apartementTitle.text = apartement.apartementTitle
    }
}
