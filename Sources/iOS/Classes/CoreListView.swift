import Brick
import Hue
import Imaginary
import Spots
import Tailor
import UIKit

open class CoreListView: ListSpotCell {

  var topMargin: CGFloat = 5
  var leftMargin: CGFloat = 7.5
  var imageMargin: CGFloat = 5

  struct Meta: Mappable {
    var styles: String = ""
    var separator: Bool = false
    var selected: Bool = false
    var tintColor: String = ""
    var disableSelected: Bool = false

    init(_ map: [String : Any]) {
      styles    <- map.property("styles")
      separator <- map.property("separator")
      selected  <- map.property("selected")
      tintColor <- map.property("tintColor")
      disableSelected <- map.property("disableSelected")
    }
  }

  open lazy var separatorView = UIView()

  var disableSelected: Bool = false

  public lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()

  open lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.numberOfLines = 0
    return label
  }()

  open lazy var extraTextLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()

  public override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(separatorView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subtitleLabel)
    contentView.addSubview(extraTextLabel)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    if disableSelected {
      super.setHighlighted(!disableSelected, animated: !disableSelected)
    } else {
      super.setHighlighted(highlighted, animated: animated)
    }
  }

  open override func setSelected(_ selected: Bool, animated: Bool) {
    if disableSelected {
      super.setSelected(!disableSelected, animated: !disableSelected)
    } else {
      super.setSelected(selected, animated: animated)
    }
  }

  /// A configure method that is used on reference types that can be configured using a view model
  ///
  /// - parameter item: A inout Item so that the ItemConfigurable object can configure the view model width and height based on its UI components
  override open func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()
    disableSelected = meta.disableSelected
    styles = item.styles

    self.item = item

    titleLabel.text = item.title
    subtitleLabel.text = item.subtitle
    extraTextLabel.text = item.text

    if let action = item.action, !action.isEmpty {
      accessoryType = .disclosureIndicator
    }

    if let url = URL(string: item.image), !item.image.isEmpty {
      layoutImageView()
      imageView?.setImage(url: url) { [weak self] _ in
        if !meta.tintColor.isEmpty { self?.imageView?.tintColor = UIColor(hex: meta.tintColor) }
        self?.layoutSubviews()
      }
    }
    layoutViews(item: &item)
    setSelected(meta.selected, animated: false)

    separatorView.alpha = meta.separator ? 1.0 : 0.0

    if item.dynamicHeight {
      item.size.height = extraTextLabel.frame.maxY + topMargin
    }

    separatorView.frame.origin.y = item.size.height - 1
  }

  func layoutViews(item: inout Item) {
    guard let imageView = imageView else { return }

    let leftMargin: CGFloat = !item.image.isEmpty ? self.leftMargin : self.leftMargin * 2
    let rightMargin: CGFloat = accessoryType == .none ? 15 : 45

    [titleLabel, subtitleLabel, extraTextLabel].forEach {
      $0.frame.size.height = 0.0
      if let text = $0.text, !text.isEmpty {
        $0.frame.origin.x = imageView.frame.maxX + leftMargin
        $0.frame.size.width = contentView.frame.width - $0.frame.origin.x - rightMargin
        $0.sizeToFit()
        $0.frame.size.width = contentView.frame.width - $0.frame.origin.x - rightMargin
      }
    }

    titleLabel.frame.origin.y = topMargin
    subtitleLabel.frame.origin.y = titleLabel.frame.maxY
    extraTextLabel.frame.origin.y = subtitleLabel.frame.maxY + (topMargin / 2)

    if item.size.height > extraTextLabel.frame.maxY && item.image.isEmpty {
      let newY = (frame.height - titleLabel.frame.height - subtitleLabel.frame.height - extraTextLabel.frame.height) / 2
      titleLabel.frame.origin.y = newY
      subtitleLabel.frame.origin.y = titleLabel.frame.maxY
      extraTextLabel.frame.origin.y = subtitleLabel.frame.maxY + (topMargin / 2)
    }
  }

  func layoutImageView() {
    if let item = item, let imageView = imageView {
      if !item.image.isEmpty {
        imageView.frame.origin.y = topMargin
        imageView.frame.origin.x = leftMargin
        if item.size.height > 80 {
          imageView.frame.size.width = 80 - topMargin
          imageView.frame.size.height = 80 - topMargin
        } else {
          imageView.frame.size.width = item.size.height - topMargin
          imageView.frame.size.height = item.size.height - topMargin
        }
      }
      separatorInset.left = titleLabel.frame.origin.x
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    layoutImageView()

    separatorView.frame.origin.x = 8
    separatorView.frame.size.width = contentView.frame.width - 16
    separatorView.frame.size.height = 0.5
  }

  open override func prepareForReuse() {
    disableSelected = false
    item = nil
    accessoryType = .none

    [titleLabel, subtitleLabel, extraTextLabel].forEach {
      $0.frame.origin.y = 0
      $0.text = ""
    }

    imageView?.image = nil
    imageView?.frame = CGRect.zero
  }
}
