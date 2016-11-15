import UIKit
import Spots
import Brick
import Tailor

open class InfoListView: UITableViewCell, SpotConfigurable {

  struct Meta: Mappable {
    var enabled: Bool = false

    init(_ map: [String : Any]) {
      self.enabled <- map.property("enabled")
    }
  }

  /// The perferred view size of the view.
  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  public lazy var infoLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.7
    return label
  }()

  public lazy var inputLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 2
    label.textAlignment = .right
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.7
    return label
  }()

  public lazy var inputField: UITextField = {
    let inputField = UITextField()
    inputField.textAlignment = .right
    inputField.adjustsFontSizeToFitWidth = true
    inputField.contentScaleFactor = 0.6
    return inputField
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(infoLabel)
    contentView.addSubview(inputField)
    contentView.addSubview(inputLabel)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// A configure method that is used on reference types that can be configured using a view model
  ///
  /// - parameter item: A inout Item so that the ItemConfigurable object can configure the view model width and height based on its UI components
  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()

    infoLabel.text = item.title
    inputField.placeholder = item.subtitle
    inputField.text = item.text

    [infoLabel, inputField].forEach {
      $0.sizeToFit()
    }

    infoLabel.frame.size.width = contentView.frame.size.width / 3
    infoLabel.frame.origin.x = 16
    inputField.frame.size.width = contentView.frame.size.width - infoLabel.frame.maxX - 32

    infoLabel.centerVertically()
    inputField.centerVertically()

    inputField.frame.origin.x = contentView.frame.size.width - inputField.frame.width - 16

    inputLabel.text = inputField.text
    inputLabel.frame = inputField.frame

    if !inputField.isEnabled || !meta.enabled {
      inputField.alpha = 0.0
      inputLabel.alpha = 1.0
    } else {
      inputField.alpha = 1.0
      inputLabel.alpha = 0.0
    }
  }

  open override func prepareForReuse() {
    infoLabel.frame.size = CGSize.zero
    inputField.frame.size = CGSize.zero
    inputLabel.frame.size = CGSize.zero
  }
}
