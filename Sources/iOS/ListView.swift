import UIKit
import Brick
import Spots
import Imaginary

open class ListView: UITableViewCell, SpotConfigurable {

  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(_ item: inout Item) {
    textLabel?.text = item.title
    detailTextLabel?.text = item.subtitle

    if !item.image.isEmpty {
      if let url = URL(string: item.image), item.image.hasPrefix("http") {
        imageView?.setImage(url: url)
      } else {
        imageView?.image = UIImage(named: item.image)
      }
    }
  }

  override open func prepareForReuse() {
    textLabel?.text = nil
    detailTextLabel?.text = nil
    imageView?.image = nil
  }
}
