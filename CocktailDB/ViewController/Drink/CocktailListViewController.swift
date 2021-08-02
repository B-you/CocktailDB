//
//  CocktailListViewController.swift
//  CocktailDB
//
//  Created by mac on 31/07/21.
//

import UIKit
import SDWebImage
import UIScrollView_InfiniteScroll

class CocktailListViewController: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var arrCategory = [CategoryModel]()
    var refreshControl = UIRefreshControl()
    var currentID: Int = 0
    
    var isFilter: Bool = false
    var currentFilterID: Int = 0
    var arrFilterCategory = [CategoryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Drinks"
        self.callCategoryAPI()
        
        lblNoData.isHidden = true
        tblList.register(UINib(nibName: "DrinkCell", bundle: nil), forCellReuseIdentifier: "DrinkCell")
        tblList.register(UINib(nibName: "DrinkHeaderCell", bundle: nil), forCellReuseIdentifier: "DrinkHeaderCell")
        setUserDefaultValues("FILTER", value: "")
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshcall), for: .valueChanged)
        tblList.addSubview(refreshControl)
        tblList.addInfiniteScroll { (tblview) in
            if self.isFilter == true {
                self.loadmoreFilterDrink()
            }else{
                self.loadmoreDrink()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setFilterButton()
    }
    
    
    @objc func refreshcall() {
        self.tblList.finishInfiniteScroll()
        self.refreshControl.endRefreshing()
    }
    
    func setFilterButton() {
        let rightBarButtonItems = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        rightBarButtonItems.removeFromSuperview()
        
        let btnMenu = UIButton(type: .custom)
        if getUserDefaultValue("FILTER") == "" {
            btnMenu.setImage(UIImage(named: "filter"), for: .normal)
        }else{
            btnMenu.setImage(UIImage(named: "filterapply"), for: .normal)
        }
        btnMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        btnMenu.showsTouchWhenHighlighted = true
        btnMenu.addTarget(self, action: #selector(self.onClickFilter), for: .touchUpInside)
        
        
        rightBarButtonItems.addSubview(btnMenu)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButtonItems)
    }
    
    func loadmoreFilterDrink() {
        self.currentFilterID = self.currentFilterID + 1
        print("currentFilterID: \(self.currentFilterID)")
        print("total filter category: \(self.arrFilterCategory.count)")
        if self.currentFilterID < (self.arrFilterCategory.count){
            let model = self.arrFilterCategory[self.currentFilterID]
            if model.arrDrink.count == 0 {
                self.callDrinkListByCategoryAPI(model: model)
            }else{
                loadmoreFilterDrink()
            }
        }else{
            self.tblList.finishInfiniteScroll()
            self.refreshControl.endRefreshing()
        }
    }
    
    func loadmoreDrink() {
        self.currentID = self.currentID + 1
        print("currentID: \(self.currentID)")
        print("total category: \(self.arrCategory.count)")
        if self.currentID < (self.arrCategory.count){
            let model = self.arrCategory[self.currentID]
            if model.arrDrink.count == 0 {
                self.callDrinkListByCategoryAPI(model: model)
            }else{
                loadmoreDrink()
            }
        }else{
            self.tblList.finishInfiniteScroll()
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK: - IBACTION METHODS
    @IBAction func onClickFilter(_ sender: UIBarItem){
        let VC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        VC.arrCategory = self.arrCategory
        VC.applyFilterBlock = {(isapply) in
            if getUserDefaultValue("FILTER") != "" {
                self.arrFilterCategory.removeAll()
                self.isFilter = true
                for data in self.arrCategory {
                    if data.isSelected == true {
                        self.arrFilterCategory.append(data)
                    }
                }
                self.tblList.reloadData()
                self.currentFilterID = 0
                if self.arrFilterCategory.count > 0 {
                    let model = self.arrFilterCategory[0]
                    if model.arrDrink.count == 0 {
                        self.callDrinkListByCategoryAPI(model: model)
                    }
                }
            }else{
                self.isFilter = false
                self.tblList.reloadData()
            }
        }
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension CocktailListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isFilter == true ? self.arrFilterCategory.count : self.arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFilter == true ? self.arrFilterCategory[section].arrDrink.count : self.arrCategory[section].arrDrink.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkHeaderCell") as! DrinkHeaderCell
        let model = self.isFilter == true ? self.arrFilterCategory[section] : self.arrCategory[section]
        cell.lblName.text = model.strCategory.uppercased()
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkCell
        let model = self.isFilter == true ? self.arrFilterCategory[indexPath.section].arrDrink[indexPath.row] : self.arrCategory[indexPath.section].arrDrink[indexPath.row]
        cell.setDrinkData(model: model)
        cell.viewSeperator.isHidden = indexPath.row == self.arrCategory[indexPath.section].arrDrink.count - 1 ? true : false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

//MARK: - API CALLING
extension CocktailListViewController{
    func callCategoryAPI() {
        showHud("")
        ServiceManager.apiCategoryList { (isSuccess, dict) in
            if (isSuccess){
                for data in dict {
                    let model = CategoryModel()
                    model.setData(dict: data)
                    self.arrCategory.append(model)
                }
            }
            if self.arrCategory.count > 0 {
                self.currentID = 0
                let model = self.arrCategory[0]
                self.callDrinkListByCategoryAPI(model: model)
            }else{
                self.lblNoData.isHidden = false
                self.tblList.isHidden = true
                self.hideHUD()
            }
        }
    }
    
    func callDrinkListByCategoryAPI(model: CategoryModel) {
        ServiceManager.apiCategoryDrinkList(strname: model.strCategory) { (isSuccess, dict) in
            self.tblList.finishInfiniteScroll()
            self.refreshControl.endRefreshing()
            
            if(isSuccess){
                for data in dict{
                    let drinkmodel = DrinkModel()
                    drinkmodel.setData(dict: data)
                    model.arrDrink.append(drinkmodel)
                }
            }
            self.hideHUD()
            self.tblList.reloadData()
        }
    }
}
