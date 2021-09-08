//
//  ViewController.swift
//  Albhum
//
//  Created by Sudha on 08/09/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    var albhumList :  [AlbumsListResponse]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Register UITableviewcell
        let nib = UINib(nibName: "AlbhumCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "albhumcell")
        // Do any additional setup after loading the view.
        loadData(serverSync : false)
    }
    
    //Load data either from local or server and populate the data  in table.
    private func loadData(serverSync : Bool) {
        DataManager.getAlbhumList(serverSync: serverSync)
            .addActivityIndicator(on: self)
            
            .subscribe(onNext: { [weak self] value in
                //Sort by title field
                self?.albhumList = value.sorted(by: {$0.title < $1.title})
                self?.tableView.reloadData()
                return
            }, onError: { (error) in
                DispatchQueue.main.async {
                    //show error
                }
            }).disposed(by: rx.disposeBag)
    }
    // MARK: - IBAction Methods
    @IBAction func syncAlbhumList(_ sender: Any) {
        loadData(serverSync : true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albhumList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "albhumcell", for: indexPath) as! AlbhumCell
        guard let albhumlist = self.albhumList else {
            return UITableViewCell()
        }
        let albhum = albhumlist[indexPath.row]
        cell.title.text = "Title: " + albhum.title
        cell.id.text = "Id: " + "\(albhum.id ?? 0)"
        cell.userid.text = "UserId: " + "\(albhum.userId ?? 0)"
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80.0
    }
}

class AlbhumCell : UITableViewCell
{
    /// outlets
    @IBOutlet weak var userid: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

