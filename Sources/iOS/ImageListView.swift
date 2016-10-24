import UIKit
import Spots
import Brick
import Masquerade

open class ImageListView: UITableViewCell, SpotConfigurable {
  /// The perferred view size of the view.
  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  var leftMargin: CGFloat = 5

  lazy var gradientLayer: CAGradientLayer = {
    let layer = CAGradientLayer()
    layer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
    layer.locations = [0.3, 1.0]
    return layer
  }()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    imageView?.contentMode = .scaleAspectFill
    imageView?.layer.zPosition = 0
    textLabel?.layer.zPosition = 1
    detailTextLabel?.layer.zPosition = 2
    imageView?.layer.mask = gradientLayer
    imageView?.layer.masksToBounds = true
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  /// A configure method that is used on reference types that can be configured using a view model
  ///
  /// - parameter item: A inout Item so that the ItemConfigurable object can configure the view model width and height based on its UI components
  public func configure(_ item: inout Item) {
    guard let url = URL(string: item.image), !item.image.isEmpty else { return }
    textLabel?.text = item.title
    detailTextLabel?.text = item.subtitle
    [textLabel, detailTextLabel].forEach { $0?.sizeToFit() }
    imageView?.setImage(url: url) { [weak self] _ in
      self?.layoutSubviews()
    }

    styles = item.styles
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    guard let textLabel = textLabel, let detailTextLabel = detailTextLabel else { return }

    imageView?.frame = contentView.frame
    gradientLayer.frame = contentView.frame

    [textLabel, detailTextLabel].forEach {
      $0.frame.size.width = frame.size.width - leftMargin
      $0.frame.origin.x = leftMargin
    }

    textLabel.frame.origin.y = frame.size.height - textLabel.frame.size.height - detailTextLabel.frame.size.height
    detailTextLabel.frame.origin.y = textLabel.frame.maxY
    separatorInset.left = textLabel.frame.origin.x
  }

  open override func prepareForReuse() {
    imageView?.frame = CGRect.zero
  }
}
