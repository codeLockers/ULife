//
//  ULChartListViewController.swift
//  ULife
//
//  Created by codeLocker on 2017/4/7.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULChartListViewController: UIViewController {

    fileprivate let tableView  = UITableView()
    fileprivate let chartNames = ["Pie"]
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
    
    //MARK : - Load_UI
    private func loadUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Chart"
        self.tableView.delegate = self
        self.tableView.dataSource = self
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

extension ULChartListViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chartNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = self.chartNames[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let chartPieView = ULChartPieView.init(frame: ULConstants.screen.bounces)
            chartPieView.delegate = self;
            self.navigationController?.view.addSubview(chartPieView)
        default:
            break
        }
    }
}

extension ULChartListViewController : ULDemoBaseViewDelegate {
    func demoBaseViewCloseButtonPressed(_ animationView: ULDemoBaseView) {
        if animationView.superview != nil {
            animationView.removeFromSuperview()
        }
    }
}
