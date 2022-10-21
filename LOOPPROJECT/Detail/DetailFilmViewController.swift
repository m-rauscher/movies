//
//  DetailFilmViewController.swift
//  LOOPPROJECT
//
//  Created by Moritz Rauscher on 01.10.22.
//

import UIKit

protocol DetailDelegate: UIViewController {
    func updateView()    
}


class DetailFilmViewController: UIViewController {
    
    var film: Film!
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var flagButton: UIBarButtonItem!
    @IBOutlet weak var closeBUtton: UIBarButtonItem!

    weak var delegate: DetailDelegate?

    let ALL_FILMS = "allFilms"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpDetailCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FilmDefaults.updateFilms(with: film, key: ALL_FILMS, favorite: film.favorite ?? false)
        delegate?.updateView()
    }
    
    func setUpNavigationBar(){
        navigationTitle.title = film.title
        closeBUtton.image = UIImage(named: "closeDetail")?.withRenderingMode(.alwaysOriginal)
        flagButton.image = setFlagImage(state: film.favorite ?? false)
    }
    
    func setUpDetailCollectionView(){
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.collectionViewLayout = createLayout()
    }
//MARK: - NavigationBarButtons
    @IBAction func flagButtonPressed(_ sender: Any) {
        if film.favorite == false{
            film.favorite = true
            flagButton.image = setFlagImage(state: film.favorite ?? false)
        }
        else{
            film.favorite = false
            flagButton.image = setFlagImage(state: film.favorite ?? false)
        }
        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        guard let image = URL(string: film.posterUrl) else { return }
        let message = "Hey have you already seen this movie? It's one of my favorites! It's name is " + film.title
        
        let shareSheetVC = UIActivityViewController(activityItems: [image, message], applicationActivities: nil)
        present(shareSheetVC, animated: true)
        
    }
    func setFlagImage(state: Bool) -> UIImage{
        if state{
            return (UIImage(named: "FavoriteFlagSelected")?.withRenderingMode(.alwaysOriginal))!
        }
        return (UIImage(named: "FavoriteFlag")?.withRenderingMode(.alwaysOriginal))!
    }
}

//MARK: - UICollectionView
extension DetailFilmViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0...1:
            return 1
        case 2:
            return film.genres.count
        case 3...4:
            return 1
        case 5:
            return film.cast.count
        case 6:
            return 4
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "posterDetailCell", for: indexPath) as! PosterDetailCell
            cell.setUpView(film: film)
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "factsDetailCell", for: indexPath) as! FactsDetailCell
            cell.setUpView(film: film)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreDetailCell", for: indexPath) as! GenreDetailCell
            cell.setUpView(genre: film.genres[indexPath.item])
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "overviewDetailCell", for: indexPath) as! OverviewDetailCell
            cell.setUpView(text: film.overview)
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personDetailCell", for: indexPath) as! PersonDetailCell
            cell.setUpView(person: film.director)
            cell.character.isHidden = true
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "personDetailCell", for: indexPath) as! PersonDetailCell
            cell.setUpView(person: film.cast[indexPath.item])
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyFactsDetailCell", for: indexPath) as! KeyFactsDetailCell
            cell.setUpView(film: film, factNmbr: indexPath.item)
            return cell
        default:
            fatalError("Unknown Section")
        }
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as! HeaderDetail
        
        switch indexPath.section {
        case 3:
            headerView.header.text = "Overview"
        case 4:
            headerView.header.text = "Director"
        case 5:
            headerView.header.text = "Cast"
        case 6:
            headerView.header.text = "KeyFacts"
        default:
            break
        }
        return headerView
    }
}
//MARK: - CollectionViewLayout
extension DetailFilmViewController{
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, env) -> NSCollectionLayoutSection? in

             switch section {
             case 0:
                 return self.PosterLayoutSection()
             case 1:
                 return self.FactsLayoutSection()
             case 2:
                 return self.GenreLayoutSection()
             case 3:
                 return self.OverviewLayoutSection()
             case 4:
                 return self.PersonLayoutSection()
             case 5:
                 return self.PersonLayoutSection()
             case 6:
                 return self.KeyFactsLayoutSection()
             default:
                 fatalError("Section not defined")
             }
           }
    }
    
    func PosterLayoutSection() -> NSCollectionLayoutSection {
        
        let posterSize = CGSize(width: 200, height: 300)

        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(posterSize.width),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(posterSize.height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let leading = (detailCollectionView.frame.size.width - CGFloat(200))/2
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 60, leading: leading, bottom: 0, trailing: leading)
        return section
    }
    
    func FactsLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let leading = (detailCollectionView.frame.size.width * 0.1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 12, leading: leading, bottom: 0, trailing: leading)
        return section

    }
    
    func GenreLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50), heightDimension:
                .absolute(18))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        var genreItems = [NSCollectionLayoutItem]()
        var genresWidth = 0
        for i in 0..<film.genres.count{
            genreItems.append(item)
            genresWidth += getGenreLabelWidth(pos: i)
        }
        genresWidth += (film.genres.count - 1) * 6
        let leading = (detailCollectionView.frame.size.width - CGFloat(genresWidth))/2
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .estimated(18))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: genreItems)
        group.interItemSpacing = .fixed(6)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 10, leading: leading , bottom: 45, trailing: leading)
        return section
    }
    
    func getGenreLabelWidth(pos: Int) -> Int{
        //trailing = 8 and leading = 8 .constraint of textLabel in Genrecell
        //add for every char approx. 7 as the guessed char width through try and error
        return 16 + Int(Double(film.genres[pos].count) * 7)
    }
    
    func OverviewLayoutSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
        let overviewSize =  detailCollectionView.frame.size.width - 60
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(overviewSize), heightDimension:
                .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 16, leading: 30, bottom: 30, trailing: 30)
        
        return section
    }
    
    func PersonLayoutSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100),
                                               heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 16, leading: 30, bottom: 30, trailing: 0)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func KeyFactsLayoutSection() -> NSCollectionLayoutSection {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                .absolute(20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(66))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 12)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(132))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = [header]
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 16, leading: 30, bottom: 30, trailing: 30)
        return section
    }
}
