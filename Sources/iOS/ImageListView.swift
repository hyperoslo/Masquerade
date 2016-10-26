import UIKit
import Spots
import Brick
import Tailor

open class ImageListView: UITableViewCell, SpotConfigurable {

  struct Meta: Mappable {
    var gradient: Bool = false
    var contentMode: Int = UIViewContentMode.scaleAspectFill.rawValue

    init(_ map: [String : Any]) {
      gradient <- map.property("gradient")
      contentMode <- map.property("contentMode")
    }
  }

  /// The perferred view size of the view.
  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  var bottomMargin: CGFloat = 15
  var leftMargin: CGFloat = 15

  lazy var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    layer.locations = [0.4, 1.0]
    return layer
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    imageView?.clipsToBounds = true
    imageView?.contentMode = .scaleAspectFill
    imageView?.layer.zPosition = 0
    textLabel?.layer.zPosition = 1
    detailTextLabel?.layer.zPosition = 2
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(false, animated: false)
  }

  open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(false, animated: false)
  }

  /// A configure method that is used on reference types that can be configured using a view model
  ///
  /// - parameter item: A inout Item so that the ItemConfigurable object can configure the view model width and height based on its UI components
  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()

    textLabel?.text = item.title
    detailTextLabel?.text = item.subtitle
    [textLabel, detailTextLabel].forEach { $0?.sizeToFit() }
    imageView?.layer.mask = meta.gradient ? gradientLayer : nil

    if let contentMode = UIViewContentMode.init(rawValue: meta.contentMode) {
      imageView?.contentMode = contentMode
    }

    if !item.image.isEmpty {
      if let url = URL(string: item.image), item.image.hasPrefix("http") {
        imageView?.setImage(url: url) { [weak self] _ in
          self?.layoutSubviews()
        }
      } else {
        imageView?.image = UIImage(named: item.image)
        layoutSubviews()
      }
    }

    styles = item.styles
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    imageView?.frame = contentView.frame
    gradientLayer.frame = contentView.frame

    guard let textLabel = textLabel, let detailTextLabel = detailTextLabel else { return }

    [textLabel, detailTextLabel].forEach {
      $0.frame.size.width = frame.size.width - leftMargin
      $0.frame.origin.x = leftMargin
    }

    textLabel.frame.origin.y = frame.size.height - textLabel.frame.size.height - detailTextLabel.frame.size.height - bottomMargin
    detailTextLabel.frame.origin.y = textLabel.frame.maxY
    separatorInset.left = textLabel.frame.origin.x
  }

  open override func prepareForReuse() {
    imageView?.frame = CGRect.zero
  }
}
