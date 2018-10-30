//
// Wire
// Copyright (C) 2018 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import UIKit

class ConversationMessageToolboxCell: UIView, ConversationMessageCell {

    struct Configuration {

    }

    let toolboxView = MessageToolboxView()

    var isSelected: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(toolboxView)
    }

    private func configureConstraints() {
        toolboxView.translatesAutoresizingMaskIntoConstraints = false
        toolboxView.fitInSuperview()
    }

    func configure(with object: Configuration) {
    
    }

}

class ConversationMessageToolboxCellDescription: ConversationMessageCellDescription {
    typealias View = ConversationMessageToolboxCell
    let configuration: View.Configuration

    var message: ZMConversationMessage?
    weak var delegate: ConversationCellDelegate?

    var isFullWidth: Bool {
        return false
    }

    init() {
        configuration = View.Configuration()
    }

}
