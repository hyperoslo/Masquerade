import UIKit
import Brick
import Fashion
import Spots
import Tailor

open class TextListView: UITableViewCell, SpotConfigurable {

  public var item: Item?

  public struct Meta: Mappable {
    public var styles: String = ""

    public init(_ map: [String : Any]) {
      self.styles <- map.property("styles")
    }
  }

  public var preferredViewSize: CGSize = CGSize(width: 0, height: 44)

  public func configure(_ item: inout Item) {
    selectionStyle = .none
    let meta: Meta = item.metaInstance()
    styles = meta.styles

    textLabel?.text = item.title
    detailTextLabel?.text = item.subtitle
    self.item = item
  }

  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let result = super.point(inside: point, with: event)

    guard let textLabel = textLabel else {
      return result
    }

    let insidePoint = convert(point, to: textLabel)
    return result && textLabel.point(inside: insidePoint, with: event)
  }
}

