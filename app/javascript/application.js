// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

function onready() {
  // enable collapsible navbar
  // https://materializecss.com/navbar.html#mobile-collapse
  var elems = document.querySelectorAll('.sidenav');
  var instances = M.Sidenav.init(elems, {});
}

// TODO: this isn't working properly - the nav menu is broken after following a link
document.addEventListener("turbo:load", onready)
