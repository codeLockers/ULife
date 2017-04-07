//
//  ULNavBarTransparentViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/17.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

/*
 * 参考 : http://www.jianshu.com/p/454b06590cf1
 */

import UIKit
import SnapKit

class ULNavBarTransparentViewController: ULBaseViewController {
    
    fileprivate let tableView : UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        layout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load_UI
    private func loadUI(){
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        view.addSubview(tableView)
        
        let tableViewHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ULConstants.screen.width, height: 200))
        tableViewHeaderView.backgroundColor = UIColor.orange
        tableView.tableHeaderView = tableViewHeaderView
        
        automaticallyAdjustsScrollViewInsets = false
        //设置NavigationBar背景透明度
        ul_navBarBgAlpha = 0.0
        ul_navBarTintColor = UIColor.red
    }
    
    private func layout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULNavBarTransparentViewController : UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell?.textLabel?.text = "第\(indexPath.row)行"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ULNavBarTransparentViewController(), animated: true)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let contentOffsetY = scrollView.contentOffset.y
        let showNavBarOffsetY = 200 - topLayoutGuide.length
        //navBar的alpha
        if contentOffsetY > showNavBarOffsetY {
            var newAlpha = (contentOffsetY - (showNavBarOffsetY)) / 40.0
            if newAlpha > 1 {
                newAlpha = 1
            }
            ul_navBarBgAlpha = newAlpha
            if ul_navBarBgAlpha > 0.8 {
                ul_navBarTintColor = ULConstants.color.defaultNavigationBarTintColor
            }else{
                ul_navBarTintColor = UIColor.red
            }
        }else{
            ul_navBarBgAlpha = 0.0
            ul_navBarTintColor = UIColor.red
        }
    }
}
