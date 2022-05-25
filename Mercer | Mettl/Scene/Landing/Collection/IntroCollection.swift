//
//  ColorCollectionView.swift
//  Iscra
//
//  Created by Lokesh Patil on 25/10/21.
//

import UIKit
import Foundation

struct IntroItemsStruct {
    var title: String
    var subTitle: String
    var image:String
}

class IntroCollectionView: UICollectionView {
    var introItem = [IntroItemsStruct(title: AppConstant.title1,
                                      subTitle: AppConstant.subTitle1,
                                      image: "ic-mercer-intro-icon1"),
                     IntroItemsStruct(title: AppConstant.title2,
                                      subTitle: AppConstant.subTitle2,
                                      image: "ic-mercer-intro-icon2"),
                     IntroItemsStruct(title: AppConstant.title3,
                                      subTitle: AppConstant.subTitle3,
                                      image: "ic-mercer-intro-icon3"),
                     IntroItemsStruct(title: AppConstant.title4,
                                      subTitle: AppConstant.subTitle4,
                                      image: "ic-mercer-intro-icon4"),
                     IntroItemsStruct(title: AppConstant.title5,
                                      subTitle: AppConstant.subTitle5,
                                      image: "ic-mercer-intro-icon5")]
    var didScrolledAtIndex:((Int) -> Void)?
    
    func configure() {
        self.register(UINib(nibName: "IntroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "IntroCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
        startTimer()
    }
    func startTimer() {
        let _ =  Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.autoScroll), userInfo: nil, repeats: true)
    }
    
    var x = 1
    @objc func autoScroll() {
        if self.x < self.introItem.count {
            let indexPath = IndexPath(item: x, section: 0)
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.x = self.x + 1
        } else {
            self.x = 0
            self.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

extension IntroCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "IntroCollectionViewCell", for: indexPath) as? IntroCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(item: introItem[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let indexPathOfVisible = collectionView.indexPath(for: collectionView.visibleCells.first ?? UICollectionViewCell())
        if indexPath.row < indexPathOfVisible?.row ?? 0 {
            collectionView.scrollToItem(at: indexPathOfVisible!, at: .right, animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.contentOffset, size: self.self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.indexPathForItem(at: visiblePoint) {
            self.didScrolledAtIndex?(visibleIndexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  collectionView.bounds.width - 10
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacing section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    }
}
