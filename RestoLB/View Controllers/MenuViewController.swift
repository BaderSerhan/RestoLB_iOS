//
//  MenuViewController.swift
//  MRCH
//
//  Created by mrn on 3/7/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import Toast_Swift
import SideMenu

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    let numberOfCateories = 6
    var selectedCategory : String = ""
    var selectedCategoryID = 0
    var categories : [String] = []
    var categoryImages: [String] = []
    var id: [Int] = []
    
    var arrFCB : NSArray = NSArray()
    
    fileprivate let order = OrderModel()
    
    @IBOutlet var collectionView: UICollectionView!
    
    var tray : TrayViewController!
    
    @IBAction func gotoTray(_ sender: UIBarButtonItem) {
        
        if tray == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            tray = storyboard.instantiateViewController(withIdentifier: "trayView") as! TrayViewController
        }
        self.navigationController!.pushViewController(tray, animated: true)
    }
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Untitled-1"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        self.view.makeToastActivity(.center)
        self.getCategories()
        collectionView.delegate=self
        collectionView.dataSource=self
        
        SideMenuManager.menuFadeStatusBar = false
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "sideMenu") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.view)
    }
    
    func getCategories(){
        Alamofire.request(URLs.categoriesURL).responseJSON{ response in

            if let jsonResponse = response.result.value {
                let parsedJSON = JSON(jsonResponse)
                let mydata: NSArray = (parsedJSON["data"].object as? NSArray)!
                self.arrFCB = mydata
                var zcategory = NSDictionary()
                var catTitle = ""
                var catImage = ""
                var catID = 0

                for i in 0..<self.arrFCB.count{
                    zcategory = self.arrFCB[i] as! NSDictionary
                    catTitle = (zcategory["name"] as! NSString) as String
                    catImage = (zcategory["image"] as! NSString) as String
                    catID = zcategory["id"] as! NSInteger

                    self.categories.append(catTitle)
                    self.categoryImages.append(catImage)
                    self.id.append(catID)
                }
                self.view.hideToastActivity()
                self.collectionView.reloadData()
            }
        }
        
//        //static way
//        self.id = [1,2,3,4,5,6]
//        self.categories = ["Appetizers", "Breakfast", "Pizza", "Hot Dog", "Burgers", "Sweets"]
//        self.categoryImgs = [#imageLiteral(resourceName: "images"), #imageLiteral(resourceName: "20525235_1374782439307163_3000067886079077519_n"), #imageLiteral(resourceName: "ximages"), #imageLiteral(resourceName: "download"), #imageLiteral(resourceName: "berger"), #imageLiteral(resourceName: "21432887_1403892963062777_5112675843440341321_n")]
//        self.view.hideToastActivity()
//        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        selectedCategoryID = id[indexPath.row]
        performSegue(withIdentifier: "gotoFoodItems", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryName.text = categories[indexPath.row]
        let cat = categories[indexPath.row].lowercased();
        let catImage = categoryImages[indexPath.row];
        if(cat != ""){
            let url = URL(string: catImage)

            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.categoryImage.kf.setImage(with: url)

        cell.layoutIfNeeded()
            cell.categoryImage.layer.cornerRadius = cell.categoryImage.frame.size.width/2;
            cell.categoryImage.clipsToBounds = true;
            cell.categoryImage.layer.borderWidth = 1.0;
            cell.categoryImage.layer.borderColor = colors.RestoDefaultColor.cgColor
            cell.categoryImage.layer.backgroundColor = UIColor.white.cgColor
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width;
        let cellWidth = (screenWidth) / 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size = CGSize(width: cellWidth, height: cellWidth)
        
        return size;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoFoodItems" {
            let svc = segue.destination as! FoodItemsViewController
            svc.selectedCategoryID = String(selectedCategoryID)
            svc.selectedCategory = selectedCategory            
        }
    }
    
}
