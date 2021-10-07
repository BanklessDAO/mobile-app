//
//  Created with ♥ by BanklessDAO contributors on 2021-10-06.
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


import Foundation
import UIKit
import Cartography

class AutoWidthLabel: UILabel {
	// MARK: - Properties -
	
	var horizontalPadding: CGFloat = 0 {
		didSet {
			autoSize()
		}
	}
	
	private(set) var naturalSize: CGSize = .init()
	private var sizeConstraints: ConstraintGroup = .init()
	
	// MARK: - Initializers -
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Setters -
	
	override var text: String? {
		set {
			super.text = newValue
			autoSize()
		}
		
		get {
			return super.text
		}
	}
	
	override var attributedText: NSAttributedString? {
		set {
			super.attributedText = newValue
			autoSize()
		}
		
		get {
			return super.attributedText
		}
	}
	
	// MARK: - Life cycle -
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	// MARK: - Setup -
	
	func setUp() {
		setUpAppearance()
		resetConstraints()
	}
	
	// MARK: - Appearance -
	
	private func setUpAppearance() {
		numberOfLines = 0
		textAlignment = .center
		layer.masksToBounds = true
	}
	
	private func autoSize() {
		let sizeToFit = sizeThatFits(
			.init(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
		)
		naturalSize = .init(width: sizeToFit.width + horizontalPadding, height: sizeToFit.height)
		resetConstraints()
	}
	
	// MARK: - Constraints -
	
	private func resetConstraints() {
		constrain(self, replace: sizeConstraints) { tag in
			tag.width == naturalSize.width
		}
	}
}
