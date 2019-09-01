//
//  HomeViewController.swift
//  VideoAnimation
//
//  Created by Yogendra Tandel on 01/09/19.
//  Copyright © 2019 Yogendra Tandel. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit

struct ButtonInfo {
    let title: String
    let image: String
    let desc: String
    let duration:String
    let videoUrl:String
    //let function: (HomeViewController) -> () -> ()
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTable: UITableView!
    
    var window :UIWindow?
    let mainBtnsArr = [
        
        ButtonInfo(title: "Baaghi 2", image: "https://img1.hotstarext.com/image/upload/f_auto,t_web_vl_3x/sources/r1/cms/prod/5462/245462-v", desc: "A tough army officer is in search of his ex-lover’s child; who is kidnapped under mysterious circums ...", duration:"2 hr 14 min", videoUrl:"http://www.qrez.in/accounts/videos/Qtech_Apr_2019.mp4"),
        ButtonInfo(title: "Pink", image: "https://secure-media1.hotstarext.com/t_web_vl_3x/r1/thumbs/PCTV/78/1000154578/PCTV-1000154578-vl.jpg", desc: "This courtroom drama is a story of three single girls living as tenants in Delhi. On a fateful night ...", duration:"2 hr 10 min", videoUrl:"http://www.qrez.in/accounts/videos/Qtech_May_2019.mp4"),
        ButtonInfo(title: "Baby", image: "https://secure-media1.hotstarext.com/t_web_vl_3x/r1/thumbs/PCTV/38/1000053838/PCTV-1000053838-vl.jpg", desc: "A special task force from Indian intelligence is on a top-secret mission to nab the terrorists and f ...", duration:"2 hr 33 min", videoUrl:"http://www.qrez.in/accounts/videos/Qtech_June_2019.mp4"),
        ButtonInfo(title: "MS Dhoni: The Untold Story", image: "https://secure-media1.hotstarext.com/t_web_vl_3x/r1/thumbs/PCTV/14/1770003314/PCTV-1770003314-vl.jpg", desc: "A tell-all tale about the life and times of Indian cricketer, Mahendra Singh Dhoni; mapping his jour ...", duration:"2 hr 58 min",  videoUrl:"http://www.qrez.in/accounts/videos/Qtech_July_2019.mp4")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let appDelegate =  UIApplication.shared.delegate as? AppDelegate
        window = appDelegate?.window
        myTable.register(UINib(nibName: "HomeCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        myTable.delegate = self
        myTable.dataSource = self
        myTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.black
        }
        let img = UIImage()
        navigationController?.navigationBar.shadowImage = img
        navigationController?.navigationBar.setBackgroundImage(img, for: UIBarMetrics.default)
        navigationController?.navigationBar.backgroundColor =   UIColor.black
        navigationController?.navigationBar.barTintColor =  UIColor.black
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainBtnsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeCell! = myTable.dequeueReusableCell( withIdentifier: "HomeCell") as? HomeCell
        //cell.updateHomeCell()
        
        //Image
        let strImagePath = mainBtnsArr[indexPath.row].image
        if strImagePath != "" {
            let url : NSURL = NSURL(string: strImagePath)!
            cell.img_Movie.sd_setImage(with: url as URL) { (image, error, cache, urls) in
                if (error != nil) {
                    cell.img_Movie.image = UIImage(named: "icon_logo")
                    cell.img_Movie.contentMode = UIView.ContentMode.scaleAspectFit
                } else {
                    cell.img_Movie.image = image
                    cell.img_Movie.clipsToBounds = true
                    cell.img_Movie.contentMode = UIView.ContentMode.scaleAspectFill
                }
            }
        }
        
        cell.lbl_Title.text = mainBtnsArr[indexPath.row].title
        cell.lbl_Desc.text = mainBtnsArr[indexPath.row].desc
        cell.lbl_Duration.text = mainBtnsArr[indexPath.row].duration
        
        cell.btn_Play.layer.cornerRadius = 10
        cell.btn_Play.layer.masksToBounds = true
        cell.btn_Play.tag = indexPath.row
        cell.btn_Play.addTarget(self, action: #selector(PlayVideo), for: .touchUpInside)
        //cell.imhMovieHeight.constant = (window?.frame.width ?? 0) * 9/16
        cell.imhMovieHeight.constant = cell.img_Movie.frame.width * 9/16
        cell.img_Movie.layer.cornerRadius = 10
        cell.img_Movie.layer.masksToBounds = true
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func PlayVideo(sender:UIButton){
        //print(sender.tag)
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer(vp:mainBtnsArr[sender.tag].videoUrl)
    }
    
    
}


struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }}
