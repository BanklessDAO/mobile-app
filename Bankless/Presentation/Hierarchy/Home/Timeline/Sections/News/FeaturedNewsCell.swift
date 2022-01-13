//
//  Created with ♥ by BanklessDAO contributors on 2021-10-07.
//  Copyright (C) 2021 BanklessDAO.

//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as
//  published by the Free Software Foundation, either version 3 of the
//  License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see https://www.gnu.org/licenses/.
//
    

import Cartography
import RxSwift
import RxCocoa

class FeaturedNewsCell: BaseTableViewCell<FeaturedNewsViewModel> {
    class var reuseIdentifier: String {
        return String(describing: FeaturedNewsCell.self)
    }
    
    // MARK: - Constants -
    
    private static let collectionRatio: CGSize = .init(width: 16, height: 10)
    private static let maxNumberOfCarouselItems = 3
    private static let expandButtonColor: UIColor = .primaryRed
    
    // MARK: - Properties -
    
    private let featuredNewsCollectionFlowLayout = FeaturedNewsCollectionFlowLayout()
    private let itemsSource = BehaviorRelay<[NewsItemPreviewBehaviour]>(value: [])
    private let itemSelection = PublishRelay<Int>()
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var expandButton: UIButton!
    private var collectionView: UICollectionView!
    
    // MARK: - Lifecycle -
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Setup -
    
    override func setUpSubviews() {
        backgroundColor = .backgroundBlack
        
        separatorInset = .init(
            top: 0,
            left: CGFloat.greatestFiniteMagnitude,
            bottom: 0,
            right: 0
        )
        
        titleLabel = UILabel()
        titleLabel.font = Appearance.Text.Font.Title1.font(bold: true)
        titleLabel.textColor = .secondaryWhite
        contentView.addSubview(titleLabel)
        
        expandButton = UIButton(type: .custom)
        expandButton.setTitleColor(FeaturedNewsCell.expandButtonColor, for: .normal)
        contentView.addSubview(expandButton)
        
        collectionView = UICollectionView(
            featuredNewsCollectionFlowLayout: featuredNewsCollectionFlowLayout
        )
        collectionView.backgroundColor = .backgroundBlack
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            FeaturedNewsItemCell.self,
            forCellWithReuseIdentifier: String(describing: FeaturedNewsItemCell.self)
        )
        collectionView.register(
            FeaturedNewsExpandCell.self,
            forCellWithReuseIdentifier: String(describing: FeaturedNewsExpandCell.self)
        )
        featuredNewsCollectionFlowLayout.estimatedItemSize
            = UICollectionViewFlowLayout.automaticSize
        featuredNewsCollectionFlowLayout.minimumLineSpacing = 10
        featuredNewsCollectionFlowLayout.sectionInset = .init(
            top: 0, left: 12, bottom: 0, right: 12
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
    }
    
    override func setUpConstraints() {
        constrain(titleLabel, contentView) { (title, view) in
            title.top == view.top + Appearance.contentInsets.top
            title.left == view.left + Appearance.contentInsets.left * 2
            title.height == Appearance.Text.Font.Title1.lineHeight
        }
        
        constrain(expandButton, titleLabel, contentView) { expand, title, view in
            expand.height == title.height
            expand.centerY == title.centerY
            expand.left == title.right + Appearance.contentInsets.left
            expand.right == view.right - Appearance.contentInsets.right * 2
            expand.width == 0 ~ .defaultLow
        }
        
        constrain(collectionView, titleLabel, contentView) { items, title, view in
            items.top == title.bottom + Appearance.contentPaddings.bottom
            items.left == view.left
            items.right == view.right
            items.height == view.width
                / FeaturedNewsCell.collectionRatio.width
                * FeaturedNewsCell.collectionRatio.height
            items.bottom == view.bottom - Appearance.contentInsets.bottom
        }
    }
    
    override func bindViewModel() {
        let output = viewModel.transform(
            input: .init(selection: itemSelection.asDriver(onErrorDriveWith: .empty()))
        )
        
        output.title.drive(titleLabel.rx.text).disposed(by: disposer)
        output.expandButtonTitle.drive(expandButton.rx.title(for: .normal)).disposed(by: disposer)
        output.items.drive(itemsSource).disposed(by: disposer)
        
        itemsSource.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposer)
    }
}

extension FeaturedNewsCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        itemsSource.value.prefix(FeaturedNewsCell.maxNumberOfCarouselItems).count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt
        indexPath: IndexPath
    ) -> UICollectionViewCell {
        let sourceItem = itemsSource.value[indexPath.row]
        
        guard !(sourceItem is ShowMorePlaceholderItem) else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: FeaturedNewsExpandCell.self),
                for: indexPath
            ) as! FeaturedNewsExpandCell
            
            cell.set(placeholderItem: sourceItem as! ShowMorePlaceholderItem)
            
            return cell
        }
        
        let newsItemViewModel = NewsItemViewModel(newsItem: sourceItem)
        
        let newsItemView = FeaturedNewsItemView()
        newsItemView.set(viewModel: newsItemViewModel)
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: FeaturedNewsItemCell.self),
            for: indexPath
        ) as! FeaturedNewsItemCell
        cell.set(itemView: newsItemView)
        
        return cell
    }
}

extension FeaturedNewsCell: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: false)
        itemSelection.accept(indexPath.row)
    }
}
