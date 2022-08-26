//
//  ColorCollectionView.swift
//  Iscra
//
//  Created by m@k on 25/10/21.
//

import UIKit
import Foundation

struct IntroItemsStruct {
    var title: String
    var subTitle: String
    var image: String
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
    var didScrolledAtIndex: ((Int) -> Void)?
    let scrollTimes = 500
    func configure() {
        self.register(UINib(nibName: "IntroCollectionViewCell", bundle: nil),
                      forCellWithReuseIdentifier: "IntroCollectionViewCell")
        self.delegate = self
        self.dataSource = self
        reloadData()
        Timer.scheduledTimer(timeInterval: 2.5,
                             target: self,
                             selector: #selector(self.scrollAutomatically),
                             userInfo: nil, repeats: true)
    }
    @objc func scrollAutomatically(_ timer1: Timer) {
            for cell in self.visibleCells {
                let indexPath: IndexPath? = self.indexPath(for: cell)
                if (indexPath?.row)!  < introItem.count*scrollTimes - 1 {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    self.scrollToItem(at: indexPath1!, at: .right, animated: true)
                } else {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    self.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
            }
    }
    func arrayIndexForRow(_ row: Int) -> Int {
        return row % introItem.count
    }
}

extension IntroCollectionView: UICollectionViewDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return introItem.count*scrollTimes
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: "IntroCollectionViewCell",
                                                  for: indexPath) as? IntroCollectionViewCell else {
            return UICollectionViewCell()
        }
        let arrayIndex = arrayIndexForRow(indexPath.row)
        let modelObject = introItem[arrayIndex]
        cell.configure(item: modelObject)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let arrayIndex = arrayIndexForRow(indexPath.row)
        self.didScrolledAtIndex?(arrayIndex)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.contentOffset, size: self.self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.indexPathForItem(at: visiblePoint) {
            let arrayIndex = arrayIndexForRow(visibleIndexPath.row)
            self.didScrolledAtIndex?(arrayIndex)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  collectionView.bounds.width - 10
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacing section: Int) -> CGFloat {
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
