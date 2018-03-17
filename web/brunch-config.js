// See http://brunch.io for documentation.
exports.config = {
  files: {
    javascripts: { joinTo: 'app.js' },
    stylesheets: { joinTo: 'app.css' },
  },


  // Configure your plugins in brunch-config.js (or .coffee)
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    },
    elmBrunch: {
      // (required) Set to the elm file(s) containing your "main" function `elm make` 
      //            handles all elm dependencies relative to `elmFolder`
      mainModules: ['app/elm/Main.elm'],

      // (optional) Set to path where `elm-make` is located, relative to `elmFolder`
      //executablePath: '../../node_modules/elm/binwrappers',

      // (optional) Set to path where elm-package.json is located, defaults to project root
      //            if your elm files are not in /app then make sure to configure 
      //            paths.watched in main brunch config
      //elmFolder: 'path/to/elm-files',

      // (optional) Defaults to 'js/' folder in paths.public
      // relative to `elmFolder`
      outputFolder: 'app/vendor/',

      // (optional) If specified, all mainModules will be compiled to a single file 
      //            This is merged with outputFolder.
      //outputFile: 'elm.js',

      // (optional) add some parameters that are passed to elm-make
      makeParameters: ['--debug']
    }
  }
};