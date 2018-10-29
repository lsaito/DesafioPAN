//
//  DetalheFilmeViewController.swift
//  DesafioPAN
//
//  Created by Lucas Saito on 29/10/2018.
//  Copyright © 2018 Otias. All rights reserved.
//

import UIKit

class DetalheFilmeViewController: UIViewController {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var imagemView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var filme: TopFilmes.MovieCollectionItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Detalhe"
        setupDetalheFilmeViewController()
    }
    
    func setupDetalheFilmeViewController() {
        self.tituloLabel.text = filme.title
        self.imagemView.loadImageUsingCache(withUrl: filme.imageDetalheURL)
        self.overviewLabel.text = filme.overview
    }
    
    func setupDetalheFilme(filme: TopFilmes.MovieCollectionItem) {
        self.filme = filme
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
