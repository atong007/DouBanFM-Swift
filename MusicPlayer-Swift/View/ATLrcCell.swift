//
//  ATLrcCell.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/2/3.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit

class ATLrcCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        self.textLabel?.textColor = UIColor.red
        self.textLabel?.textAlignment = NSTextAlignment.center
        self.selectionStyle = UITableViewCellSelectionStyle.default //UITableViewcell选中后怎么去掉背景灰色
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
        self.isHighlighted = true
        self.isSelected = true
        self.textLabel?.highlightedTextColor = UIColor.white
        self.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open class func cellWithTableView(_ tableview: UITableView) -> UITableViewCell
    {
        let reuseID = "ATLrcCell"
        var cell: ATLrcCell? = tableview.dequeueReusableCell(withIdentifier: reuseID) as! ATLrcCell?
        if cell == nil {
            cell = ATLrcCell.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseID)
        }
        return cell!
    }

}
