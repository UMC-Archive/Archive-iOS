//
//  ArtistViewController.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class ArtistViewController: UIViewController {
    private let artistView = ArtistView()
    private let artistData = ArtistDummyModel.dummy()
    private let gradientLayer = CAGradientLayer()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = artistView
        setGradient()
        setAction()
        setDataSource()
        setSnapshot()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: artistView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .ArtistPopularMusic(let item):     // 아티스트 인기곡
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VerticalCell.id, for: indexPath)
                (cell as? VerticalCell)?.config(data: item)
                return cell
            case .SameArtistAnotherAlbum(let item): // 앨범 둘러보기
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.id, for: indexPath)
                (cell as? BannerCell)?.configAlbum(data: item)
                return cell
            case .MusicVideo(let item):  // 아티스트 뮤직 비디오
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicVideoCell.id, for: indexPath)
                (cell as? MusicVideoCell)?.config(data: item)
                return cell
            case .SimilarArtist(let item):  // 비슷한 아티스트
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CircleCell.id, for: indexPath)
                (cell as? CircleCell)?.config(data: item)
                return cell
            default:
                return UICollectionViewCell()
            }
        })
        
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
            case .Vertical(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .MusicVideoCell(let headerTitle):
                (headerView as? HeaderView)?.config(headerTitle: headerTitle)
            case .Circle(let headerTitle):
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
        let popularMusicSection = Section.Vertical(.ArtistPopularMusic) // 아티스트 인기곡
        let sameArtistAnotherAlbumSection = Section.Banner(.SameArtistAnotherAlbum) // 앨범 둘러보기
        let musicVideoSection = Section.MusicVideoCell(.MusicVideo) // 뮤직 비디오
        let similarArtistSection = Section.Circle(.SimilarArtist)   // 다른 비슷한 아티스트
        
        snapshot.appendSections([popularMusicSection, sameArtistAnotherAlbumSection, musicVideoSection, similarArtistSection])
        
        let popularMusicItem = artistData.popularMusicList.map{Item.ArtistPopularMusic($0)}
        snapshot.appendItems(popularMusicItem, toSection: popularMusicSection)
        
        let anotherAlbumItem = artistData.albumList.map{Item.SameArtistAnotherAlbum($0)}
        snapshot.appendItems(anotherAlbumItem, toSection: sameArtistAnotherAlbumSection)
        
        let musicVideoItem = artistData.musicVideoList.map{Item.MusicVideo($0)}
        snapshot.appendItems(musicVideoItem, toSection: musicVideoSection)
        
        let similarArtistItem = artistData.similarArtist.map{Item.SimilarArtist($0)}
        snapshot.appendItems(similarArtistItem, toSection: similarArtistSection)
        
        dataSource?.apply(snapshot)
    }
    
    
    private func setAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleLabelLines))
        artistView.descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleLabelLines() {
        // numberOfLines 토글
        let newNumberOfLines = artistView.descriptionLabel.numberOfLines == 0 ? 3 : 0

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.artistView.descriptionLabel.numberOfLines = newNumberOfLines
            self?.artistView.layoutIfNeeded() // 애니메이션 반영
        }
    }
    
    public func setGradient() {
        print("Gradient View Bounds (after layout):", artistView.gradientView.bounds)
        gradientLayer.frame = artistView.gradientView.bounds
        gradientLayer.colors = [
            UIColor.clear,
            UIColor.black_100?.withAlphaComponent(0.15) ?? UIColor.red,
            UIColor.black_100?.withAlphaComponent(0.8117) ?? UIColor.red,
            UIColor.black_100 ?? UIColor.red,
        ]
        artistView.gradientView.layer.addSublayer(gradientLayer)
//        artistView.layoutIfNeeded()
    }
}
