//
//  DetailViewController.swift
//  Archive
//
//  Created by 이수현 on 1/14/25.
//

import UIKit

class DetailViewController: UIViewController {
    private let section : Section
    private lazy var detailView = DetailView(section: section)
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let musicData = MusicDummyModel.dummy()
    
    init(section: Section){
        self.section = section
        super.init(nibName: nil, bundle: nil)
        
        self.view = detailView
        setDataSource()
        setSnapshot()
        setAction()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setAction() {
        detailView.navigationBarView.popButton.addTarget(self, action: #selector(touchUpInsidePopButton), for: .touchUpInside)
    }
    
    @objc private func touchUpInsidePopButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: detailView.collectionView, cellProvider: {collectionView, indexPath, itemIdentifier in
            
            switch itemIdentifier {
            case .FastSelectionItem(let data), .RecentlyListendMusicItem(let data):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.config(data: data)
                return cell
            default:
                return UICollectionViewCell()
            }
            
        })
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([section])
        var sectionData : [Item]?
        
        switch section {
        case .Banner:
            sectionData = musicData.map{Item.FastSelectionItem($0)}
            
        case .Vertical:
            sectionData = musicData.map{Item.RecommendMusicItem($0)}
        default:
            return
        }
        guard let sectionData = sectionData else {return}
        snapshot.appendItems(sectionData, toSection: section)
        self.dataSource?.apply(snapshot)
    }
}
