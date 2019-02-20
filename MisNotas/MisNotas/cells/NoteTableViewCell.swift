//
//  NoteTableViewCell.swift
//  MisNotas
//
//  Created by Jorge Luis Peña López on 2/17/19.
//  Copyright © 2019 Mobile Lab SAS. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

	@IBOutlet weak var imgCell: UIImageView!
	@IBOutlet weak var lblCell: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setData(dataImg:Data?, textCell:String?){
		self.imgCell.image = dataImg != nil ? UIImage(data: dataImg!) : UIImage(named: "AppIcon");
		self.lblCell.text = textCell ?? "";
	}

}
