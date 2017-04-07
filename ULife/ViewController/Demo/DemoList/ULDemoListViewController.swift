//
//  ULDemoListViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/2.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

class ULDemoListViewController: ULBaseViewController {

    fileprivate let tableView = UITableView()
    
    fileprivate let demoNames : [String] = ["EasyMisreadWord","Animations","GesturePassword","Chart"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUI()
        self.layout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.navigationItem.title = "Demo"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        self.view.addSubview(tableView)
    }
    //MARK: - Layout
    private func layout() {
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULDemoListViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell!.selectionStyle = .none
        cell!.accessoryType = .disclosureIndicator
        cell!.textLabel?.text = demoNames[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(ULEasyMisreadWordViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(ULAnimationViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(ULGesturePasswordViewController(), animated: true)
        case 3:
            self.navigationController?.pushViewController(ULChartListViewController(), animated: true)
        default:
            break
        }
    }
}
