//
//  FilterViewController.swift
//  CocktailDB
//
//  Created by mac on 31/07/21.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var btnFilter: UIButton!
    
    var arrCategory = [CategoryModel]()
    var applyFilterBlock: ((_ isapply: Bool) -> Void)?
    var strSelectedCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Filters"
        tblList.register(UINib(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        tblList.tableFooterView = UIView()
        
        btnFilter.titleLabel?.font = UIFont(name: FONT_ROBOTO_MEDIUM, size: 16.0)
        btnFilter.layer.borderWidth = 1.0
        btnFilter.layer.borderColor = UIColor.black.cgColor
        btnFilter.layer.cornerRadius = 8
        btnFilter.layer.masksToBounds = true
        btnFilter.isUserInteractionEnabled = false
        setSelectedCategory()
        setButtonEnableDisable()
    }
    
    @IBAction func onClickFilter(_ sender: UIButton){
        setUserDefaultValues("FILTER", value: getSelectedCategory())
        self.applyFilterBlock!(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setSelectedCategory() {
        for data in arrCategory {
            data.isSelected = false
        }
        
        let str = getUserDefaultValue("FILTER")
        let arr = str.components(separatedBy: ",")
        if arr.count > 1 {
            for n in 0...arr.count-1 {
                let strcate: String = arr[n]
                for data in arrCategory {
                    if data.strCategory == strcate {
                        data.isSelected = true
                    }
                }
            }
        }else{
            if str != "" {
                for data in arrCategory {
                    if data.strCategory == str {
                        data.isSelected = true
                    }
                }
            }
        }
        for data in arrCategory {
            if data.isSelected == true {
                strSelectedCategory = strSelectedCategory + data.strCategory + ","
            }
        }
        strSelectedCategory = String(strSelectedCategory.dropLast())
    }
    
    func getSelectedCategory() -> String {
        var str = ""
        for data in arrCategory {
            if data.isSelected == true {
                str = str + data.strCategory + ","
            }
        }
        str = String(str.dropLast())
        return str
    }
    
    func setButtonEnableDisable() {
        if btnFilter.isUserInteractionEnabled == false {
            btnFilter.setTitleColor(APP_DARKGRAY_COLOR, for: .normal)
        }else{
            btnFilter.setTitleColor(UIColor.black, for: .normal)
        }
    }
}

extension FilterViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
        let model: CategoryModel = self.arrCategory[indexPath.row]
        cell.lblName.text = model.strCategory
        cell.btnCheck.isSelected = model.isSelected
        cell.btnCheck.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model: CategoryModel = self.arrCategory[indexPath.row]
        model.isSelected = !model.isSelected
        self.tblList.reloadData()
        if strSelectedCategory != getSelectedCategory() {
            self.btnFilter.isUserInteractionEnabled = true
        }else{
            self.btnFilter.isUserInteractionEnabled = false
        }
        self.setButtonEnableDisable()
    }
}
