//
//  AlbumViewController.swift
//  Archive
//
//  Created by 이수현 on 1/15/25.
//

import UIKit

class AlbumViewController: UIViewController {
    private let albumView = AlbumView()
    private let data = AlbumCurationDummyModel.dummy()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = albumView
        
        albumView.config(data: data)
        setNavigationBar()
        setDataSource()
        setSnapshot()
        setProtocol()
        updateTrackViewHeight()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        // 뒤로 가기
        let popButton = UIBarButtonItem(image: .init(systemName: "chevron.left"), style: .plain, target: self, action: #selector(tapPopButton))
        self.navigationItem.leftBarButtonItem = popButton
        
        // 좋이요
        let heartButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(tapHeartButton))
        self.navigationItem.rightBarButtonItem = heartButton
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func tapPopButton() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tapHeartButton() {
        // 좋아요 API 연결
        print("tapHeartButton")
    }
    
    private func updateTrackViewHeight(){
        albumView.trackView.snp.updateConstraints { make in
            make.height.equalTo(180 + data.albumTrack.count * 60)
        }
        
        albumView.layoutIfNeeded()
    }
    
    private func setProtocol() {
        albumView.trackView.trackCollectionView.dataSource = self
        albumView.trackView.trackCollectionView.delegate = self
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: albumView.collectionView){ collectionView, indexPath, ItemIdentifier in
            switch ItemIdentifier {
            case .AnotherAlbum(let item), .RecommendAlbum(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAlbum(data: item)
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        dataSource?.supplementaryViewProvider = {[weak self] collectionView, kind, indexPath in
            guard let self = self else {return UICollectionReusableView() }
            let section = self.dataSource?.sectionIdentifier(for: indexPath.section)
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.id, for: indexPath)
            // 버튼에 UIAction 추가
            (headerView as? HeaderView)?.detailButton.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self, let section = section else { return }
                self.handleDetailButtonTap(for: section)
            }), for: .touchUpInside)

            switch section {
            case .Banner(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        }
        
    }
    
    private func handleDetailButtonTap(for section: Section) {
        let nextVC = DetailViewController(section: section)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func setSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        
        let anotherAlbumSection = Section.Banner(.AnotherAlbum) // 이 아티스트의 다른 앨범
        let recommendAlbumSection = Section.Banner(.RecommendAlbum) // 당신을 위한 추천 핼범
        
        snapshot.appendSections([anotherAlbumSection, recommendAlbumSection])
        
        let anotherAlbumItem = data.anotherAlbum.map{Item.AnotherAlbum($0)}
        let recommendAlbumItem = data.recommendAlbum.map{Item.RecommendAlbum($0)}
        
        snapshot.appendItems(anotherAlbumItem, toSection: anotherAlbumSection)
        snapshot.appendItems(recommendAlbumItem, toSection: recommendAlbumSection)
        
        dataSource?.apply(snapshot)
    }
}

extension AlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case albumView.trackView.trackCollectionView:
            return data.albumTrack.musicList.count
        default:
            return data.albumTrack.musicList.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt")
        switch collectionView {
        case albumView.trackView.trackCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath) as? VerticalCell else {return UICollectionViewCell()
            }
            cell.config(data: data.albumTrack.musicList[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

extension AlbumViewController: UICollectionViewDelegate { }
