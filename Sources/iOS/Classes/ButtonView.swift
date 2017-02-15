import Spots
import Tailor
import UIKit

public protocol ButtonListViewDelegate: class {
  func buttonListViewDidPress(_ view: ButtonListView)
}

open class ButtonListView: View, ItemConfigurable {

  struct Meta: Mappable {
    var styles: String = ""
    var enabled: Bool = true

    init(_ map: [String : Any]) {
      self.styles <- map.property("styles")
      self.enabled <- map.property("enabled")
    }
  }

  public weak var delegate: ButtonListViewDelegate? {
    didSet {
      button.isUserInteractionEnabled = delegate != nil
    }
  }

  public var item: Item?
  public var preferredViewSize = CGSize(width: 0, height: 44)

  public var loading: Bool? {
    didSet {
      guard let loading = loading else { return }
      if loading {
        loadingIndicator.startAnimating()
      } else {
        loadingIndicator.stopAnimating()
      }
    }
  }

  public lazy var button: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(buttonDidPress), for: .touchUpInside)

    return button
  }()

  public lazy var loadingIndicator = UIActivityIndicatorView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    button.isUserInteractionEnabled = false
    addSubview(button)
    button.addSubview(loadingIndicator)
    backgroundColor = UIColor.clear
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()

    styles = meta.styles
    button.setTitle(item.title, for: .normal)
    button.sizeToFit()

    if button.frame.size.width < 180 {
      button.frame.size.width = 180
    }

    button.frame.size.height = preferredViewSize.height
    button.centerInSuperview()

    loadingIndicator.color = button.titleLabel?.textColor
    loadingIndicator.frame.size.height = button.frame.height
    loadingIndicator.frame.size.width = button.frame.height
    loadingIndicator.frame.origin.x = button.frame.width - loadingIndicator.frame.size.width
    loadingIndicator.frame.origin.y = button.frame.height - loadingIndicator.frame.size.height

    button.isEnabled = meta.enabled

    if item.size.height == 0.0 {
      item.size.height = preferredViewSize.height
    } else {
      button.centerInSuperview()
    }

    self.item = item
  }

  override open func layoutSubviews() {
    super.layoutSubviews()

    button.layer.cornerRadius = button.frame.size.height / 2
  }

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let result = super.point(inside: point, with: event)
    let insidePoint = convert(point, to: button)
    return result && button.point(inside: insidePoint, with: event)
  }

  // MARK: - Actions

  func buttonDidPress() {
    delegate?.buttonListViewDidPress(self)
  }
}
