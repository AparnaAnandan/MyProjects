//
//  NewsDetailViewController.swift
//  TheGuardian
//
//  Created by Aparna A on 14/09/21.
//

import UIKit
import AlamofireImage

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var newwDetail: ResultsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNav()
        setUpUI()
    }
    
    func setUpUI() {
        if let news = newwDetail {
            headingLabel.text = news.webTitle
            dateLabel.text = UtilityHelper.convertStringToDate(dateString: news.webPublicationDate)
            bodyLabel.text = news.fields["body"] ?? ""
            if let url = URL(string: news.fields["thumbnail"] ?? "") {
                thumbnailImage.af.setImage(withURL: url)
            }
        }
    }
    
    func setUpNav() {
        let btnWeb =  UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        btnWeb.setImage(UIImage(named: "icon_read"), for: .normal)
        btnWeb.addTarget(self, action: #selector(openBowser), for: .touchUpInside)
        let barBtnWeb = UIBarButtonItem(customView: btnWeb)
        btnWeb.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnWeb.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.navigationItem.rightBarButtonItem = barBtnWeb
        
        let btnBack =  UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 20.0))
        btnBack.setImage(UIImage(named: "icon_back"), for: .normal)
        btnBack.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        btnBack.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        let barBtnBack = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barBtnBack
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openBowser() {
        UtilityHelper.openBrowser(url: newwDetail?.webUrl)
    }
    
}
