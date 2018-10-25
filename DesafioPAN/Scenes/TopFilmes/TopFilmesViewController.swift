//
//  FilmeViewController.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 20/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import UIKit

protocol TopFilmesViewControllerProtocol: class {
    func displayTopFilmes(viewModel: TopFilmes.DiscoverMovies.ViewModel)
    func displayOfflineMessage()
}

private let reuseIdentifier = "FilmeCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
private let itemsPerRow: CGFloat = 3

class TopFilmesViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTopView: UIView!
    
    var interactor: TopFilmesInteractorProtocol?
    private var viewModel: TopFilmes.DiscoverMovies.ViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var isLoadingData: Bool = false
    private let refreshControl = UIRefreshControl()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TopFilmesInteractor()
        let presenter = TopFilmesPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(FilmeCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        setupCollectionView()
    }
    
    func setupCollectionView() {
        // Add Refresh Control to Collection View
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refreshControl
        } else {
            self.collectionView.addSubview(refreshControl)
        }
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        loadTopFilmes()
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data
        self.isLoadingData = true
        let request = TopFilmes.DiscoverMovies.Request.init(isRefresh: true)
        interactor?.refreshData(request: request)
    }
    
    private func loadTopFilmes() {
        self.isLoadingData = true
        let request = TopFilmes.DiscoverMovies.Request.init(isRefresh: false)
        interactor?.fetchTopFilmes(request: request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}

extension TopFilmesViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.viewModel?.moviesCollection?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilmeCell
        
        // Configure the cell
        let filmeCollection = self.filmeForIndexPath(indexPath: indexPath)
        cell.imageView.loadImageUsingCache(withUrl: filmeCollection.imageURL)
        cell.titleLabel.text = filmeCollection.title
        
        return cell
    }
}

extension TopFilmesViewController: UICollectionViewDelegate {
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let vm = self.viewModel, let list = vm.moviesCollection {
            if indexPath.row == list.count - 2 && !isLoadingData {
                loadTopFilmes()
            }
        }
    }
}

extension TopFilmesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (150 / 100)
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension TopFilmesViewController: TopFilmesViewControllerProtocol {
    func displayTopFilmes(viewModel: TopFilmes.DiscoverMovies.ViewModel) {
        self.viewModel = viewModel
        self.isLoadingData = false
        self.messageTopView.isHidden = true
        if (viewModel.isRefresh!) {
            self.refreshControl.endRefreshing()
        }
    }
    func displayOfflineMessage() {
        self.messageTopView.isHidden = false
    }
    func filmeForIndexPath(indexPath: IndexPath) -> TopFilmes.MovieCollectionItem {
        return (viewModel?.moviesCollection?[(indexPath as IndexPath).row])!
    }
}
