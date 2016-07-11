//
//  LobbyViewController.swift
//
//
//  Created by Milton Leung on 2016-06-23.
//
//

import UIKit

class LobbyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var roomNameLabel: UILabel!
    
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var player3: UILabel!
    @IBOutlet weak var player4: UILabel!
    @IBOutlet weak var player5: UILabel!
    @IBOutlet weak var player6: UILabel!
    
    @IBOutlet weak var status1: UIButton!
    @IBOutlet weak var status2: UIButton!
    @IBOutlet weak var status3: UIButton!
    @IBOutlet weak var status4: UIButton!
    @IBOutlet weak var status5: UIButton!
    @IBOutlet weak var status6: UIButton!
    
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var isReady:Bool = false
    var canStart:Bool = false
    var timer = NSTimer()
    var categorySelected = false
    var category:String?
    
    var timerRunning:Bool = false
    
    var doneMovies:[Int]?
    var doneFamous:[Int]?
    var doneTV:[Int]?
    var doneCelebs:[Int]?
    
    var modules:[String: AnyObject]?
    var selectedModule:AnyObject?
    var selectedName:String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var countdownView: UIView!
    @IBAction func readyButton(sender: UIButton) {
        if isReady == false {
            isReady = true
            sender.selected = true
            if !ready!.contains(myName) {
                ready?.append(myName)
            }
        } else {
            isReady = false
            sender.selected = false
            if ready!.contains(myName) {
                let index = ready?.indexOf(myName)
                ready?.removeAtIndex(index!)
            }
        }
        ModelInterface.sharedInstance.iamready(roomName!, ready: ready!)
    }
    
    @IBAction func backButton(sender: AnyObject) {
        //        if ready!.contains(myName) {
        //            let index = ready?.indexOf(myName)
        //            ready?.removeAtIndex(index!)
        //
        //        }
        //        if players!.contains(myName) {
        //            let index = players?.indexOf(myName)
        //            players?.removeAtIndex(index!)
        //        }
        //        isLeader = false
        //        ModelInterface.sharedInstance.iamleaving(roomName!, ready: ready!, players: players!)
        self.performSegueWithIdentifier("roomsSegue", sender: nil)
    }
    
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButton(sender: AnyObject) {
        
        if canStart == true && categorySelected == true {
            if timerRunning == true {
                invalidateTimer()
                ModelInterface.sharedInstance.startGame(roomName!, startTime: 0)
            } else {
                invalidateTimer()
                //            startButton.hidden = true
                startButton.setTitle("", forState: .Normal)
                timerRunning = true
                timerLabel.text = "\(countDownTime)"
                
                
                let startTime = Int(NSDate().timeIntervalSince1970) + countDownTime
                ModelInterface.sharedInstance.startGame(roomName!, startTime: startTime)
                countdownView.hidden = false
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LobbyViewController.updateCountdown), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            tvButton.hidden = false
            moviesButton.hidden = false
            celebritiesButton.hidden = false
            famousButton.hidden = false
            collectionView.hidden = true
        case 1:
            tvButton.hidden = true
            moviesButton.hidden = true
            celebritiesButton.hidden = true
            famousButton.hidden = true
            collectionView.hidden = false
        default:
            break;
        }
    }
    
    @IBOutlet weak var moviesButton: UIButton!
    @IBAction func movies(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            if isLeader == true {
                categorySelected = false
                startButton.alpha = 0.5
            }
        } else {
            if isLeader == true {
                categorySelected = true
                category = "movies"
                sender.selected = true
                celebritiesButton.selected = false
                tvButton.selected = false
                famousButton.selected = false
                
                categoryAction()
            }
        }
    }
    
    @IBOutlet weak var celebritiesButton: UIButton!
    @IBAction func celebrities(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            if isLeader == true {
                categorySelected = false
                startButton.alpha = 0.5
            }
        } else {
            if isLeader == true {
                categorySelected = true
                category = "celebs"
                sender.selected = true
                moviesButton.selected = false
                tvButton.selected = false
                famousButton.selected = false
                
                categoryAction()
            } else {
                sender.adjustsImageWhenHighlighted = false
            }
        }
    }
    
    @IBOutlet weak var tvButton: UIButton!
    @IBAction func tv(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            if isLeader == true {
                categorySelected = false
                startButton.alpha = 0.5
            }
        } else {
            if isLeader == true {
                categorySelected = true
                category = "tv"
                sender.selected = true
                moviesButton.selected = false
                celebritiesButton.selected = false
                famousButton.selected = false
                
                categoryAction()
            }
        }
    }
    
    @IBOutlet weak var famousButton: UIButton!
    @IBAction func famous(sender: UIButton) {
        if sender.selected {
            sender.selected = false
            if isLeader == true {
                categorySelected = false
                startButton.alpha = 0.5
            }
        } else {
            if isLeader == true {
                categorySelected = true
                category = "famous"
                sender.selected = true
                moviesButton.selected = false
                tvButton.selected = false
                celebritiesButton.selected = false
                
                categoryAction()
            }
        }
    }
    
    func categoryAction() {
        if category == "movies" {
            repeat {
                rand = Int(arc4random_uniform(UInt32(movies!.count)))
            } while doneMovies!.contains(rand!)
            doneMovies!.append(rand!)
            ModelInterface.sharedInstance.updateDone(roomName!, done: doneMovies!, category: "movies")
        } else if category == "celebs" {
            repeat {
                rand = Int(arc4random_uniform(UInt32(celebs!.count)))
            } while doneCelebs!.contains(rand!)
            doneCelebs!.append(rand!)
            ModelInterface.sharedInstance.updateDone(roomName!, done: doneCelebs!, category: "celebs")
        } else if category == "tv" {
            repeat {
                rand = Int(arc4random_uniform(UInt32(tv!.count)))
            } while doneTV!.contains(rand!)
            doneTV!.append(rand!)
            ModelInterface.sharedInstance.updateDone(roomName!, done: doneTV!, category: "tv")
        } else if category == "famous" {
            repeat {
                rand = Int(arc4random_uniform(UInt32(famous!.count)))
            } while doneFamous!.contains(rand!)
            doneFamous!.append(rand!)
            ModelInterface.sharedInstance.updateDone(roomName!, done: doneFamous!, category: "famous")
        }
        
        
        
        let currentPlayer = players![(rand! % ((players?.count)! - 1)) + 1]
        ModelInterface.sharedInstance.updateTurn(roomName!, currentSelection: self.rand!, currentPlayer: currentPlayer, category: category!)
    }
    
    var roomName:String?
    var movies:[String]?
    var famous:[String]?
    var celebs:[String]?
    var tv:[String]?
    
    var rand:Int?
    var players:[String]?
    var ready:[String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = roomName
        movies = NSUserDefaults.standardUserDefaults().arrayForKey("movies") as? [String]
        famous = NSUserDefaults.standardUserDefaults().arrayForKey("famous") as? [String]
        celebs = NSUserDefaults.standardUserDefaults().arrayForKey("celebs") as? [String]
        tv = NSUserDefaults.standardUserDefaults().arrayForKey("tv") as? [String]
        
        setupGame("movies")
        
        clearPlayers()
        
        collectionView.hidden = true
        
        countdownView.hidden = true
        //        collectionView.hidden = true
        
        famousButton.selected = false
        tvButton.selected = false
        moviesButton.selected = false
        celebritiesButton.selected = false
        
        if isLeader == true {
            startButton.alpha = 0.5
        } else {
            startButton.hidden = true
        }
        canStart = false
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func invalidateTimer() {
        NSNotificationCenter.defaultCenter().postNotificationName("timeStop", object: nil)
        countdownView.hidden = true
        timer.invalidate()
        timerLabel.text = ""
        countDownTime = 8
        timerRunning = false
        startButton.setTitle("start", forState: .Normal)
        
    }
    
    func willEnterBackground() {
        if ready!.contains(myName) {
            let index = ready?.indexOf(myName)
            ready?.removeAtIndex(index!)
            
        }
        if players!.contains(myName) {
            let index = players?.indexOf(myName)
            players?.removeAtIndex(index!)
        }
        isLeader = false
        ModelInterface.sharedInstance.iamleaving(roomName!, ready: ready!, players: players!)
        
    }
    
    func updateCountdown() {
        if countDownTime > 0 {
            if canStart == true {
                countDownTime -= 1
                timerLabel.text = "\(countDownTime)"
                NSNotificationCenter.defaultCenter().postNotificationName("timeChange", object: nil)
            } else {
                invalidateTimer()
                
                
            }
        } else {
            invalidateTimer()
            performSegueWithIdentifier("movieSegue", sender: nil)
            
        }
    }
    
    func clearPlayers() {
        player1.hidden = true
        player2.hidden = true
        player3.hidden = true
        player4.hidden = true
        player5.hidden = true
        player6.hidden = true
        
        status1.hidden = true
        status2.hidden = true
        status3.hidden = true
        status4.hidden = true
        status5.hidden = true
        status6.hidden = true
    }
    
    func setupLabels() {
        player1.hidden = true
        player2.hidden = true
        player3.hidden = true
        player4.hidden = true
        player5.hidden = true
        player6.hidden = true
        
        status1.hidden = true
        status2.hidden = true
        status3.hidden = true
        status4.hidden = true
        status5.hidden = true
        status6.hidden = true
        
        
        if players!.count > 1 {
            player1.hidden = false
            status1.hidden = false
            status1.setTitle("..", forState: UIControlState.Normal)
            player1.text = players![1]
        }
        if players!.count > 2 {
            player2.hidden = false
            status2.hidden = false
            status2.setTitle("..", forState: UIControlState.Normal)
            player2.text = players![2]
        }
        if players!.count > 3 {
            player3.hidden = false
            status3.hidden = false
            status3.setTitle("..", forState: UIControlState.Normal)
            player3.text = players![3]
        }
        if players!.count > 4 {
            player4.hidden = false
            status4.hidden = false
            status4.setTitle("..", forState: UIControlState.Normal)
            player4.text = players![4]
        }
        if players!.count > 5 {
            player5.hidden = false
            status5.hidden = false
            status5.setTitle("..", forState: UIControlState.Normal)
            player5.text = players![5]
        }
        if players!.count > 6 {
            player6.hidden = false
            status6.hidden = false
            status6.setTitle("..", forState: UIControlState.Normal)
            player6.text = players![6]
        }
        
        for player in ready! {
            if let index = players?.indexOf("\(player)") {
                switch Int(index) {
                case 1:
                    status1.setTitle("👍🏼", forState: UIControlState.Normal)
                case 2:
                    status2.setTitle("👍🏼", forState: UIControlState.Normal)
                case 3:
                    status3.setTitle("👍🏼", forState: UIControlState.Normal)
                case 4:
                    status4.setTitle("👍🏼", forState: UIControlState.Normal)
                case 5:
                    status5.setTitle("👍🏼", forState: UIControlState.Normal)
                case 6:
                    status6.setTitle("👍🏼", forState: UIControlState.Normal)
                default: break
                }
            }
        }
    }
    
    @IBOutlet weak var leadingFirst: NSLayoutConstraint!
    @IBOutlet weak var leadingSecond: NSLayoutConstraint!
    @IBOutlet weak var leadingThird: NSLayoutConstraint!
    @IBOutlet weak var leadingFourth: NSLayoutConstraint!
    @IBOutlet weak var leadingFifth: NSLayoutConstraint!
    @IBOutlet weak var leadingSixth: NSLayoutConstraint!
    // Sets up the first person to go and the first thing to see
    func setupGame(category: String) {
        
        
        ModelInterface.sharedInstance.readRoom(roomName!, completion: { room -> Void in
            //            self.players = room["scores"] as? [String: [String]]
            self.players = room["players"] as? [String]
            self.ready = room["ready"] as? [String]
            self.setupLabels()
            let done = room["done"] as! [String: AnyObject]
            self.doneMovies = done["movies"] as? [Int]
            self.doneTV = done["tv"] as? [Int]
            self.doneFamous = done["famous"] as? [Int]
            self.doneCelebs = done["celebs"] as? [Int]
            
            if self.players!.count > 1 {
                if self.players![1] == myName {
                    isLeader = true
                    if self.timerRunning == false {
                        self.startButton.hidden = false
                        self.startButton.alpha = 0.5
                    }
                }
            }
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            if screenWidth == 414 {
                self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                self.scroller.showsHorizontalScrollIndicator = false
                self.scroller.scrollEnabled = false
                self.leadingFirst.constant = 8
                self.leadingSecond.constant = 13
                self.leadingThird.constant = 13
                self.leadingFourth.constant = 13
                self.leadingFifth.constant = 13
                self.leadingSixth.constant = 13
                self.updateViewConstraints()
            } else if screenWidth == 375 {
                self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                self.scroller.showsHorizontalScrollIndicator = false
                self.scroller.scrollEnabled = false
            } else if screenWidth < 375 {
                if self.players!.count <= 5 {
                    self.scroller.contentSize = CGSizeMake(screenWidth, 180)
                    self.scroller.showsHorizontalScrollIndicator = false
                    self.scroller.scrollEnabled = false
                } else if self.players!.count > 5 {
                    self.scroller.contentSize = CGSizeMake(screenWidth * 1.18, 180)
                    self.scroller.showsHorizontalScrollIndicator = true
                    self.scroller.scrollEnabled = true
                }
            }
            
            var startTime = room["startTime"] as? Int
            
            if self.players!.count == self.ready!.count {
                self.canStart = true
                if self.timerRunning == false && self.categorySelected == true {
                    self.startButton.alpha = 1
                }
            } else {
                self.canStart = false
                if self.timerRunning == false {
                    self.startButton.alpha = 0.5
                }
                self.invalidateTimer()
                startTime = 0
            }
            
            
            
            let currentTime = Int(NSDate().timeIntervalSince1970)
            if startTime >= currentTime {
                countDownTime = startTime! - currentTime
                if isLeader == false {
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(LobbyViewController.updateCountdown), userInfo: nil, repeats: true)
                    self.countdownView.hidden = false
                    self.timerLabel.text = "\(countDownTime)"
                }
            } else {
                self.invalidateTimer()
            }
            
        })
        
        ModelInterface.sharedInstance.fetchLists( { modules -> Void in
            self.modules = modules
            for (name, _) in modules {
                if name != "capfill" {
                    if !self.items.contains(name) {
                        self.items.insert(name, atIndex: 1)
                        let list = modules[name] as! [String: AnyObject]
                        let image = list["icon"] as! String
                        self.itemsImage.insert(image, atIndex: 1)
                        self.collectionView.reloadData()
                    }
                }
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieSegue" {
            let game = segue.destinationViewController as! GameViewController
            game.roomName = roomName
            switch category! {
            case "movies":
                game.movies = movies
            case "celebs":
                game.movies = celebs
            case "famous":
                game.movies = famous
            case "tv":
                game.movies = tv
            default:
                break
            }
            game.category = category
            if isLeader == true {
                game.firstMovie = self.rand
            }
        } else if segue.identifier == "newListSegue" {
            let newList = segue.destinationViewController as! NewListViewController
            newList.players = players
        } else if segue.identifier == "buildListSegue" {
            let buildList = segue.destinationViewController as! BuildListViewController
            buildList.module = selectedModule
            buildList.moduleName = selectedName
        } else if segue.identifier == "selectListSegue" {
            let selectList = segue.destinationViewController as! SelectListViewController
            selectList.module = selectedModule
            selectList.moduleName = selectedName
        }
        
    }
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items = ["add"]
    var itemsImage = ["Add"]
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.name.text = self.items[indexPath.item]
        cell.image.image = UIImage(named: self.itemsImage[indexPath.item])
        cell.backgroundColor = UIColor.clearColor() // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        if items[indexPath.item] == "add" {
            performSegueWithIdentifier("newListSegue", sender: nil)
        } else {
            selectedName = items[indexPath.item]
            selectedModule = modules!["\(items[indexPath.item])"]
            let currentAuthors = selectedModule!["author"] as! [String]
            if currentAuthors.contains(myName) {
                performSegueWithIdentifier("buildListSegue", sender: nil)
            } else {
                performSegueWithIdentifier("selectListSegue", sender: nil)
            }
            
            
        }
    }
}
