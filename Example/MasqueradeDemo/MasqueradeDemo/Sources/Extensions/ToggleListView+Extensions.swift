import Brick
import Spots
import Masquerade

extension ToggleListView: Masqueradable {

  static func variations() -> Component {
    return Component(
      kind: "list",
      items: [
        Item(title: "Enabled", subtitle: "With extra information", kind: "toggle", meta: ["enabled" : true]),
        Item(title: "Enabled", kind: "toggle", meta: ["enabled" : true]),
        Item(title: "Disabled", subtitle: "With extra information", kind: "toggle", meta: ["enabled" : false]),
        Item(title: "Disabled", kind: "toggle", meta: ["enabled" : false])
      ]
    )
  }
}

