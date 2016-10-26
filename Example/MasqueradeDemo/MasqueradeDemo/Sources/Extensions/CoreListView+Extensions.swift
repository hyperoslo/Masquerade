import Brick
import Spots
import Masquerade

extension CoreListView: Masqueradable {

  static func variations() -> Component {
    var items = [
      Item(title: "CoreListView", subtitle: "with fixed height", image: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200", kind: "core", size: CGSize(width: 0, height: 60)),
      Item(title: "CoreListView", subtitle: "with fixed height", kind: "core", size: CGSize(width: 0, height: 80)),
      Item(title: "CoreListView", subtitle: "with subtitle and fixed height", kind: "core", size: CGSize(width: 0, height: 60)),
      Item(title: "CoreListView", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sapien justo, posuere at augue sit amet, euismod ultrices enim. Sed venenatis auctor ipsum non pulvinar. Nullam nec felis lacinia metus interdum porttitor vitae nec quam. Aenean maximus libero eu tincidunt imperdiet.", kind: "core", action: "test"),
      Item(title: "CoreListView", subtitle: "with dynamic height", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas sapien justo, posuere at augue sit amet, euismod ultrices enim. Sed venenatis auctor ipsum non pulvinar. Nullam nec felis lacinia metus interdum porttitor vitae nec quam. Aenean maximus libero eu tincidunt imperdiet. \n\nNunc ac leo urna. In nisl lectus, blandit sed aliquet sed, scelerisque in justo. Praesent id nibh sed libero scelerisque tristique. Sed eget nunc rhoncus, facilisis elit vel, tempor ex. Sed ultricies ac lectus eu ultrices. Suspendisse vel convallis enim. Nam venenatis, tellus sit amet hendrerit mollis, turpis eros sollicitudin mauris, non sollicitudin quam diam a nisl. Nulla vestibulum ex risus, eget ultrices mi posuere at.", image: "https://avatars2.githubusercontent.com/u/1340892?v=3&s=200", kind: "core")
    ]

    items[3].dynamicHeight = true
    items[4].dynamicHeight = true

    return Component(
      kind: "list",
      items: items
    )
  }
}
