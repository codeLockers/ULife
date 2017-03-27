//
//  ULSidebar.swift
//  ULife
//
//  Created by codeLocker on 2017/2/22.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

protocol ULSidebarDelegate : NSObjectProtocol {
    
    func sidebarDidSelectAtIndex(_ index:NSInteger)
}

class ULSidebar: UIView , UITableViewDelegate , UITableViewDataSource{

    let imageArray : [String] = ["","ul_sidebar_weather","ul_sidebar_demo","ul_sidebar_calendar"]
    var delegate : ULSidebarDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        self.loadUI()
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ULSidebarCell.self), for: indexPath) as! ULSidebarCell
        cell.setUpCellWithImage(imageArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.delegate?.sidebarDidSelectAtIndex(indexPath.row)
    }
    
    //MARK: - Load_UI
    private func loadUI(){
    
        self.addSubview(tableView)
    }
    
    private func layout(){
        
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setter && Getter
    private lazy var tableView : UITableView! = { () -> UITableView in
    
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        tableView.backgroundColor = UIColor.ul_random()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ULSidebarCell.self, forCellReuseIdentifier: String(describing: ULSidebarCell.self))
        return tableView;
    }()
}
