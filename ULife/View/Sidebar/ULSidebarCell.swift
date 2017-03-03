//
//  ULSidebarCell
//  ULife
//
//  Created by codeLocker on 2017/3/1.
//  Copyright © 2017年 codeLocker. All rights reserved.
//

import UIKit
import SnapKit

class ULSidebarCell: UITableViewCell {

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
        self.selectionStyle = .none
        self.loadUI()
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public_Methods
    func setUpCellWithImage(_ imageName:String) {
        
        if imageName.characters.count == 0 {
            return
        }
        
        iconView.image = UIImage.init(named: imageName)
    }
    
    //MARK: - Load_UI
    private func loadUI() {
        self.contentView.backgroundColor = UIColor.ul_random()
        self.contentView.addSubview(iconView)
    }
    
    private func layout(){
        
        iconView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    //MARK: - Setter && Getter
    private lazy var iconView : UIImageView! = { () -> UIImageView! in
    
        let imageView = UIImageView()
        return imageView
    }()
}
