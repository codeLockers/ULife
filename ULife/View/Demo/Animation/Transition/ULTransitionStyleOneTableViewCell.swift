//
//  ULTransitionStyleOneTableViewCell.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

@objc protocol ULTransitionStyleOneTableViewCellDelegate : NSObjectProtocol {
    @objc optional func transitionStyleOneTableViewCell(_ tableViewCell:ULTransitionStyleOneTableViewCell, didSelect collectionView:UICollectionView, atIndexPath indexPath:IndexPath)
}

class ULTransitionStyleOneTableViewCell: UITableViewCell {

    fileprivate lazy var collectionView : UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 5.0
        layout.itemSize = CGSize.init(width: 150, height: 100)
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 150), collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.register(ULTransitionStyleOneCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ULTransitionStyleOneCollectionViewCell.self))
        collection.backgroundColor = UIColor.white
        collection.contentInset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection;
    }()
    
    weak var delegate : ULTransitionStyleOneTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ULTransitionStyleOneTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ULTransitionStyleOneCollectionViewCell.self), for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.transitionStyleOneTableViewCell?(self, didSelect: collectionView, atIndexPath: indexPath)
    }
}
