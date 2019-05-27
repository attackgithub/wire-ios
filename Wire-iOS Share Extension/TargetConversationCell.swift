//
// Wire
// Copyright (C) 2019 Wire Swiss GmbH
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
import WireShareEngine

final class TargetConversationCell: UITableViewCell {

    let conversationNameLabel = UILabel()
    let stateAccessoryView = ConversationStateAccessoryView()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
        configureConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        contentView.addSubview(stateAccessoryView)

        conversationNameLabel.textColor = .black
        conversationNameLabel.font = .preferredFont(forTextStyle: .body)
        contentView.addSubview(conversationNameLabel)
    }

    private func configureConstraints() {
        conversationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        stateAccessoryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // stateAccessoryView
            stateAccessoryView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stateAccessoryView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // conversationNameLabel
            conversationNameLabel.leadingAnchor.constraint(equalTo: stateAccessoryView.trailingAnchor, constant: 8),
            conversationNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            conversationNameLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            conversationNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            conversationNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
        ])
    }

    // MARK: - Configuration

    override func prepareForReuse() {
        super.prepareForReuse()
        accessibilityLabel = nil
        conversationNameLabel.text = nil
        stateAccessoryView.prepareForReuse()
    }

    func configure(for conversation: Conversation) {
        // Subviews
        conversationNameLabel.text = conversation.name
        stateAccessoryView.configure(for: conversation)

        // Accessibility
        #warning("TODO: Add accessibility label computing.")
    }

}
