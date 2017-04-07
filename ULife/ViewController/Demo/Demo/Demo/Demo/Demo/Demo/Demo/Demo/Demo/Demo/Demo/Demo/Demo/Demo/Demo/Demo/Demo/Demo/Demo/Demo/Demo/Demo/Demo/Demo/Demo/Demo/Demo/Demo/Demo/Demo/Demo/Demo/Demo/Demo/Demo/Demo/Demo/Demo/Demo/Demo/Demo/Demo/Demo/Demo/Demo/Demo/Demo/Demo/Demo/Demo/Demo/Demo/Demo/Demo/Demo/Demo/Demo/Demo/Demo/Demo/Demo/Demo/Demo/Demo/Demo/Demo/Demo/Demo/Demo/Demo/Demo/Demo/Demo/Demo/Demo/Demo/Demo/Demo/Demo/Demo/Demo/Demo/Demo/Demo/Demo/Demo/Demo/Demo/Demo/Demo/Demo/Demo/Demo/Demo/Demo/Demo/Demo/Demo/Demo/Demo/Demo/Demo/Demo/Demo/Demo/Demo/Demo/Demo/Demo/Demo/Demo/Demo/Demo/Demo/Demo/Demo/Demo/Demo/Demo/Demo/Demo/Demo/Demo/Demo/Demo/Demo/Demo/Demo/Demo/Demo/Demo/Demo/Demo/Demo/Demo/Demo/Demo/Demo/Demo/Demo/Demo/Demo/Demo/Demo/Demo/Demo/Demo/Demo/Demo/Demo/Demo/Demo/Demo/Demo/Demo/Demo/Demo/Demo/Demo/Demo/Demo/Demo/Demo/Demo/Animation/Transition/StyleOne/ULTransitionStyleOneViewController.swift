//
//  ULTransitionStyleOneViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/24.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULTransitionStyleOneViewController: ULBaseViewController {

    fileprivate let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        layout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Load_UI
    private func loadUI() {
        self.navigationItem.title = "TransitionStyleOne"
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        tableView.register(ULTransitionStyleOneTableViewCell.self, forCellReuseIdentifier: String(describing: ULTransitionStyleOneTableViewCell.self))
        self.view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULTransitionStyleOneViewController : UITableViewDelegate , UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ULTransitionStyleOneTableViewCell.self)) as? ULTransitionStyleOneTableViewCell
        cell?.delegate = self
        return cell!
    }
}

extension ULTransitionStyleOneViewController : ULTransitionStyleOneTableViewCellDelegate{
    
    func transitionStyleOneTableViewCell(_ tableViewCell: ULTransitionStyleOneTableViewCell, didSelect collectionView: UICollectionView, atIndexPath indexPath: IndexPath) {
        let toVc = ULTransitionStyleOneDetailViewController()
        let cell = collectionView.cellForItem(at: indexPath) as! ULTransitionStyleOneCollectionViewCell
        toVc.coverImage = cell.imageView.image
        
        toVc.closeAnimationBlock = ULTransitionStyleOneAnimation().beginAniamtion(colectionView: collectionView, indexPath: indexPath, fromViewController: self, toViewController: toVc, completeBlock:toVc.fadeAnimationBlock)
    }
}
