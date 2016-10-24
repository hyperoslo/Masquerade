import Brick
import Cartography
import Spots
import Tailor
import Fashion
import UIKit

public protocol ToggleListViewDelegate: class {
  func toggleDidChangeValue(_ value: Bool)
}

open class ToggleListView: UITableViewCell, SpotConfigurable {
  /// The perferred view size of the view.
  open var preferredViewSize: CGSize = CGSize(width: 0, height: 78)

  struct Meta: Mappable {
    var styles: String = ""
    var enabled: Bool = false
    var separator: Bool = false

    public init(_ map: [String : Any]) {
      styles  <- map.property("styles")
      enabled <- map.property("enabled")
      separator <- map.property("separator")
    }
  }

  open weak var delegate: ToggleListViewDelegate?
  open lazy var separatorView = UIView()
  open lazy var toggleView: UISwitch = {
    var switchView = UISwitch()
    switchView.isOn = true
    switchView.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
    return switchView
  }()

  // MARK: Initialization

  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

    [toggleView, separatorView].forEach {
      contentView.addSubview($0)
    }

    setupLayout()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup methods

  /// A configure method that is used on reference types that can be configured using a view model
  ///
  /// - parameter item: A inout Item so that the ItemConfigurable object can configure the view model width and height based on its UI components
  open func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()

    styles = item.styles
    textLabel?.text = item.title
    detailTextLabel?.text = item.subtitle
    toggleView.isOn = meta.enabled
    separatorView.isHidden = !meta.separator

    if item.size.height == 0.0 || !item.dynamicHeight {
      item.size.height = preferredViewSize.height
    }
  }

  open func setupLayout() {
    constrain(contentView) { contentView in
      contentView.height == contentView.superview!.height
      contentView.width == contentView.superview!.width
    }

    constrain(toggleView, separatorView) { toggleView, separatorView in
      toggleView.right == toggleView.superview!.right - 20
      toggleView.centerY == toggleView.superview!.centerY
      toggleView.width == 50
      toggleView.height == 30

      separatorView.bottom == separatorView.superview!.bottom - 1
      separatorView.width == separatorView.superview!.width - (8 * 2)
      separatorView.height == 1
      separatorView.centerX == separatorView.superview!.centerX
    }
  }

  // MARK: - Actions

  func switchValueDidChange(_ sender: UISwitch!) {
    delegate?.toggleDidChangeValue(sender.isOn)
  }
}
