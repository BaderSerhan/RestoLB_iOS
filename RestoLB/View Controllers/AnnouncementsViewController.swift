//
//  AnnouncementsViewController.swift
//  MRCH
//
//  Created by MacBook on 9/20/17.
//  Copyright © 2017 mrn. All rights reserved.
//

import UIKit
import Alamofire
import Toast_Swift
import Kingfisher

class AnnouncementsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    typealias JSONStandard = Dictionary<String, AnyObject>
    @IBOutlet weak var annView: UICollectionView!
    
    var annTitles : [String] = []
    var annTexts : [String] = []
    var annImages : [String?] = []
    var numberOfAnnouncements = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //annView.backgroundView = backgroundView
        annView.delegate = self
        annView.dataSource = self
        self.view.makeToastActivity(.center)
        getAnnouncements()
        // Do any additional setup after loading the view.
    }
    
    func getAnnouncements(){
        let myurl = URLs.annURL
        Alamofire.request(myurl).responseJSON(completionHandler: {
            response in
            let result = response.result
            if let dict = result.value as? JSONStandard,
                let dataArray = dict["data"] as? [JSONStandard]{
                self.numberOfAnnouncements = dataArray.count
                for i in 0..<dataArray.count{
                    self.annTitles.append(dataArray[i]["title"] as! String)
                    self.annTexts.append(dataArray[i]["text"] as! String)
                    self.annImages.append((dataArray[i]["image"] as? String))
                }
                
            }
            self.view.hideToastActivity()
            self.annView.reloadData()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = annView.dequeueReusableCell(withReuseIdentifier: "annCell", for: indexPath) as! AnnouncementsCollectionViewCell
        cell.annTitle.text = annTitles[indexPath.row]
        cell.annText.text = annTexts[indexPath.row]
        if let annImageURL = annImages[indexPath.row]{
            cell.imageView.kf.setImage(with: URL(string: annImageURL))
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfAnnouncements
    }
}
