//
//  LyricsView.swift
//  Archive
//
//  Created by 손현빈 on 1/30/25.
//
import UIKit

class LyricsView: UIView {

    // 탭 바 (UISegmentedControl)
    lazy var tabBar: UISegmentedControl = {
        let items = ["다음 트랙", "가사", "추천 콘텐츠"]
        let segmentedControl = UISegmentedControl(items: items)
         segmentedControl.selectedSegmentIndex = 1 // "다음 트랙" 기본 선택

         // 배경 색상 및 선택된 색상 설정
         segmentedControl.backgroundColor = .black
         segmentedControl.selectedSegmentTintColor = .clear // 투명 배경

         // 선택된 텍스트 스타일
         segmentedControl.setTitleTextAttributes([
             .foregroundColor: UIColor.white, // 선택된 텍스트 흰색
             .font: UIFont.boldSystemFont(ofSize: 16) // 굵은 텍스트
         ], for: .selected)

         // 선택되지 않은 텍스트 스타일
         segmentedControl.setTitleTextAttributes([
             .foregroundColor: UIColor.gray, // 선택되지 않은 텍스트 회색
             .font: UIFont.systemFont(ofSize: 16) // 기본 텍스트
         ], for: .normal)

         // 경계선 제거
         segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
         segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)

         return segmentedControl
    }()

    // 가사 표시용 컬렉션 뷰 (UICollectionView)
    lazy var lyricsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 40) // 셀 크기
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(tabBar)
        addSubview(lyricsCollectionView)
    }

    private func setupConstraints() {
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        lyricsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // 탭 바 제약 조건
            tabBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 44),

            // 컬렉션 뷰 제약 조건
            lyricsCollectionView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
            lyricsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lyricsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lyricsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
