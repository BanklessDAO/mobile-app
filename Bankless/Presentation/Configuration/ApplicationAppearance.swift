//
//  Created with ♥ by BanklessDAO contributors on 2021-09-30.
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

typealias Appearance = ApplicationAppearance

enum ApplicationAppearance {
    static func apply(window: UIWindow) {
        if #available(iOS 13.0, *) {
            window.overrideUserInterfaceStyle = .dark
        }
    }
}

extension ApplicationAppearance {
    static let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let contentPaddings = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    static let cornerRadius: CGFloat = 10.0
    
    enum Text {
        enum Font {
            enum Header1 {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                        ? .boldSystemFont(ofSize: UIFont.systemFontSize + 20.0)
                        : .systemFont(ofSize: UIFont.systemFontSize + 20.0)
                }
                static let lineHeight: CGFloat = 40.0
            }
            
            enum Header2 {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize + 16.0)
                    : .systemFont(ofSize: UIFont.systemFontSize + 16.0)
                }
                static let lineHeight: CGFloat = 30.0
            }
            
            enum Title1 {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize + 12.0)
                    : .systemFont(ofSize: UIFont.systemFontSize + 12.0)
                }
                static let lineHeight: CGFloat = 20.0
            }
            
            enum Title2 {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize + 8.0)
                    : .systemFont(ofSize: UIFont.systemFontSize + 8.0)
                }
                static let lineHeight: CGFloat = 20.0
            }
            
            enum Label1 {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize + 4.0)
                    : .systemFont(ofSize: UIFont.systemFontSize + 4.0)
                }
                static let lineHeight: CGFloat = 20.0
            }
            
            enum Label2 {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize + 2.0)
                    : .systemFont(ofSize: UIFont.systemFontSize + 2.0)
                }
                static let lineHeight: CGFloat = 20.0
            }
            
            enum Body {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize)
                    : .systemFont(ofSize: UIFont.systemFontSize)
                }
                static let lineHeight: CGFloat = 15.0
            }
            
            enum Note {
                static func font(bold isBold: Bool) -> UIFont {
                    return isBold
                    ? .boldSystemFont(ofSize: UIFont.systemFontSize - 2.0)
                    : .systemFont(ofSize: UIFont.systemFontSize - 2.0)
                }
                static let lineHeight: CGFloat = 12.0
            }
        }
    }
    
    enum Date {
        static func localDateStringFormat(from date: Foundation.Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateStyle = .short
            
            return dateFormatter.string(from: date)
        }
    }
}
