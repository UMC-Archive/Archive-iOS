//
//  On_Boarding1VC.swift
//  Archive
//
//  Created by 손현빈 on 1/11/25.
//

import UIKit
import Foundation

class PreferArtistVC: UIViewController {

    lazy var preferArtistView: PreferArtistView = {
        let view = PreferArtistView()
        return view
    }()
    

      override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
          super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      }
    
    required init?(coder: NSCoder) {
          super.init(coder: coder)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = preferArtistView
        registerCells()
        setupCollectionViewDataSources()
        // Do any additional setup after loading the view.
    }
    //homeView.TopCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    
    // 더미 데이터 배열 정의 Artist
      let ArtistData: [(image: String, name: String)] = [
          ("Category_image1", "크림 드로우"),
          ("Category_image2", "실시간 차트"),
          ("Category_image3", "남성 추천"),
          ("Category_image4", "여성 추천"),
          ("Category_image5", "색다른 추천"),
          ("Category_image6", "정가 아래"),
          ("Category_image7", "윤세 24AW"),
          ("Category_image8", "올해의 베스트"),
          ("Category_image9", "10월 베네핏"),
          ("Category_image10", "아크네 선물")
      ]
    

    
    
    private func registerCells(){
        preferArtistView.ArtistCollectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.identifier)
    }
    
    // 컬렉션 뷰의 데이터 소스 및 델리게이트 설정 메서드
    private func setupCollectionViewDataSources(){
        preferArtistView.ArtistCollectionView.dataSource = self
        preferArtistView.ArtistCollectionView.delegate = self
    }
}

extension PreferArtistVC : UICollectionViewDelegate , UICollectionViewDataSource {
  
    // 섹션 내 아이템수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == preferArtistView.ArtistCollectionView {
            return ArtistData.count
        }
        return 0
    }
    
    // 셀 구성
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.identifier, for: indexPath) as? ArtistCell else {
              fatalError("Unable to dequeue ArtistCell")
          }
          let data = ArtistData[indexPath.row]
          cell.configure(imageName: data.image, name: data.name)
          return cell
      }
    // 셀 선택 시 동작
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 선택된 셀의 UI 업데이트 (테두리 추가 예시)
        if let cell = collectionView.cellForItem(at: indexPath) as? ArtistCell {
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.purple.cgColor
        }
    }
    // 셀 선택 해제 시 동작 (옵션)
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ArtistCell {
            cell.layer.borderWidth = 0
        }
    }

}

class ArtistCell : UICollectionViewCell {
    static let identifier = "ArtistCell"
    
    var ArtistImageView = UIImageView().then {make in
        make.contentMode = .scaleAspectFill }
    
    var ArtistName = UILabel().then {make in
        make.font = UIFont.systemFont(ofSize:12)
        make.textColor = .black
    }
   
    override init (frame: CGRect){
        super.init(frame: frame)
        addSubview(ArtistImageView)
        addSubview(ArtistName)
        ArtistImageView.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.height.width.equalTo(61)
        }
        ArtistName.snp.makeConstraints {make in
            make.top.equalTo(ArtistImageView.snp.bottom).offset(4)
            make.centerX.equalTo(ArtistImageView)
        }
    }
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    func configure(imageName: String, name: String ){
        ArtistImageView.image = UIImage(named: imageName)
        ArtistName.text = name
    }
}
