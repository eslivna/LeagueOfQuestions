import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var qLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var questionViewBlur: UIVisualEffectView!
    @IBOutlet var pauseView: UIView!
    @IBOutlet weak var backgroundBlur: UIVisualEffectView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var popUpTitel: UILabel!
    @IBOutlet weak var popUpStopBtn: UIButton!
    @IBOutlet weak var popUpCancelBtn: UIButton!
    
    let apiKey = "53706bfc-25ca-47b6-ac89-bf1501c44d65";
    let leageOfLegendsURL = "https://global.api.pvp.net/api/lol/static-data/euw/v1.2/champion?champData=image&api_key=53706bfc-25ca-47b6-ac89-bf1501c44d65"
    
    var questions = [Question]()
    var qAnswer : Int!
    var score = 0
    var lives = 3
    var gameOver = false;
    
    override func viewDidLoad() {
        //Set background picture with a blur
        questionViewBlur.isHidden = true;
        questionViewBlur.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let urlImg =  URL(string: "https://ddragon.leagueoflegends.com/cdn/img/champion/splash/MissFortune_8.jpg")
        let imgData = NSData(contentsOf: urlImg!)
        let img = UIImage(data: imgData as! Data )
        backgroundImage.image = img
        backgroundImage.contentMode = UIViewContentMode.bottomLeft
        
        backgroundBlur.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        
        //corner pauseview and questionbuttons
        pauseView.layer.cornerRadius = 5
        for i in 0..<buttons.count {
            buttons[i].layer.cornerRadius = 5
        }
        callAlamo(url: leageOfLegendsURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func callAlamo(url: String){
        
        Alamofire.request(url).validate().responseJSON(completionHandler: {
            response in
            DispatchQueue.main.async {
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                for (_ , object) in json["data"] {
                    self.questions.append(Question(
                        question: object["name"].stringValue ,
                        answers: [object["title"].stringValue],
                        answer: 0
                    ))
                }
                self.generateQuestions()
                
            case .failure(let error):
                print(error)
            }
            }
        })
    }
    
    
    func generateQuestions(){
        var randomIndex : Int
        var rightAnswer : String
        for i in 0..<questions.count {
            for _ in 0...2 {
                randomIndex = Int(arc4random_uniform(UInt32(questions.count)))
                if( randomIndex != i){
                questions[i].answers.append(questions[randomIndex].answers[0])
                }
            }
            rightAnswer = questions[i].answers[0]
            questions[i].answers.shuffle()
            questions[i].answer = questions[i].answers.index(of: rightAnswer)
        }
        pickQuestion()
    }
    
    func pickQuestion() {
        questions.shuffle()
        if questions.count > 0 {
            qLabel.text = "What is the title of \(questions[0].question!)?"
            qAnswer = questions[0].answer
            
            for i in 0..<buttons.count {
                
                buttons[i].setTitle( questions[0].answers[i], for: UIControlState.normal)
            }
            
            questions.removeFirst()
        }else {
            NSLog("Missing")
        }
        
    }
    
    func updateScore(with number: Int){
        var scoreToAdd = number
        if(score == 0 && number < 0){
            scoreToAdd = 0
        }
        score += scoreToAdd
        scoreLabel.text = "\(score)"
    }
    
    func decreaseLives(){
        lives -= 1
        if(lives <= 0){
            gameOver=true;
            self.view.addSubview(pauseView)
            questionViewBlur.isHidden = false
            pauseView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 3)
            popUpTitel.text = "Game Over \n\nScore: \(score)"
            popUpCancelBtn.isHidden = true
            
        }else{
            if(lives == 2){
                livesLabel.text = "❤️❤️"
            }else{
                livesLabel.text = "❤️"
            }
        }
    }
    
    @IBAction func Btn1(_ sender: Any) {
        if qAnswer == 0 {
            updateScore(with: 5)
        } else {
            updateScore(with: -2)
            decreaseLives()
            print("Wrong BTN 1")
        }
        pickQuestion()

    }
    @IBAction func Btn2(_ sender: Any) {
        if qAnswer == 1 {
            updateScore(with: 5)
        }else {
            updateScore(with: -2)
            decreaseLives()
            print("Wrong BTN 2")
        }
        pickQuestion()

    }
    @IBAction func Btn3(_ sender: Any) {
        if qAnswer == 2 {
            updateScore(with: 5)
        }else {
            updateScore(with: -2)
            decreaseLives()
            print("Wrong BTN3")
        }
        pickQuestion()

    }
    @IBAction func Btn4(_ sender: Any) {
        if qAnswer == 3 {
            updateScore(with: 5)
        }else {
            updateScore(with: -2)
            decreaseLives()
            print("Wrong BTN4")
        }
        pickQuestion()

    }
    
    @IBAction func pauseQuiz(_ sender: Any) {
        self.view.addSubview(pauseView)
        questionViewBlur.isHidden = false
        pauseView.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 3)
    }
    @IBAction func closePauseView(_ sender: Any) {
        questionViewBlur.isHidden = true
        self.pauseView.removeFromSuperview()
    }
    
    @IBAction func unwindToMenu(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMenu", sender: self)
    }
}



//http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}




