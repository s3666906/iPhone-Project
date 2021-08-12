//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    @IBOutlet weak var Banner: UIView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var PlaceDesc: UILabel!
    @IBOutlet weak var PlaceTemp: UILabel!
    @IBOutlet weak var PlaceIcon: UIImageView!
    @IBOutlet weak var WebcamImageView: UIImageView!
}

class TodayViewController: UIViewController, JokeContainerProtocol {
 
    var viewModel = TodayViewModel()
    
    // MARK: - Outlets
    @IBAction func ToSettingsApp(_ sender: UIBarButtonItem) {
        switchToTheSettingsApp()
    }
    
    @IBOutlet weak var TodayCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Joke Integration
    @IBOutlet weak var JokeContainerView: UIView!
    
    @IBOutlet weak var JokeContainerHeight: NSLayoutConstraint!
    var JokeContainerIsExpanded:Bool = false
    func SetJokeContainerIsExpanded(_ trueFalse:Bool) {
        JokeContainerIsExpanded = trueFalse
    }
    func SetJokeContainerHeight(constant:Int) {
        JokeContainerHeight.constant = CGFloat(constant)
    }

    // MARK: - Override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TodayCollectionView.reloadData()
        TodayCollectionView.scrollToItem(at: IndexPath(item: viewModel.selectedIndex, section: 0), at: .left, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monitorReturningFromTheSettingsApp()
        configureJokeContainer()
        navigationController?.navigationBar.tintColor = UIColor.appNavBarTint
    }
    
    func monitorReturningFromTheSettingsApp() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(willEnterForeground),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
    }
    @objc func willEnterForeground() {
        TodayCollectionView.reloadData()
    }
    
    // MARK: - Navigation
    
    func configureJokeContainer() {
        JokeContainerView.layer.cornerRadius = 20
        JokeContainerView.layer.masksToBounds = true
    }
    
}

extension TodayViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TodayCollectionView.dequeueReusableCell(
            withReuseIdentifier: "TodayCell",
            for: indexPath) as! TodayCell

        cell.Banner.backgroundColor = UIColor.appTodayBanner
        
        let place = viewModel.places[indexPath.row]
        cell.PlaceName.text = place.name
        cell.PlaceTemp.text = ""
        cell.PlaceDesc.text = ""
        cell.PlaceIcon.image = nil
        if let weather = place.weather {
            cell.PlaceTemp.text = convertToUserUnits(celsiusValue: weather.temp)
            cell.PlaceDesc.text = weather.desc
            cell.PlaceIcon.image = UIImage(named: weather.icon ?? "unknown")
        }
        
        if let url = URL(string: place.webcam!.url!) {
            if let data = try? Data(contentsOf: url) {
                cell.WebcamImageView.image = UIImage(data: data)
            }
        }
        
        return cell
    }
}
extension TodayViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.superview!.frame.width
        let height = collectionView.superview!.frame.height
        
        return CGSize(width: width, height: height)
    }
}

extension TodayViewController:UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = TodayCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Calculate destination position and index
        let cellWidthPlusPadding = layout.itemSize.width + layout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthPlusPadding
        let roundedIndex = round(index)
        
        viewModel.setSelectedIndex(to: Int(roundedIndex))
    }

}
