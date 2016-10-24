import Brick
import Spots
import Masquerade

struct MasqueradeConfigurator {

  var listDescription = "Component: List"

  var items: [Item] {
    return [
      Item(title: "Core",   subtitle: listDescription, meta: ["kind" : "core"]),
      Item(title: "Toggle", subtitle: listDescription, meta: ["kind" : "toggle"]),
      Item(title: "Button", subtitle: listDescription, meta: ["kind" : "button"]),
      Item(title: "Image",  subtitle: listDescription, meta: ["kind" : "image"]),
      Item(title: "HTML",   subtitle: listDescription, meta: ["kind" : "html"]),
      Item(title: "Info",   subtitle: listDescription, meta: ["kind" : "info"]),
      Item(title: "Input",  subtitle: listDescription, meta: ["kind" : "input"]),
    ]
  }

  var lookup: [String : UIView.Type]

  init() {
    Controller.configure = { $0.backgroundColor = .white }
    ListSpot.configure = { $0.backgroundColor = .white }
    GridSpot.configure = { view, _ in view.backgroundColor = .white }
    CarouselSpot.configure = { view, _ in view.backgroundColor = .white }

    lookup = [
      "core" : CoreListView.self,
      "toggle" : ToggleListView.self,
      "info" : InfoListView.self,
      "image" : ImageListView.self
    ]

    for (key, value) in lookup {
      ListSpot.register(view: value, identifier: key)
    }
  }
}
