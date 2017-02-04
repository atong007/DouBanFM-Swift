//
//  ATLrcView.swift
//  MusicPlayer-Swift
//
//  Created by 洪龙通 on 2017/2/3.
//  Copyright © 2017年 蓝海天网科技. All rights reserved.
//

import UIKit

class ATLrcView: UIView, UITableViewDelegate, UITableViewDataSource {
    weak var lrcTableView: UITableView!
    var lrcData: ATLrcModel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 23;
        tableView.isScrollEnabled = false;
        tableView.allowsSelection = true;
        tableView.isUserInteractionEnabled = false;
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(tableView)
        self.lrcTableView = tableView
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lrcTableView.frame = self.bounds;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.lrcData == nil {
            return 0;
        }
        return self.lrcData!.timeArray.count;
    }
    
    /**
     *  tableView cell的设置
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //1.创建cell
        let cell = ATLrcCell.cellWithTableView(tableView)
        
        //2.设置cell属性
        let timeStr = self.lrcData?.timeArray[indexPath.row]
        cell.textLabel?.text = self.lrcData?.lrcDictionary[timeStr!]
        
        //3.返回cell
        return cell;
    }
    
    open func reloadData() {
        self.lrcTableView.reloadData()
    }
    
    open func selectRow(_ row: NSInteger) {
        self.lrcTableView.selectRow(at: IndexPath.init(row: row, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
    }

}
