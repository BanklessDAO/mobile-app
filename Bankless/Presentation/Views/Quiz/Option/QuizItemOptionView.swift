//
//  Created with ♥ by BanklessDAO contributors on 2021-11-23.
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

class QuizItemOptionView: UIView {
    // MARK: - Properties -
    
    private var state: State!
    private let title: String
    
    let onPicked: () -> Void
    
    // MARK: - Subviews -
    
    private var titleLabel: UILabel!
    private var pickButton: UIButton!
    
    // MARK: - Initializers -
    
    required init(title: String, onPicked: @escaping () -> Void) {
        self.title = title
        self.onPicked = onPicked
        
        super.init(frame: .zero)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup -
    
    private func setUp() {
        layer.cornerRadius = Appearance.cornerRadius
        
        setUpSubviews()
        setUpConstraints()
        set(state: .neutral, animated: false)
    }
    
    private func setUpSubviews() {
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .secondaryWhite
        titleLabel.font = Appearance.Text.Font.Body.font(bold: false)
        addSubview(titleLabel)
        
        pickButton = UIButton(type: .custom)
        pickButton.addTarget(self, action: #selector(pickButtonTapped), for: .touchUpInside)
        addSubview(pickButton)
    }
    
    private func setUpConstraints() {
        constrain(titleLabel, self) { title, view in
            title.top == view.top + Appearance.contentInsets.top * 2
            title.bottom == view.bottom - Appearance.contentInsets.bottom * 2
            title.left == view.left + Appearance.contentInsets.left * 2
            title.right == view.right - Appearance.contentInsets.right * 2
        }
        
        constrain(pickButton, self) { button, view in
            button.edges == view.edges
        }
    }
    
    // MARK: - Transitions -
    
    func set(state: State, animated isAnimated: Bool, completion: @escaping () -> Void = {}) {
        switch state {
            
        case .neutral:
            backgroundColor = .backgroundGrey.withAlphaComponent(0.7)
            completion()
        case .invalid:
            let colorChain: [UIColor] = [
                .actionRed,
                .backgroundGrey.withAlphaComponent(0.7),
            ]
            
            for (i, color) in colorChain.enumerated() {
                UIView.animate(
                    withDuration: 0.25,
                    delay: Double(i) * 0.25,
                    options: [],
                    animations: { [weak self] in
                        self?.backgroundColor = color
                    },
                    completion: { [weak self] _ in
                        if (i + 1) == colorChain.count {
                            self?.set(state: .neutral, animated: false, completion: completion)
                        }
                    }
                )
            }
        case .valid:
            let colorChain: [UIColor] = [
                .actionGreen.withAlphaComponent(0.75),
            ]
            
            for (i, color) in colorChain.enumerated() {
                UIView.animate(
                    withDuration: 0.25,
                    delay: Double(i) * 0.25,
                    options: [],
                    animations: { [weak self] in
                        self?.backgroundColor = color
                    },
                    completion: { _ in
                        if (i + 1) == colorChain.count { completion() }
                    }
                )
            }
        }
    }
    
    // MARK: - Actions -
    
    @objc private func pickButtonTapped() {
        onPicked()
    }
}

extension QuizItemOptionView {
    enum State {
        case neutral
        case invalid
        case valid
    }
}
