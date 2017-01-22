import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ChampionViewController: UITableViewController , UISearchBarDelegate{

    @IBOutlet weak var searchbar: UISearchBar!
    
    let leageOfLegendsURL = "https://global.api.pvp.net/api/lol/static-data/euw/v1.2/champion?champData=image&api_key=53706bfc-25ca-47b6-ac89-bf1501c44d65"
    var champions = [Champion]()
    var filteredChampions = [Champion]()
    var showFilteredResults = false
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 40, height: 40)))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }

    override func viewDidLoad() {
        activityIndicator()
        indicator.startAnimating()
        callAlamo(url: leageOfLegendsURL)
    }
    
    
    func callAlamo(url: String){
        
        Alamofire.request(url).validate().responseJSON(completionHandler: {
            response in
           DispatchQueue.main.async {

                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    for (_ , object) in json["data"] {
                        let nameImg = object["image","full"].stringValue
                        let urlImg =  URL(string: "https://ddragon.leagueoflegends.com/cdn/7.1.1/img/champion/\(nameImg)")
                        let imgData = NSData(contentsOf: urlImg!)
                        let img = UIImage(data: imgData as! Data )
                        self.champions.append(Champion(name: object["name"].stringValue,
                                                       title: object["title"].stringValue,
                                                       image: img))
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(showFilteredResults){
            return filteredChampions.count
        }else {
            return champions.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewChampionCell", for: indexPath) as! PreviewChampionCell
        if(showFilteredResults){
            self.filteredChampions.sort{$0.name < $1.name}
            cell.championView.image = filteredChampions[indexPath.row].image
            cell.nameLabel.text = filteredChampions[indexPath.row].name
        }else {
            self.champions.sort{$0.name < $1.name}
            cell.championView.image = champions[indexPath.row].image
            cell.nameLabel.text = champions[indexPath.row].name
        }
        if( indicator.isAnimating){
            indicator.stopAnimating()
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let viewController = segue.destination as! ChampionInfoViewController
        if(showFilteredResults){
            viewController.image = filteredChampions[indexPath!].image
            viewController.champTitle = filteredChampions[indexPath!].title

        }else {
            viewController.image = champions[indexPath!].image
            viewController.champTitle = champions[indexPath!].title
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keyword = searchBar.text
        if( keyword?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""){
            showFilteredResults = true
            filteredChampions.removeAll()
            for c in champions {
                if(c.name.lowercased().hasPrefix(keyword!.lowercased())){
                    filteredChampions.append(c)
                }
            }

        }else {
            showFilteredResults = false;
        }
        searchBar.endEditing(true)
        self.tableView.reloadData()
    }
    
}

