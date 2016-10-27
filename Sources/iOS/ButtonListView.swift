import Brick
import Spots
import Tailor
import UIKit

public protocol ButtonListViewDelegate: class {
  func buttonListViewDidPress(_ view: ButtonListView)
}

open class ButtonListView: UITableViewCell, SpotConfigurable {

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
      selectionStyle = delegate == nil ? .default : .none
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

  public lazy var button = UIButton()
  public lazy var loadingIndicator = UIActivityIndicatorView()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(button)
    button.addSubview(loadingIndicator)
    backgroundColor = UIColor.clear
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(false, animated: false)
    button.isHighlighted = highlighted
  }

  override open func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(false, animated: false)
    button.isSelected = selected
  }

  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()

    styles = meta.styles
    button.setTitle(item.title, for: .normal)
    button.sizeToFit()
    button.isUserInteractionEnabled = false

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
    item.size.height = preferredViewSize.height
    self.item = item
  }

  override open func layoutSubviews() {
    super.layoutSubviews()

    button.layer.cornerRadius = button.frame.size.height / 2
  }
}
