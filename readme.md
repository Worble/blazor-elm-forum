**Todo:**

* ~~Make it look prettier~~ Not prettier but functional I spose
* ~~Add ability to upload images~~ ~~Done for Blazor, not for elm~~ Done for both
* ~~Websocket support for individual threads~~ Completed in elm, may be possible in blazor with js interop or possible using a c# client but that seems annoying
* Much code probably should be refactored:
  * Blazor "stores" need some seperation of concerns, probably should split into at least a class that handles api calling and one that handles store updating instead of clumping into one
  * Elm models should probably use Maybes instead defining empty models to fill the blanks
  * Api despite being two seperate projects are probably too tightly coupled, also the seed method fails if the seed already exists in the database
