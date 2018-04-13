document.addEventListener('DOMContentLoaded', function () {
  // do your setup here
  var app = Elm.Main.fullscreen()
  console.log('Initialized app');

  app.ports.scrollIdIntoView.subscribe(function (domId) {
    scroll = function () {
      if (!document.getElementById(domId)) {
        window.requestAnimationFrame(scroll);
      }
      else {
        document.getElementById(domId).scrollIntoView();
      }
    }
    window.requestAnimationFrame(scroll);
  });
});
