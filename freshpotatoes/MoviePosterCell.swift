//
//  MoviePosterCell.swift
//  freshpotatoes
//
//  Created by Eric Huang on 2/8/15.
//  Copyright (c) 2015 Eric Huang. All rights reserved.
//

import UIKit

class MoviePosterCell: UITableViewCell {


    @IBOutlet weak var posterImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.contentMode = UIViewContentMode.ScaleAspectFit
    }	

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
