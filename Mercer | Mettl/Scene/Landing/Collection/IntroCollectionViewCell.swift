//
//  ColorCollectionViewCell.swift
//  Iscra
//
//  Created by m@k on 25/10/21.
//

import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblSubTitle:UILabel!
    @IBOutlet weak var imageWalkthough: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension IntroCollectionViewCell {
    func configure(item:IntroItemsStruct) {
        self.lblTitle.font = UIFont.setFont(fontType: .medium, fontSize: .large)
        self.lblSubTitle.font = UIFont.setFont(fontType: .regular, fontSize: .regular)
        self.lblTitle.text = item.title
        self.lblSubTitle.text = item.subTitle
        self.imageWalkthough.image = UIImage(named: item.image)
    }
}
