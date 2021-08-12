//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class HistoryCell: UICollectionViewCell {
    @IBOutlet weak var Banner: UIView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var PlaceDesc: UILabel!
    @IBOutlet weak var PlaceTemp: UILabel!
    @IBOutlet weak var PlaceIcon: UIImageView!
    @IBOutlet weak var Graph: UIImageView!
}

class HistoryViewController: UIViewController {
    
    var viewModel = HistoryViewModel()
    
    // MARK: - Outlets
    @IBAction func ToSettingsApp(_ sender: UIBarButtonItem) {
        switchToTheSettingsApp()
    }
    
    @IBOutlet weak var HistoryCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Joke Integration
    @IBOutlet weak var JokeContainerView: UIView!
    @IBOutlet weak var JokeContainerHeight: NSLayoutConstraint!
    var JokeContainerIsExpanded:Bool = false
    
    // MARK: - Override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HistoryCollectionView.reloadData()
        HistoryCollectionView.scrollToItem(
            at: IndexPath(item: viewModel.selectedIndex, section: 0),
            at: .left,
            animated: false)
        
        // Hide the joke container
        JokeContainerIsExpanded = false
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
        HistoryCollectionView.reloadData()
    }
    
    func configureJokeContainer() {
        JokeContainerView.layer.cornerRadius = 20
        JokeContainerView.layer.masksToBounds = true
    }
}

extension HistoryViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = HistoryCollectionView.dequeueReusableCell(
            withReuseIdentifier: "HistoryCell",
            for: indexPath) as! HistoryCell
        
        cell.Banner.backgroundColor = UIColor.appHistoryBanner
        
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
        
        cell.Graph.image = viewModel.getHistoryChart(forIndex: indexPath.row,
                                                     size: cell.Graph.frame.size)
        return cell
    }
}

extension HistoryViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.superview!.frame.width
        let height = collectionView.superview!.frame.height
        
        return CGSize(width: width, height: height)
    }
}

extension HistoryViewController:UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = HistoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Calculate destination position and index
        let cellWidthPlusPadding = layout.itemSize.width + layout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthPlusPadding
        let roundedIndex = round(index)
        
        viewModel.setSelectedIndex(to: Int(roundedIndex))
    }
}

// MARK: - Refresh Protocol Extension
extension HistoryViewController:Refresh {
    
    func updateUI() {
        HistoryCollectionView.reloadData()
    }
}

// MARK: - Joke Protocol Extension
extension HistoryViewController:JokeContainerProtocol {
    
    func SetJokeContainerIsExpanded(_ trueFalse:Bool) {
        JokeContainerIsExpanded = trueFalse
    }

    func SetJokeContainerHeight(constant:Int) {
        JokeContainerHeight.constant = CGFloat(constant)
    }
}
