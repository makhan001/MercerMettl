//
//  ColorCollectionViewCell.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var view:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var ImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension IntroCollectionViewCell {
    func configure(item:IntroItemsStruct) {
        lblTitle.font = UIFont.setFont(fontType: .medium, fontSize: .medium)
        lblSubTitle.font = UIFont.setFont(fontType: .regular, fontSize: .small)
        lblTitle.text = item.title
        lblSubTitle.text = item.subTitle
        ImageView.image = UIImage(named: item.image)
    }
}
