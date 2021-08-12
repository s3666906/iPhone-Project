//
//  FunnyWeather
//  Copyright © 2020 RMIT iPhone Software Engineering Group 1. All rights reserved.
//

import UIKit

class ForecastCell: UICollectionViewCell {
    @IBOutlet weak var Banner: UIView!
    @IBOutlet weak var PlaceName: UILabel!
    @IBOutlet weak var PlaceDesc: UILabel!
    @IBOutlet weak var PlaceTemp: UILabel!
    @IBOutlet weak var PlaceIcon: UIImageView!
    @IBOutlet weak var Graph: UIImageView!
}

class ForecastViewController: UIViewController {
    
    var viewModel = ForecastViewModel()
    
    // MARK: - Outlets
    @IBAction func ToSettingsApp(_ sender: UIBarButtonItem) {
        switchToTheSettingsApp()
    }
    
    @IBOutlet weak var ForecastCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Joke Integration
    @IBOutlet weak var JokeContainerView: UIView!
    @IBOutlet weak var JokeContainerHeight: NSLayoutConstraint!
    var JokeContainerIsExpanded:Bool = false
    
    // MARK: - Override functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ForecastCollectionView.reloadData()
        ForecastCollectionView.scrollToItem(
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
        ForecastCollectionView.reloadData()
    }
    
    func configureJokeContainer() {
        JokeContainerView.layer.cornerRadius = 20
        JokeContainerView.layer.masksToBounds = true
    }
}

extension ForecastViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.places.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = ForecastCollectionView.dequeueReusableCell(
            withReuseIdentifier: "ForecastCell",
            for: indexPath) as! ForecastCell
        
        cell.Banner.backgroundColor = UIColor.appForecastBanner
        
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
        
        cell.Graph.image = viewModel.getForecastChart(forIndex: indexPath.row,
                                                      size: cell.Graph.frame.size)
        return cell
    }
}

extension ForecastViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.superview!.frame.width
        let height = collectionView.superview!.frame.height
        
        return CGSize(width: width, height: height)
    }
}

extension ForecastViewController:UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = ForecastCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        // Calculate destination position and index
        let cellWidthPlusPadding = layout.itemSize.width + layout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthPlusPadding
        let roundedIndex = round(index)
        
        viewModel.setSelectedIndex(to: Int(roundedIndex))
    }
}

// MARK: - Refresh Protocol Extension
extension ForecastViewController:Refresh {
    
    func updateUI() {
        ForecastCollectionView.reloadData()
    }
}

// MARK: - Joke Protocol Extension
extension ForecastViewController:JokeContainerProtocol {
    
    func SetJokeContainerIsExpanded(_ trueFalse:Bool) {
        JokeContainerIsExpanded = trueFalse
    }
    
    func SetJokeContainerHeight(constant:Int) {
        JokeContainerHeight.constant = CGFloat(constant)
    }
}
