//
//  RatingViewController.swift
//  MRCH
//
//  Created by MacBook on 9/8/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import DLRadioButton
import Toast_Swift

class RatingViewController: UIViewController {

    @IBOutlet weak var orderNo: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cosmos: CosmosView!
    
    @IBOutlet weak var stack: UIStackView!
    
    var otherTF : UITextField!
    var other: DLRadioButton!
    
    typealias JSONStandard = Dictionary<String, AnyObject>
    
    var rating = 0.0
    
    var orderNum = 0
    
    let url = URLs.reviewURL
    
    var titles : [String] = []
    var typesOpts : [[String]] = []
    var typesIDs : [[Int]] = []
    
     func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func makeCheckBox(_ text:String) -> DLRadioButton {
        let myButton = DLRadioButton(type: .custom)
        
        myButton.titleLabel?.allowsDefaultTighteningForTruncation = false
        //myButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        myButton.setTitle(text, for: .normal)
        myButton.isMultipleSelectionEnabled = true
        myButton.isIconSquare = false
        myButton.iconColor = colors.RestoDefaultColor
        myButton.setTitleColor(colors.RestoDefaultColor, for: .normal)
        
        return myButton
    }
    let border = CALayer()
    override func viewDidLayoutSubviews() {
        let width = CGFloat(2.0)
        border.borderColor = colors.RestoDefaultColor.cgColor
        border.frame = CGRect(x: 0, y: otherTF.frame.size.height - width, width:  otherTF.frame.size.width, height: otherTF.frame.size.height)
        border.borderWidth = width
        otherTF.layer.masksToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground()
        
        self.cosmos.settings.fillMode = .full
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        otherTF = UITextField()
        otherTF.isHidden = true
        otherTF.textAlignment = .center
        otherTF.layer.addSublayer(border)
        
        self.orderNo.text = "Order No. \(orderNum)"
        
        self.cancelBtn.layer.borderColor = colors.RestoDefaultColor.cgColor
        self.cancelBtn.layer.borderWidth = 1.0
        self.cancelBtn.layer.cornerRadius = 5.0
        
        self.confirmBtn.layer.cornerRadius = 5.0
        
        cosmos.didFinishTouchingCosmos = didFinishTouchingCosmos
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandard,
                let dataArray = dict["data"] as? [JSONStandard]{
                for i in 0 ..< dataArray.count {
                    self.titles.append(dataArray[i]["value"] as! String)
                    
                    let types = dataArray[i]["types"] as! [JSONStandard]
                    var values : [String] = []
                    var valuesID :[Int] = []
                    for j in 0..<types.count{
                        values.append(types[j]["value"] as! String)
                        valuesID.append(types[j]["id"] as! Int)
                    }
                    self.typesOpts.append(values)
                    self.typesIDs.append(valuesID)
                }
            }
        })
    }
    
     @objc func showTextField (_ other: DLRadioButton){
        otherTF.isHidden = !otherTF.isHidden
    }
    
    var grp0 : [DLRadioButton] = []
    var grp1 : [DLRadioButton] = []
    var grp2 : [DLRadioButton] = []
    var grp3 : [DLRadioButton] = []
    var grp4 : [DLRadioButton] = []
    
    fileprivate func didFinishTouchingCosmos (_ rating: Double){
        self.rating = rating
        
        other = makeCheckBox("Other")
        other.addTarget(self, action: #selector(showTextField(_:)), for: .touchUpInside)
        
        if other.isSelected {
            other.isSelected = false
        }
        
        if !otherTF.isHidden {
            otherTF.isHidden = true
        }
        switch rating {
        case 1.0:
            self.titleLabel.text = titles[0]
            for view in stack.arrangedSubviews {
                view.removeFromSuperview()
            }
            for i in 0..<typesOpts[0].count{
                let btn = makeCheckBox(typesOpts[0][i])
                btn.tag = self.typesIDs[0][i]
                grp0.append(btn)
                stack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(other)
            stack.addArrangedSubview(otherTF)
            break
//        case 1.5:
//            self.titleLabel.text = titles[1]
//            for view in stack.arrangedSubviews {
//                view.removeFromSuperview()
//            }
//            for i in 0..<typesOpts[1].count{
//                let btn = makeCheckBox(text: typesOpts[1][i])
//                btn.tag = self.typesIDs[1][i]
//                grp1.append(btn)
//                stack.addArrangedSubview(btn)
//            }
//            stack.addArrangedSubview(other)
//            stack.addArrangedSubview(otherTF)
//            break
        case 2.0:
            self.titleLabel.text = titles[1]
            for view in stack.arrangedSubviews {
                view.removeFromSuperview()
            }
            for i in 0..<typesOpts[1].count{
                let btn = makeCheckBox(typesOpts[1][i])
                btn.tag = self.typesIDs[1][i]
                grp1.append(btn)
                stack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(other)
            stack.addArrangedSubview(otherTF)
            break
//        case 2.5:
//            self.titleLabel.text = titles[2]
//            for view in stack.arrangedSubviews {
//                view.removeFromSuperview()
//            }
//            for i in 0..<typesOpts[2].count{
//                let btn = makeCheckBox(text: typesOpts[2][i])
//                btn.tag = self.typesIDs[2][i]
//                grp2.append(btn)
//                stack.addArrangedSubview(btn)
//            }
//            stack.addArrangedSubview(other)
//            stack.addArrangedSubview(otherTF)
//            break
        case 3.0:
            self.titleLabel.text = titles[2]
            for view in stack.arrangedSubviews {
                view.removeFromSuperview()
            }
            for i in 0..<typesOpts[2].count{
                let btn = makeCheckBox(typesOpts[2][i])
                btn.tag = self.typesIDs[2][i]
                grp2.append(btn)
                stack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(other)
            stack.addArrangedSubview(otherTF)
            break
//        case 3.5:
//            self.titleLabel.text = titles[3]
//            for view in stack.arrangedSubviews {
//                view.removeFromSuperview()
//            }
//            for i in 0..<typesOpts[3].count{
//                let btn = makeCheckBox(text: typesOpts[3][i])
//                btn.tag = self.typesIDs[3][i]
//                grp3.append(btn)
//                stack.addArrangedSubview(btn)
//            }
//            stack.addArrangedSubview(other)
//            stack.addArrangedSubview(otherTF)
//            break
        case 4.0:
            self.titleLabel.text = titles[3]
            for view in stack.arrangedSubviews {
                view.removeFromSuperview()
            }
            for i in 0..<typesOpts[3].count{
                let btn = makeCheckBox(typesOpts[3][i])
                btn.tag = self.typesIDs[3][i]
                grp3.append(btn)
                stack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(other)
            stack.addArrangedSubview(otherTF)
            break
//        case 4.5:
//            self.titleLabel.text = titles[4]
//            for view in stack.arrangedSubviews {
//                view.removeFromSuperview()
//            }
//            for i in 0..<typesOpts[4].count{
//                let btn = makeCheckBox(text: typesOpts[4][i])
//                btn.tag = self.typesIDs[4][i]
//                grp4.append(btn)
//                stack.addArrangedSubview(btn)
//            }
//            stack.addArrangedSubview(other)
//            stack.addArrangedSubview(otherTF)
//            break
        case 5.0:
            self.titleLabel.text = titles[4]
            for view in stack.arrangedSubviews {
                view.removeFromSuperview()
            }
            for i in 0..<typesOpts[4].count{
                let btn = makeCheckBox(typesOpts[4][i])
                btn.tag = self.typesIDs[4][i]
                grp4.append(btn)
                stack.addArrangedSubview(btn)
            }
            stack.addArrangedSubview(other)
            stack.addArrangedSubview(otherTF)
            break
        default:
            break
        }
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        if self.rating == 0{
            self.view.makeToast("Please Rate Your Order", duration: 1.5, position: .center)
        }else{
        var parameters = ["order_id": self.orderNum] as [String:Any]
        parameters["score"] = self.rating
        parameters["review_notes"] = self.otherTF.text
        
        var reviewTypes : [Int] = []
        switch self.rating{
        case 1.0:
            for i in 0..<grp0.count{
                if grp0[i].isSelected{
                    reviewTypes.append(grp0[i].tag)
                }
            }
            break
//        case 1.5:
//            for i in 0..<grp1.count{
//                if grp1[i].isSelected{
//                    reviewTypes.append(grp1[i].tag)
//                }
//            }
//            break
        case 2.0:
            for i in 0..<grp1.count{
                if grp1[i].isSelected{
                    reviewTypes.append(grp1[i].tag)
                }
            }
            break
//        case 2.5:
//            for i in 0..<grp2.count{
//                if grp2[i].isSelected{
//                    reviewTypes.append(grp2[i].tag)
//                }
//            }
//            break
        case 3.0:
            for i in 0..<grp2.count{
                if grp2[i].isSelected{
                    reviewTypes.append(grp2[i].tag)
                }
            }
            break
//        case 3.5:
//            for i in 0..<grp3.count{
//                if grp3[i].isSelected{
//                    reviewTypes.append(grp3[i].tag)
//                }
//            }
//            break
        case 4.0:
            for i in 0..<grp3.count{
                if grp3[i].isSelected{
                    reviewTypes.append(grp3[i].tag)
                }
            }
            break
//        case 4.5:
//            for i in 0..<grp4.count{
//                if grp4[i].isSelected{
//                    reviewTypes.append(grp4[i].tag)
//                }
//            }
//            break
        case 5.0:
            for i in 0..<grp4.count{
                if grp4[i].isSelected{
                    reviewTypes.append(grp4[i].tag)
                }
            }
            break
        default:
            break
        }
        parameters["review_types[]"] = reviewTypes
        
        let myurl = "\(URLs.orderIDURL)\(self.orderNum)"
        Alamofire.request(myurl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                if response.result.value != nil {
                    var style = ToastStyle()
                    style.backgroundColor = colors.RestoDefaultColor
                    style.titleColor = UIColor.white
                    style.messageColor = UIColor.white
                    style.cornerRadius = 5.0
                    self.view.makeToast("Thank You For Your Review.", duration: 1.5, position: .center, title: "Review Submitted Successfully", image: nil, style: style,completion: {Void in
                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let nav = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
                        self.view.window?.rootViewController = nav
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                }
        }
        }
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "navController") as! UINavigationController
        self.view.window?.rootViewController = nav
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
