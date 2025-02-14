import UIKit

class MusicSegmentVC: UIViewController {

    private let segmentView = MusicSegmentView()
    private var segmentIndexNum: Int = 0

    override func loadView() {
        self.view = segmentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentActions()
        setupInitialView()
    }

    private func setupSegmentActions() {
        segmentView.tabBar.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }

    private func setupInitialView() {
        segmentView.nextTrackCollectionView.isHidden = false
        segmentView.lyricsCollectionView.isHidden = false
        segmentView.recommendAlbumCollectionView.isHidden = false
    }
    @objc private func segmentChanged() {
        segmentIndexNum = segmentView.tabBar.selectedSegmentIndex
        let underbarWidth = segmentView.tabBar.frame.width / 3
        let newLeading = CGFloat(segmentIndexNum) * underbarWidth
        
        
        // 언더바 이동 애니메이션
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.segmentView.selectedUnderbar.snp.updateConstraints {
                $0.leading.equalTo(self.segmentView.tabBar.snp.leading).offset(newLeading)
                $0.width.equalTo(underbarWidth)
            }
            print(self.segmentIndexNum)
            self.segmentView.layoutIfNeeded()
        })
        setupInitialView()
        showCollectionView(for: segmentIndexNum)
    }
    private func showCollectionView(for index: Int) {
           switch index {
           case 0:
               segmentView.nextTrackCollectionView.isHidden = false
           case 1:
               segmentView.lyricsCollectionView.isHidden = false
           case 2:
               segmentView.recommendAlbumCollectionView.isHidden = false
           default:
               break
           }
           segmentView.layoutIfNeeded()
       }

//    @objc private func segmentChanged(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            segmentView.nextTrackCollectionView.isHidden = false
//            segmentView.lyricsCollectionView.isHidden = true
//            segmentView.recommendAlbumLabel.isHidden = true
//            segmentView.recommendAlbumCollectionView.isHidden = true
//        case 1:
//            segmentView.nextTrackCollectionView.isHidden = true
//            segmentView.lyricsCollectionView.isHidden = false
//            segmentView.recommendAlbumLabel.isHidden = true
//            segmentView.recommendAlbumCollectionView.isHidden = true
//        case 2:
//            segmentView.nextTrackCollectionView.isHidden = true
//            segmentView.lyricsCollectionView.isHidden = true
//            segmentView.recommendAlbumLabel.isHidden = false
//            segmentView.recommendAlbumCollectionView.isHidden = false
//        default:
//            break
//        }
//    }
}

