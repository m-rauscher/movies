//
//  HomeViewController.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//


import UIKit

class HomeViewController: UIViewController, DetailDelegate, SearchDelegate{
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    weak var background: UIImageView!
    
    private let ALL_FILMS = "allFilms"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerUserDefaults()
        setUpHomeCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func updateView(){
        homeCollectionView.reloadData()
    }
    
    func registerUserDefaults(){
        let allFilms = FilmLoader(ressource: "movies").filmData
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(allFilms) {
            defaults.register(
                defaults: [
                    ALL_FILMS: encoded
                ]
            )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoritesDetailSegue" {
            if let indexPath = homeCollectionView.indexPathsForSelectedItems?.first{
                    let controller = segue.destination as! DetailFilmViewController
                controller.film = FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                    film.favorite ?? false
                })[indexPath.item]
                controller.delegate = self
            }
        }
        if segue.identifier == "searchSegue"{
            let controller = segue.destination as! SearchViewController
            controller.delegate = self
        }
        if segue.identifier == "allFavoritesSegue" {
            let controller = segue.destination as! SearchViewController
            controller.searchString = "Search all favorites"
            controller.delegate = self
        }
        if segue.identifier == "picksDetailSegue" {
            if let indexPath = homeCollectionView.indexPathsForSelectedItems?.first{
                    let controller = segue.destination as! DetailFilmViewController
                controller.film = FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                    return film.picked ?? false
                })[indexPath.item]
                controller.delegate = self
            }
        }
    }
    
    func setUpHomeCollectionView(){
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.showsHorizontalScrollIndicator  = false
        homeCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        homeCollectionView.collectionViewLayout = createLayout()

        let imageView = UIImageView(image: UIImage(named: "Background"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        homeCollectionView.insertSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: homeCollectionView.topAnchor, constant: 268),
            imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
        background = imageView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let view = background {
            homeCollectionView.sendSubviewToBack(view)
        }
    }
    
    @IBAction func favoriteFlagPressed(_ sender: UIButton) {
        let buttonPostion = sender.convert(sender.bounds.origin, to: homeCollectionView)

        if let indexPath = homeCollectionView.indexPathForItem(at: buttonPostion) {
            let film = FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                return film.picked ?? false
            })[indexPath.item]
            FilmDefaults.updateFilms(with: film, key: ALL_FILMS, favorite: !(film.favorite ?? false))
            homeCollectionView.reloadSections(IndexSet.init(integer: 1))
        }
    }
}

//MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return min(FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                film.favorite ?? false
            }).count + 1, 4)
        case 2:
            return FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                film.picked ?? false
            }).count
        default:
            fatalError("Section not defined")
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchButtonCell", for: indexPath) as! SearchButtonHomeCell
            cell.setUpView()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritesCell", for: indexPath) as! FavoritesHomeCell
            let seeAllindex = min(FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                film.favorite ?? false
            }).count, 3)
            
            if indexPath.row == seeAllindex {
                return  collectionView.dequeueReusableCell(withReuseIdentifier: "seeAllCell", for: indexPath) as! SeeAllHomeCell
            }
            else{
                cell.setUpView(film: FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                    film.favorite ?? false
                })[indexPath.item])
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "staffPicksCell", for: indexPath) as! StaffPicksHomeCell
            cell.setUpView(film: FilmDefaults.loadFilms(key: ALL_FILMS).filter({ film in
                film.picked ?? false
            })[indexPath.item])
            return cell
        default:
            fatalError("Section not defined")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "homeHeader", for: indexPath) as! HeaderHome
        
        switch indexPath.section {
        case 1:
            headerView.setUpView(section: 1)
        case 2:
            headerView.setUpView(section: 2)
        default:
            break
        }
        return headerView
    }
}

//MARK: - CollectionViewLayout

extension HomeViewController{
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in

             switch section {
             case 0:
                 return self.SearchButtonSection()
             case 1:
                 return self.FavoritesSection()
             case 2:
                 return self.StaffPicksSection()
             default:
                 fatalError("Section not defined")
             }
           }
    }
    
    func SearchButtonSection() -> NSCollectionLayoutSection {
        
        let buttonSize = CGSize(width: 48 , height: 48)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalWidth(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(buttonSize.width),
                                               heightDimension: .estimated(buttonSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 30, leading: 30, bottom: 50, trailing: 0)
        return section

    }
    
    func FavoritesSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let posterSize = CGSize(width: 180, height: 270)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(posterSize.width),
                                               heightDimension: .absolute(posterSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 30
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 21, leading: 30, bottom: 41, trailing: 0)
        return section

    }
    
    func StaffPicksSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let cellHeight = CGFloat(141)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(cellHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0)
        return section

    }
}
