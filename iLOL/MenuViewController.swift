import UIKit

class MenuViewController: UIViewController{
    
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var ScoreButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        let urlImg =  URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/MissFortune_8.jpg")
        let imgData = NSData(contentsOf: urlImg!)
        let img = UIImage(data: imgData as! Data )
        backgroundImage.image = img
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}

}
