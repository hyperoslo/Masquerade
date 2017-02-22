import UIKit
import Fashion
import Spots
import Tailor
import Cartography

open class TextListView: View, ItemConfigurable {

  public var item: Item?

  public struct Meta: Mappable {
    public var styles: String = ""

    public init(_ map: [String : Any]) {
      self.styles <- map.property("styles")
    }
  }

  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  public let textLabel = UILabel()

  public override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(textLabel)
    setupLayout()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  public func configure(_ item: inout Item) {
    let meta: Meta = item.metaInstance()
    styles = meta.styles

    textLabel.text = item.title
    self.item = item
  }

  open func setupLayout() {
    constrain(textLabel) { (textLabel) in
      textLabel.centerY == textLabel.superview!.centerY
      textLabel.left == textLabel.superview!.left + 20
      textLabel.right == textLabel.superview!.right - 20
    }
  }

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let result = super.point(inside: point, with: event)
    let insidePoint = convert(point, to: textLabel)
    return result && textLabel.point(inside: insidePoint, with: event)
  }
}

