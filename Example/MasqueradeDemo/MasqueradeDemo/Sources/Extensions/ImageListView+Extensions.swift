import Brick
import Spots
import Masquerade

extension ImageListView: Masqueradable {

  static func variations() -> Component {
    return Component(
      kind: "list",
      items: [
        Item(title: "Title",
             subtitle: "Subtitle",
             image: "http://www.youtwitface.com/wp-content/uploads/2012/05/kitten-650x488.jpeg",
             kind: "image",
             size: CGSize(width: 0, height: 180))
      ]
    )
  }
}
