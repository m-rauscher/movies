//
//  SearchViewController.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//

import UIKit

protocol SearchDelegate: UIViewController {
    func updateView()
}

class SearchViewController: UIViewController, DetailDelegate {
    
    @IBOutlet weak var ratingCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchTableView: PlaceholderTableView!
    @IBOutlet weak var searchBarView: UIView!
    
    weak var delegate: SearchDelegate?
    
     var filteredFilms : [Film] = []
     var searchString = "search for movies"
     var selectedIndex = IndexPath(row: -1, section: 0)
     var ratingSelected = [false,false,false,false,false]
     var indexesToRedraw : [IndexPath] = []
 
    let ALL_FILMS = "allFilms"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpRatingCollectionView()
        setUpSearchTableView()
        setUpSearchBar()
        setUpData()
        setUpSearchTextField(string: searchString)

    }
    
    func setUpData(){
        if searchString == "Search all favorites"{
            filteredFilms = FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                film.favorite ?? false
            })
        }
        else{
            filteredFilms = FilmDefaults.loadFilms(key: ALL_FILMS)
        }
    }
    
    func setUpRatingCollectionView(){
        ratingCollectionView.delegate = self
        ratingCollectionView.dataSource = self
        ratingCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    }
    func setUpSearchTableView(){
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.showsVerticalScrollIndicator = false
        searchTableView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        
        NSLayoutConstraint.activate([searchTableView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10)])
        
    }
    
    func setUpSearchTextField(string: String){
        searchTextField.delegate = self
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.4)])
    }
    
    func setUpSearchBar(){
        searchBarView.layer.borderWidth = 1
        searchBarView.layer.borderColor = UIColor.black.cgColor
        searchBarView.layer.cornerRadius = 12
        searchBarView.dropShadow(color: UIColor.black, opacity: 0.5, offSet: CGSize(width: 0, height: 3), radius: 15)
    }
    
    func updateView() {
        searchString = UserDefaults.standard.string(forKey: "search") ?? "search for movies"
        setUpSearchTextField(string: searchString)
        setUpData()
        searchTableView.reloadData()
        ratingCollectionView.reloadData()
        textFieldDidChangeSelection(searchTextField)
    }
    
    func updateRatingImage(image: UIImageView, indexPath: IndexPath) -> UIImageView{
        if selectedIndex == indexPath {
        //rating selected
            if !ratingSelected[indexPath.item]{
                image.tintColor = UIColor(red: 0.992, green: 0.62, blue: 0.008, alpha: 1)
                ratingSelected[indexPath.item] = true
                filteredFilms.removeAll()
                filteredFilms = FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                    return Int(film.rating + 0.5) == (5 - indexPath.item)
                })
            }
        //rating deselected again --> show all films
            else{
                image.tintColor = UIColor.white
                ratingSelected[indexPath.item] = false
                if indexesToRedraw.count > 1 {
                    indexesToRedraw.removeFirst()
                }
                filteredFilms = FilmDefaults.loadFilms(key: ALL_FILMS)
            }
        }
        else{
            image.tintColor = UIColor.white
            ratingSelected[indexPath.item] = false
            if indexesToRedraw.count > 1 {
                indexesToRedraw.removeFirst()
            }
        }
        return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchDetailSegue" {
            if let indexPath = searchTableView.indexPathForSelectedRow{
                let controller = segue.destination as! DetailFilmViewController
                controller.film = filteredFilms[indexPath.row]
                controller.delegate = self
                UserDefaults.standard.set(searchString, forKey: "search")
            }
        }
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        delegate?.updateView()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteFlagPressed(_ sender: UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: searchTableView)

        if let indexPath = searchTableView.indexPathForRow(at: buttonPostion) {
            let film = filteredFilms[indexPath.row]
            FilmDefaults.updateFilms(with: film, key: ALL_FILMS, favorite: !(film.favorite ?? false))
            filteredFilms = FilmDefaults.loadFilms(key: ALL_FILMS).filter({ filteredFilms.contains($0)})
            searchTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
        }
    }
    
}

// MARK: - TableViewController

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredFilms.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "allMoviesSearchCell", for: indexPath) as! FilmTableSearchCell
            cell.setUpView(film: filteredFilms[indexPath.row])
            if indexPath.row == filteredFilms.count {
                cell.linie.image = UIImage()
            }
            return cell
        }
}

// MARK: - CollectionViewController
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ratingCell", for: indexPath) as! RatingSearchCell
        cell.setUpView(starsCount: 5-indexPath.item)
        cell.ratingImg = updateRatingImage(image: cell.ratingImg, indexPath: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = Int(UIImage(named: "searchStar" + String(5-indexPath.row))?.size.width ?? 0) + 32
        return CGSize(width: cellWidth, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        indexesToRedraw.append(indexPath)
        selectedIndex = indexPath
        collectionView.reloadItems(at: indexesToRedraw)
        searchTableView.reloadData()
        setUpSearchTextField(string: "search for movies")
    }
}

//MARK: - UITextField
extension SearchViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (searchTextField.text?.count)! != 0 {
            filteredFilms.removeAll()
            for film in FilmDefaults.loadFilms(key: ALL_FILMS) {
                let range = film.title.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil {
                    filteredFilms.append(film)
                }
            }
        }
        else{
            filteredFilms = FilmDefaults.loadFilms(key: ALL_FILMS)
            setUpSearchTextField(string: "search for movies")
        }
        
        searchTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return false
    }
}
