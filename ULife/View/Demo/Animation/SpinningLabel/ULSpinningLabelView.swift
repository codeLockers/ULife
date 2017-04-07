//
//  ULSpinningLabelView.swift
//  ULife
//
//  Created by codeLocker on 2017/3/20.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit

class ULSpinningLabelView: ULAnimationBaseView {

    fileprivate let tilteView : UIView = UIView()
    fileprivate let tableView : UITableView = UITableView()
    fileprivate let tableViewItems : [String] = ["Section 1","Section Two","Third Section","Long Section Name","Very Very Long Section Name","Section 61","Section Two1","Thi1rd Section","Lon1g Section Name","Ver1y Very Long Sec1tion Name","Sec11tion 6"]
    
    private let spinningLab : ULSpinningLabel = ULSpinningLabel.init(title: "Section 1")
    
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
        tilteView.backgroundColor = ULConstants.color.defaultNavigationBarBackgroundColor
        addSubview(tilteView)
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 250
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        addSubview(tableView)
        
        tilteView.addSubview(spinningLab)
    }
    
    private func layout() {
    
        tilteView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(tilteView.snp.bottom)
            make.bottom.equalTo(startBtn.snp.top)
        }
        
        spinningLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    //MARK: - Private_Methods
    fileprivate func updateTitleViewTitle() {
        //tableView中可视row的indexPath
        let indexPathForVisableRows : [NSIndexPath]? = tableView.indexPathsForVisibleRows as [NSIndexPath]?
        //第一个item的index
        let indexOfFirstVisableItem : NSInteger? = indexPathForVisableRows?.first?.row
        let title = self.tableViewItems[indexOfFirstVisableItem!]
        updateTitle(title)
    }
    
    private func updateTitle(_ title:String){
        if self.spinningLab.title == title {
            return
        }
        //原先Title
        let oldTitle : String? = self.spinningLab.title
        //原先Title的下标
        let oldItemIndex : NSInteger? = tableViewItems.index(of: oldTitle ?? "")
        //新的Title的下标
        let newItemIndex : NSInteger? = tableViewItems.index(of: title)
        //方向
        var spinDirection : ULSpinningLabelDirection = .upWard
        if oldItemIndex != nil && newItemIndex != nil {
            //从上往下还是从下往上
            spinDirection = oldItemIndex! < newItemIndex! ? .upWard : .downWard
        }
        
        let attributes : Dictionary = [NSFontAttributeName : UIFont.systemFont(ofSize: 16),NSForegroundColorAttributeName : UIColor.white]
        let attributeString : NSAttributedString = NSAttributedString.init(string: title, attributes: attributes)
        
        spinningLab.setAttributedTitle(attributeString, spinDirection: spinDirection, spinSetting: .animated)
    }
}

extension ULSpinningLabelView : UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        cell?.textLabel?.text = tableViewItems[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateTitleViewTitle()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateTitleViewTitle()
    }
}
