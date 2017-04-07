//
//  ULPageControlView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/21.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

class ULPageControlView: ULAnimationBaseView {

    fileprivate let collectionView : UICollectionView = {
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: ULConstants.screen.width, height: ULConstants.screen.height - 100)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    fileprivate var pageControlArray = [ULBasePageControl]()
    fileprivate let numberOfPages : Int = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        addSubview(collectionView)
        
        //pageControlPuya
        let pageControlPuya : ULPageControlPuya = ULPageControlPuya()
        pageControlPuya.numberOfPages = self.numberOfPages
        pageControlPuya.tintColor = UIColor.white
        addSubview(pageControlPuya)
        
        pageControlArray.append(pageControlPuya)
        
        pageControlPuya.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startBtn.snp.top).offset(-20)
        }
        
        let pageControlPaprike : ULPageControlPaprika = ULPageControlPaprika()
        pageControlPaprike.borderWidth = 1
        pageControlPaprike.inactiveTransparency = 0
        pageControlPaprike.numberOfPages = self.numberOfPages
        pageControlPaprike.tintColor = UIColor.white
        
        addSubview(pageControlPaprike)
        
        pageControlArray.append(pageControlPaprike)
        
        pageControlPaprike.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControlPuya.snp.top).offset(-20)
        }
        
        let pageControlJaloro : ULPageControlJaloro = ULPageControlJaloro()
        pageControlJaloro.numberOfPages = self.numberOfPages
        pageControlJaloro.radius = 2
        pageControlJaloro.tintColor = UIColor.white
        addSubview(pageControlJaloro)
        pageControlArray.append(pageControlJaloro)
        pageControlJaloro.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControlPaprike.snp.top).offset(-20)
        }
        
        let pageControlFresno : ULPageControlFresno = ULPageControlFresno()
        pageControlFresno.numberOfPages = self.numberOfPages
        pageControlFresno.tintColor = UIColor.white
        addSubview(pageControlFresno)
        pageControlArray.append(pageControlFresno)
        pageControlFresno.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControlJaloro.snp.top).offset(-20)
        }
        
        let pageControlChimayo : ULPageControlChimayo = ULPageControlChimayo()
        pageControlChimayo.numberOfPages = self.numberOfPages
        pageControlChimayo.tintColor = UIColor.white
        addSubview(pageControlChimayo)
        pageControlArray.append(pageControlChimayo)
        
        pageControlChimayo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControlFresno.snp.top).offset(-20)
        }
        
        let pageContorlAleppo : ULPageControlAleppo = ULPageControlAleppo()
        pageContorlAleppo.numberOfPages = self.numberOfPages
        pageContorlAleppo.tintColor = UIColor.white
        addSubview(pageContorlAleppo)
        pageControlArray.append(pageContorlAleppo)
        pageContorlAleppo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControlChimayo.snp.top).offset(-20)
        }
        
        let pageControlJalapeno : ULPageControlJalapeno = ULPageControlJalapeno()
        pageControlJalapeno.numberOfPages = self.numberOfPages
        pageControlJalapeno.tintColor = UIColor.white
        addSubview(pageControlJalapeno)
        pageControlArray.append(pageControlJalapeno)
        pageControlJalapeno.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageContorlAleppo.snp.top).offset(-20)
        }
        
        let pageControlAji : ULPageControlAji = ULPageControlAji()
        pageControlAji.numberOfPages = self.numberOfPages
        pageControlAji.tintColor = UIColor.white
        pageControlAji.borderWidth = 1
        pageControlAji.inactiveTransparency = 0
        addSubview(pageControlAji)
        pageControlArray.append(pageControlAji)
        pageControlAji.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pageControlJalapeno.snp.top).offset(-20)
        }
        
    }
    
    private func layout() {
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(startBtn.snp.top)
        }
    }
}

extension ULPageControlView : UICollectionViewDelegate , UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.contentView.backgroundColor = UIColor.ul_random()
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let total = scrollView.contentSize.width - scrollView.bounds.width
        let offset_x = scrollView.contentOffset.x
        let percent = Double(offset_x/total)
        
        let progress = percent * Double(self.numberOfPages - 1)
        
        self.pageControlArray.forEach { (pageControl) in
            pageControl.progress = progress
        }
    }
}
