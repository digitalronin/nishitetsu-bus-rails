// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"

// enable collapsible navbar
// https://materializecss.com/navbar.html#mobile-collapse This doesn't work
// after a turbo page "reload" so I've used data-turbo="false" for all the
// links that change pages in the app. This sucks, but this is not yak worth
// shaving.
document.addEventListener('turbo:load', function () {
  var elems = document.querySelectorAll('.sidenav');
  var instances = M.Sidenav.init(elems, {});
});
