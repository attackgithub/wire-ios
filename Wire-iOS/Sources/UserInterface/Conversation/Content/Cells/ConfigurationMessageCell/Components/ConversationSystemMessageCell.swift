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
import TTTAttributedLabel

class ConversationSystemMessageCell: ConversationIconBasedCell, ConversationMessageCell {

    struct Configuration {
        let icon: UIImage?
        let attributedText: NSAttributedString?
        let showLine: Bool
    }

    // MARK: - Configuration

    func configure(with object: Configuration) {
        lineView.isHidden = !object.showLine
        imageView.image = object.icon
        attributedText = object.attributedText
    }

}

class LinkConversationSystemMessageCell: ConversationIconBasedCell, ConversationMessageCell {

    struct Configuration {
        let icon: UIImage?
        let attributedText: NSAttributedString?
        let showLine: Bool
        let url: URL
    }

    var lastConfiguration: Configuration?

    // MARK: - Configuration

    func configure(with object: Configuration) {
        lastConfiguration = object
        lineView.isHidden = !object.showLine
        imageView.image = object.icon
        attributedText = object.attributedText
    }

    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if let itemURL = lastConfiguration?.url {
            UIApplication.shared.open(itemURL)
        }
    }

}


class ConversationRenamedSystemMessageCell: ConversationIconBasedCell, ConversationMessageCell {

    struct Configuration {
        let attributedText: NSAttributedString
        let newConversationName: NSAttributedString
    }

    var nameLabelFont: UIFont? = .normalSemiboldFont
    private let nameLabel = UILabel()

    override func configureSubviews() {
        super.configureSubviews()
        nameLabel.numberOfLines = 0
        imageView.image = UIImage(for: .pencil, fontSize: 16, color: .textForeground)
        contentView.addSubview(nameLabel)
    }

    override func configureConstraints() {
        super.configureConstraints()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.fitInSuperview()
    }

    // MARK: - Configuration

    func configure(with object: Configuration) {
        lineView.isHidden = false
        attributedText = object.attributedText
        nameLabel.attributedText = object.newConversationName
        nameLabel.accessibilityLabel = nameLabel.attributedText?.string
    }

}

class ConversationRenamedSystemMessageCellDescription: ConversationMessageCellDescription {
    typealias View = ConversationRenamedSystemMessageCell
    let configuration: View.Configuration

    var message: ZMConversationMessage?
    weak var delegate: ConversationCellDelegate?

    var isFullWidth: Bool {
        return true
    }

    init(message: ZMConversationMessage, data: ZMSystemMessageData, sender: ZMUser, newName: String) {
        let senderText = message.senderName
        let titleString = "content.system.renamed_conv.title".localized(pov: sender.pov, args: senderText)

        let title = NSAttributedString(string: titleString, attributes: [.font: UIFont.mediumFont, .foregroundColor: UIColor.textForeground])
            .adding(font: .mediumSemiboldFont, to: senderText)

        let conversationName = NSAttributedString(string: newName, attributes: [.font: UIFont.normalSemiboldFont, .foregroundColor: UIColor.textForeground])
        configuration = View.Configuration(attributedText: title, newConversationName: conversationName)
    }

}

class ConversationCallSystemMessageCellDescription: ConversationMessageCellDescription {
    typealias View = ConversationSystemMessageCell
    let configuration: View.Configuration

    var message: ZMConversationMessage?
    weak var delegate: ConversationCellDelegate?

    var isFullWidth: Bool {
        return true
    }

    init(message: ZMConversationMessage, data: ZMSystemMessageData, missed: Bool) {
        let viewModel = CallCellViewModel(
            icon: missed ? .endCall : .phone,
            iconColor: UIColor(for: missed ? .vividRed : .strongLimeGreen),
            systemMessageType: data.systemMessageType,
            font: .mediumFont,
            boldFont: .mediumSemiboldFont,
            textColor: .textForeground,
            message: message
        )

        configuration = View.Configuration(icon: viewModel.image(), attributedText: viewModel.attributedTitle(), showLine: false)
    }
}

class ConversationMessageTimerCellDescription: ConversationMessageCellDescription {
    typealias View = ConversationSystemMessageCell
    let configuration: View.Configuration

    var message: ZMConversationMessage?
    weak var delegate: ConversationCellDelegate?

    var isFullWidth: Bool {
        return true
    }

    init(message: ZMConversationMessage, data: ZMSystemMessageData, timer: NSNumber, sender: ZMUser) {
        let senderText = message.senderName
        let timeoutValue = MessageDestructionTimeoutValue(rawValue: timer.doubleValue)

        var updateText: NSAttributedString? = nil
        let baseAttributes: [NSAttributedString.Key: AnyObject] = [.font: UIFont.mediumFont, .foregroundColor: UIColor.textForeground]

        if timeoutValue == .none {
            updateText = NSAttributedString(string: "content.system.message_timer_off".localized(pov: sender.pov, args: senderText), attributes: baseAttributes)
                .adding(font: .mediumSemiboldFont, to: senderText)

        } else if let displayString = timeoutValue.displayString {
            let timerString = displayString.replacingOccurrences(of: String.breakingSpace, with: String.nonBreakingSpace)
            updateText = NSAttributedString(string: "content.system.message_timer_changes".localized(pov: sender.pov, args: senderText, timerString), attributes: baseAttributes)
                .adding(font: .mediumSemiboldFont, to: senderText)
                .adding(font: .mediumSemiboldFont, to: timerString)
        }

        let icon = UIImage(for: .hourglass, fontSize: 16, color: UIColor(scheme: .textDimmed))
        configuration = View.Configuration(icon: icon, attributedText: updateText, showLine: false)
    }

}

public extension String {
    static let breakingSpace = " "           // classic whitespace
    static let nonBreakingSpace = "\u{00A0}" // &#160;
}

class ConversationVeritfiedSystemMessageSectionDescription: ConversationMessageCellDescription {
    typealias View = ConversationSystemMessageCell
    let configuration: View.Configuration

    var message: ZMConversationMessage?
    weak var delegate: ConversationCellDelegate?

    var isFullWidth: Bool {
        return true
    }

    init() {
        let title = NSAttributedString(
            string: "content.system.is_verified".localized,
            attributes: [.font: UIFont.mediumFont, .foregroundColor: UIColor.textForeground]
        )

        configuration = View.Configuration(icon: WireStyleKit.imageOfShieldverified, attributedText: title, showLine: true)
    }
}

class ConversationCannotDecryptSystemMessageCellDescription: ConversationMessageCellDescription {
    typealias View = LinkConversationSystemMessageCell
    let configuration: View.Configuration

    static fileprivate let generalErrorURL : URL = URL(string:"action://general-error")!
    static fileprivate let remoteIDErrorURL : URL = URL(string:"action://remote-id-error")!

    var message: ZMConversationMessage?
    weak var delegate: ConversationCellDelegate?

    var isFullWidth: Bool {
        return true
    }

    init(message: ZMConversationMessage, data: ZMSystemMessageData, sender: ZMUser, remoteIdentityChanged: Bool) {
        let exclamationColor = UIColor(for: .vividRed)
        let icon = UIImage(for: .exclamationMark, fontSize: 16, color: exclamationColor)
        let link: URL = remoteIdentityChanged ? .wr_cannotDecryptNewRemoteIDHelp : .wr_cannotDecryptHelp

        let title = ConversationCannotDecryptSystemMessageCellDescription
            .makeAttributedString(
                systemMessage: data,
                sender: sender,
                remoteIDChanged:
                remoteIdentityChanged,
                link: link
            )

        configuration = View.Configuration(icon: icon, attributedText: title, showLine: false, url: link)
    }

    // MARK: - Localization

    private static let BaseLocalizationString = "content.system.cannot_decrypt"
    private static let IdentityString = ".identity"

    private static func makeAttributedString(systemMessage: ZMSystemMessageData, sender: ZMUser, remoteIDChanged: Bool, link: URL) -> NSAttributedString {
        let name = localizedWhoPart(sender, remoteIDChanged: remoteIDChanged)

        let why = NSAttributedString(string: localizedWhyPart(remoteIDChanged),
                                     attributes: [.font: UIFont.mediumFont, .link: link as AnyObject, .foregroundColor: UIColor.textForeground])

        let device : NSAttributedString
        if DeveloperMenuState.developerMenuEnabled() {
            device = "\n" + NSAttributedString(string: localizedDevice(systemMessage.clients.first as? UserClient),
                                               attributes: [.font: UIFont.mediumFont, .foregroundColor: UIColor.textDimmed])
        } else {
            device = NSAttributedString()
        }

        let messageString = NSAttributedString(string: localizedWhatPart(remoteIDChanged, name: name),
                                               attributes: [.font: UIFont.mediumFont, .foregroundColor: UIColor.textForeground])

        let fullString = messageString + " " + why + device
        return fullString.addAttributes([.font: UIFont.mediumSemiboldFont], toSubstring:name)
    }

    private static func localizedWhoPart(_ sender: ZMUser, remoteIDChanged: Bool) -> String {
        switch (sender.isSelfUser, remoteIDChanged) {
        case (true, _):
            return (BaseLocalizationString + (remoteIDChanged ? IdentityString : "") + ".you_part").localized
        case (false, true):
            return (BaseLocalizationString + IdentityString + ".otherUser_part").localized(args: sender.displayName)
        case (false, false):
            return sender.displayName
        }
    }

    private static func localizedWhatPart(_ remoteIDChanged: Bool, name: String) -> String {
        return (BaseLocalizationString + (remoteIDChanged ? IdentityString : "")).localized(args: name)
    }

    private static func localizedWhyPart(_ remoteIDChanged: Bool) -> String {
        return (BaseLocalizationString + (remoteIDChanged ? IdentityString : "")+".why_part").localized
    }

    private static func localizedDevice(_ device: UserClient?) -> String {
        return (BaseLocalizationString + ".otherDevice_part").localized(args: device?.remoteIdentifier ?? "-")
    }

}

