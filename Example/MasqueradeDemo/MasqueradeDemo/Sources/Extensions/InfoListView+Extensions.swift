import Brick
import Spots
import Masquerade

extension InfoListView: Masqueradable {

  static func variations() -> Component {
    return Component(
      kind: "list",
      items: [
        Item(title: "InfoListView", subtitle: "Placeholder text", kind: "info", size: CGSize(width: 0, height: 60)),
        Item(title: "InfoListView", subtitle: "Placeholder text", kind: "info", size: CGSize(width: 0, height: 120))
      ]
    )
  }
}
