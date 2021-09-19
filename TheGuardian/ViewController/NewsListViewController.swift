//
//  NewsListViewController.swift
//  TheGuardian
//
//  Created by Aparna A on 14/09/21.
//

import UIKit
import AlamofireImage
import CoreData

class NewsListViewController: UIViewController {
    
    @IBOutlet weak var newsListTableView: UITableView!
    
    let cellIdentifier = "newsListCell"
    var results : [ResultsModel] = []
    var cachedImages : [UIImage] = []
    var refreshControl = UIRefreshControl()
    var managedContext:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsListTableView.estimatedRowHeight = 190
        newsListTableView.rowHeight = UITableView.automaticDimension
        newsListTableView.tableFooterView = UIView()
        refreshControl.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        newsListTableView.refreshControl = refreshControl // Pull to refresh
        refreshControl.addTarget(self, action: #selector((getLatestNews)), for:UIControl.Event.valueChanged )
        _ = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(getLatestNews), userInfo: nil, repeats: true) //Refresh data in every 1 minute
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
            managedContext = appdelegate.persistentContainer.viewContext
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.beginRefreshing()
        getLatestNews()
    }
    
    @objc func getLatestNews() {
        print("getLatestNews=====>")
        let url: URL! = URL(string: ApiManager.url)
        ApiManager.sendRequestJsonResponse(url: url, methodType: MethodType.GET, body: nil, completionHander: { response, error in
            if response != nil {
                self.saveOrUpdate(newsData: response?.results ?? []) // Save and Update the results
            }
            //If error mapResulObjects will fetch from DB and show
            self.mapResulObjects()
            self.newsListTableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
    
    func redirectToDetailScreen(row:Int) {
        if let detailNavController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailNavigation") as? UINavigationController {
            let newsDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailViewController") as! NewsDetailViewController
            newsDetailVC.newwDetail = results[row]
            detailNavController.viewControllers.append(newsDetailVC)
            detailNavController.modalPresentationStyle = .fullScreen
            self.present(detailNavController, animated: true, completion: nil)
        }
    }
    
}

//MARK: - Tableview methods

extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsListTableViewCell
        cell.headingLabel.text = results[indexPath.row].webTitle
        let body = UtilityHelper.removeHTMPTags(paragraph: results[indexPath.row].fields["body"])
        results[indexPath.row].fields["body"] = body
        let components = body.components(separatedBy: ".")
        let firstTwoLines = components[0] +  components[1]
        cell.contentLabel.text = firstTwoLines
        if let url = URL(string: results[indexPath.row].fields["thumbnail"] ?? "") {
            cell.thumbnailImaage.af.setImage(withURL: url)
        }
        cell.dateLabel.text = UtilityHelper.convertStringToDate(dateString: results[indexPath.row].webPublicationDate) 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        redirectToDetailScreen(row: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Core Data

extension NewsListViewController {
    
    func saveOrUpdate(newsData: [ResultsModel]) {
        
        let entity =
            NSEntityDescription.entity(forEntityName: "NewsDetails",
                                       in: managedContext!)!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NewsDetails")
        
        do {
            for news in newsData {
                fetchRequest.predicate = NSPredicate(format: "id = %@", news.id)
                if let fetchResults = try managedContext?.fetch(fetchRequest) as? [NSManagedObject] {
                    if fetchResults.count != 0 {
                        // update existing entry
                        let managedObject = fetchResults[0]
                        managedObject.setValue(news.webPublicationDate, forKeyPath: "date")
                        managedObject.setValue(news.webTitle, forKeyPath: "title")
                        managedObject.setValue(news.fields["body"], forKeyPath: "body")
                        managedObject.setValue(news.fields["thumbnail"], forKeyPath: "thumbnail")
                        managedObject.setValue(news.webUrl, forKeyPath: "webUrl")
                        managedObject.setValue(news.id, forKeyPath: "id")
                        managedContext?.insert(managedObject)
                    } else {
                        //Add new Entry
                        let newsObjc = NSManagedObject(entity: entity, insertInto: managedContext)
                        newsObjc.setValue(news.webPublicationDate, forKeyPath: "date")
                        newsObjc.setValue(news.webTitle, forKeyPath: "title")
                        newsObjc.setValue(news.fields["body"], forKeyPath: "body")
                        newsObjc.setValue(news.fields["thumbnail"], forKeyPath: "thumbnail")
                        newsObjc.setValue(news.webUrl, forKeyPath: "webUrl")
                        newsObjc.setValue(news.id, forKeyPath: "id")
                    }
                }
            }
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    // fetch from DB and maps to local variable
    func mapResulObjects() {
        let fetchRequest = NSFetchRequest<NewsDetails>(entityName: "NewsDetails")
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let resultObjects = try? self.managedContext?.fetch(fetchRequest)
        if let newsObjects = resultObjects {
            self.results.removeAll()
            for result in newsObjects {
                let model = ResultsModel()
                model.webPublicationDate = result.date ?? ""
                model.id = result.id ?? ""
                model.fields["body"] = result.body
                model.fields["thumbnail"] = result.thumbnail ?? ""
                model.webUrl = result.webUrl ?? ""
                model.webTitle = result.title ?? ""
                self.results.append(model)
            }
        }
    }
    
}
