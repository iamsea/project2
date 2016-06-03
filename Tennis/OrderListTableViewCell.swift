//
//  OrderListTableViewCell.swift
//  Tennis
//
//  Created by seasong on 16/5/13.
//  Copyright © 2016年 seasong. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.subviews.count == 2 {
            //创建collectionView的Flowlayout
            let flowlayout = UICollectionViewFlowLayout()
            flowlayout.minimumInteritemSpacing = 8
            flowlayout.minimumLineSpacing = 8
            flowlayout.itemSize = CGSizeMake(130, 64)
            flowlayout.scrollDirection = .Horizontal
            
            let collectionView = UICollectionView(frame: CGRectMake(66, 70, 829, 64), collectionViewLayout: flowlayout)
            collectionView.registerClass(OrderCollectionViewCell.self, forCellWithReuseIdentifier: "item")
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            self.addSubview(collectionView)
            //        collectionView.snp_makeConstraints { (make) -> Void in
            //            make.top.left.bottom.right.equalTo(0)
            //        }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("item", forIndexPath: indexPath)
        print(cell.subviews.count)
        if cell.subviews.count == 1 {
            let imageView =  UIImageView()
            imageView.image = UIImage(named: "pic4")
            imageView.frame.size = CGSizeMake(130, 64)
            
            let shadeView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
            shadeView.frame = imageView.bounds
            shadeView.alpha = 0.7
            imageView.addSubview(shadeView)
            
            let label = UILabel(frame: imageView.bounds)
            label.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.text = "NO.3 10:00"
            label.alpha = 0.6
            imageView.addSubview(label)
            
            cell.addSubview(imageView)
        }
        return cell
    }
    
}
