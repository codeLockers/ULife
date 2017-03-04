//
//  ULAnimationViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/3/4.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

class ULAnimationViewController: UIViewController {

    fileprivate let tableView : UITableView = UITableView()
    
    fileprivate let animationNameArray : [String] = ["Style-One"]
    
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
    
    //MARK: - Load_UI
    private func loadUI() {
        
        navigationItem.title = "Animations"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULAnimationViewController : UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animationNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: String( describing: UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: String(describing: UITableViewCell.self))
            cell!.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = animationNameArray[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let animationView = ULAnimationStyleOneView.init(frame: ULConstants.Screen.bounces)
            animationView.delegate = self
            navigationController?.view.addSubview(animationView)
            break
        default:
            break
        }
    }
    
    
}

extension ULAnimationViewController:ULAnimationStyleBaseViewDelegate{

    func aniamtionStyleViewCloseButtonPressed(_ animationStyleView : ULAnimationStyleBaseView){
        
        if animationStyleView.superview != nil {
            animationStyleView.removeFromSuperview()
        }
    }
}
