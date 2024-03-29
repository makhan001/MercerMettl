// FontAwesomeView.swift
//
// Copyright (c) 2014-present FontAwesome.swift contributors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

/// A view for FontAwesome icons.
@IBDesignable public class FontAwesomeView: UIView {

    @IBInspectable
    public var iconCode: String = "" {
        didSet {
            self.iconView.text = String.fontAwesomeIcon(code: iconCode)
        }
    }

    @IBInspectable
    public var styleName: String = "Brands"

    private var iconView = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }

    /// Add a UILabel subview containing FontAwesome icon
    func setupViews() {
        // Fits icon in the view
        self.iconView.textAlignment = NSTextAlignment.center
        self.iconView.text = String.fontAwesomeIcon(code: self.iconCode)
        self.iconView.textColor = self.tintColor
        self.addSubview(iconView)
    }

    override public func tintColorDidChange() {
        self.iconView.textColor = self.tintColor
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        self.clipsToBounds = true
        let size = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height
        let style = FontAwesomeStyle(rawValue: styleName) ?? .solid
        self.iconView.font = UIFont.fontAwesome(ofSize: size, style: style)
        self.iconView.frame = CGRect(origin: CGPoint(x: 0, y: 0),
                                     size: CGSize(width: bounds.size.width,
                                                  height: bounds.size.height))
    }
}
