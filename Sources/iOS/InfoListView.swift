import UIKit
import Spots
import Brick

open class InfoListView: UITableViewCell, SpotConfigurable {
/// The perferred view size of the view.
  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  public lazy var inputField: UITextField = {
    let inputField = UITextField()
    inputField.textAlignment = .right
    return inputField
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(inputField)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// A configure method that is used on reference types that can be configured using a view model
  ///
  /// - parameter item: A inout Item so that the ItemConfigurable object can configure the view model width and height based on its UI components
  public func configure(_ item: inout Item) {
    textLabel?.text = item.title
    inputField.placeholder = item.subtitle
    inputField.text = item.text
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    let offset = textLabel?.frame.origin.x ?? 0.0

    inputField.frame.size.height = textLabel?.frame.size.height ?? 0.0
    inputField.frame.size.width = contentView.frame.size.width / 2
    inputField.frame.origin.x = contentView.frame.maxX - inputField.frame.size.width - offset
    inputField.frame.origin.y = textLabel?.frame.origin.y ?? 0.0
  }
}
