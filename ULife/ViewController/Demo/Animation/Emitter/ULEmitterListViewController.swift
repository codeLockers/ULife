//
//  ULEmitterListViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/4/12.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULEmitterListViewController: UIViewController {

    fileprivate let tableView : UITableView = UITableView()
    
    fileprivate let emitterNames : [String] = ["snow","heart","fire","touch","fireworks","like"]
    
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
        self.navigationItem.title = "Emitter"
        self.view.backgroundColor = .white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        self.view.addSubview(self.tableView)
    }
    
    private func layout() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ULEmitterListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emitterNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell?.textLabel?.text = self.emitterNames[indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let animationView = ULEmitterSnowView.init(frame: ULConstants.screen.bounces)
            animationView.delegate = self
            self.navigationController?.view.addSubview(animationView)
        case 1:
            let animationView = ULEmitterHeartView.init(frame: ULConstants.screen.bounces)
            animationView.delegate = self
            self.navigationController?.view.addSubview(animationView)
        case 2:
            let animationView = ULEmitterFireView.init(frame: ULConstants.screen.bounces)
            animationView.delegate = self
            self.navigationController?.view.addSubview(animationView)
        case 3:
            let animationView = ULEmitterTouchView.init(frame: ULConstants.screen.bounces)
            animationView.delegate = self
            self.navigationController?.view.addSubview(animationView)
        case 4:
            let animationView = ULEmitterFireworksView.init(frame: ULConstants.screen.bounces)
            animationView.delegate = self
            self.navigationController?.view.addSubview(animationView)
        case 5:
            let animationView = ULEmitterLikeView.init(frame: ULConstants.screen.bounces)
            animationView.delegate = self
            self.navigationController?.view.addSubview(animationView)
        default:
            break;
        }
    }
}

extension ULEmitterListViewController : ULDemoBaseViewDelegate {
    func demoBaseViewCloseButtonPressed(_ animationView: ULDemoBaseView) {
        animationView.removeFromSuperview()
    }
}
