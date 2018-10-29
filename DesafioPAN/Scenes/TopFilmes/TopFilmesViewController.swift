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
    func hideOfflineMessage()
    func endRefreshData()
}

private let reuseIdentifier = "FilmeCell"
private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
private let minItemsPerRow: Int = 3
private let defaultCellSize: CGSize = CGSize(width: 100, height: 150)

class TopFilmesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTopView: UIView!
    @IBOutlet weak var searchInput: UITextField!
    
    var interactor: TopFilmesInteractorProtocol?
    private var viewModel: TopFilmes.DiscoverMovies.ViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private var selectedFilme: TopFilmes.MovieCollectionItem?
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
        self.title = "Top Filmes"
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
        self.searchInput.text = ""
        interactor?.refreshData()
    }
    
    private func loadTopFilmes() {
        interactor?.fetchTopFilmes()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let detalheViewController: DetalheFilmeViewController = segue.destination as! DetalheFilmeViewController
        if let filme = self.selectedFilme {
            detalheViewController.setupDetalheFilme(filme: filme)
        }
    }
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
        cell.imageView.loadImageUsingCache(withUrl: filmeCollection.imageThumbURL)
        cell.titleLabel.text = filmeCollection.title
        
        return cell
    }
    
    private func filmeForIndexPath(indexPath: IndexPath) -> TopFilmes.MovieCollectionItem {
        return (viewModel?.moviesCollection?[(indexPath as IndexPath).row])!
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
            if indexPath.row == list.count - 2 {
                loadTopFilmes()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFilme = filmeForIndexPath(indexPath: indexPath)
        self.performSegue(withIdentifier: "DetalheFilme", sender: self)
    }
}

extension TopFilmesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let guide = view.safeAreaLayoutGuide
        let contentWidth = guide.layoutFrame.size.width
        let paddingSpace = sectionInsets.left * CGFloat(minItemsPerRow + 1)
        let availableWidth = contentWidth - paddingSpace
        var numItemsPerRow = Int(availableWidth / defaultCellSize.width)
        if (numItemsPerRow < minItemsPerRow) {
            numItemsPerRow = minItemsPerRow
        }
        
        let widthPerItem = CGFloat(Int(availableWidth / CGFloat(numItemsPerRow)))
        let heightPerItem = widthPerItem * (defaultCellSize.height / defaultCellSize.width)
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension TopFilmesViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text == "Buscar") {
            textField.text = ""
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            let request = TopFilmes.DiscoverMovies.Request.init(searchString: searchText)
            interactor?.searchFilmes(request: request)
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            let request = TopFilmes.DiscoverMovies.Request.init(searchString: updatedText)
            interactor?.searchFilmes(request: request)
        }
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        interactor?.endSearch()
        return true
    }
}

extension TopFilmesViewController: TopFilmesViewControllerProtocol {
    func displayTopFilmes(viewModel: TopFilmes.DiscoverMovies.ViewModel) {
        self.viewModel = viewModel
    }
    func displayOfflineMessage() {
        self.messageTopView.isHidden = false
    }
    func hideOfflineMessage() {
        self.messageTopView.isHidden = true
    }
    func endRefreshData() {
        self.refreshControl.endRefreshing()
    }
}
