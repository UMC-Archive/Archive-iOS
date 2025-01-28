//
//  ArtistViewController.swift
//  Archive
//
//  Created by 이수현 on 1/19/25.
//

import UIKit

class ArtistViewController: UIViewController {
    private let musicService = MusicService() // 예시
    
    
    private let artistView = ArtistView()
    private let artistData = ArtistDummyModel.dummy()
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = artistView
        setNavigationBar()
        setAction()
        setDataSource()
        setSnapshot()
        
        postArtistInfo(artist: "IU")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
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
        let heartButton = UIBarButtonItem(image: .addLibrary, style: .done, target: self, action: #selector(tapHeartButton))
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
    
    
    // 아티스트 정보 가져오기 API
    func postArtistInfo(artist: String){
        musicService.artist(artist: artist){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("postArtistInfo 성공 : \(String(describing: response?.name))")
                Task{
//                    LoginViewController.keychain.set(response.token, forKey: "serverAccessToken")
//                    LoginViewController.keychain.set(response.nickname, forKey: "userNickname")
//                    self.goToNextView()
                }
            case .failure(let error):
                // 네트워크 연결 실패 얼럿
                let alert = NetworkAlert.shared.getAlertController(title: error.description)
                self.present(alert, animated: true)
                print("실패: \(error.description)")
            }
        }
    }

}
