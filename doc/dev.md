# dev
Development Notes (i.e.: What if I come back in six months to an
unrecognizable pile of CoffeeScript?)

## window
Some things attached to the global `window` object.

### window.APP
`window.APP` contains application-wide settings. Some of them are described
here.

### window.APP.language
Set by the "Select Language" activity. Valid values are:

    ENGLISH
    DEUTSCHE
    FRANCAIS

### window.APP.strings = []
Set by the "Select Language" activity. Language independent access to
the strings of the game.

    [0]: ENGLISH.DAT, FRENCH.DAT, or GERMAN.DAT strings
    [1]: ENGLISH2.DAT, FRENCH2.DAT, or GERMAN2.DAT strings

Activities should use the functions provided by text.coffee rather
than access these global arrays directly.

### window.DATA
`window.DATA` is `data.json` loaded into a variable. `data.json` contains
the binary data from X-COM: UFO Defense in base64 encoded strings. This is
the raw/unedited data in the format used by X-COM.

### window.GAME
`window.GAME` is the current game of X-COM in progress. This is undefined
until the user elects to start a New Game or Load Saved Game. After that
a Game object will be present here.

### window.XCOM
`window.XCOM` is `window.DATA` with minimal parsing to massage the data
into JavaScript accessible data structures with JavaScript encodings.
For example, strings used by the game are translated from the native
[Code Page 437](https://en.wikipedia.org/wiki/Code_page_437) to UTF-8.
Palette entries are translated from the native VGA (0-63) to HTML5 RGB (0-255).

#### window.XCOM.SAMPLE
This is a two dimensional array of sound samples from X-COM. The first
array index indicates the source of the samples:

    0 = Geoscape Sounds (from: SAMPLE.CAT)
    1 = Battlescape Sounds (from: SAMPLE2.CAT)
    2 = Intro Sounds (from: SAMPLE3.CAT)

The second array index is the sample number. Details can be found on
the [UFOpaedia](http://ufopaedia.org/index.php?title=SOUND) article.

Each sample is represented by a sample object:

    {
        "offset": offset into the .CAT file
        "length": length of the WAVE file
        "header": buffer of header bytes before the WAVE file
        "file": buffer containing the full WAVE file
        "data": buffer containing only the raw sound data
    }

For our purposes, the `data` parameter contains what we need; the raw
unsigned 8-bit PCM encoded data.

## canvas
`ufo.html` provides a single canvas element `#canvas` upon which the game
does all of its drawing.

xcomjs listens for resize events, and will resize this canvas to cover the
entire visible window. When it does so, it will also annotate the canvas
object with three variables.

### canvas.scale
An integer indicating the zoom level used to scale up the graphics. The
native VGA resolution of X-COM: UFO Defense was 320x200. xcomjs preserves
this aspect ratio with `canvas.scale`. When the display has at least
640x400, `canvas.scale` will be 2. When the display has at least 960x600,
`canvas.scale` will be 3, and so on.

After determining the scale, the offsets needed to center the image on the
screen are calculated. For example, if the browser window has an available
display area of 1000x630...

    canvas.scale = 3  # (960x600 will fit in 1000x630)

    canvas.ox = 20
        # 1000 - 960 = 40 pixels left over
        # 40 / 2 = 20 pixels on the left, 20 pixels on the right
 
    canvas.oy = 15
        # 630 - 600 = 30 pixels left over
        # 30 / 2 = 15 pixels above the top, 15 pixels below the bottom

#### canvas.ox
The X offset (browser coordinates) of the upper-left of the game display.

#### canvas.oy
The Y offset (browser coordinates) of the upper-left of the game display.

## gfx.coffee
The `gfx` module provides canvas elements that can be drawn onto the
display. Where `window.XCOM` provided minimal parsing and encoding
translation, the `gfx` module provides HTML5 objects ready to be used.

## render.coffee
The `render` module provides drawing helper functions. It takes canvas
scale and offset into account when drawing. It also allows partial
rendering of backgrounds; a very common use-case for windows in X-COM.

## font.coffee
This provides a collection of glyphs intended to render text on the
game display. X-COM: UFO Defense has two font sizes, small and large.

    getSmallFont
    getLargeFont

These functions return arrays of objects with the following format:

    {
        "glyph": # a canvas object that can be drawn on the display
        "width": # the width in pixels for this glyph
        "encodes": # the UTF-8 letter or symbol represented by the glyph
    }

In addition, the array itself has several properties annotated upon it:

    "encoding": # a String containing the characters encoded in the font
                # one can use font.encoding.indexOf('X') to find the array
                # index that has a glyph for 'X', for example
    "spaceWidth": # the width of an empty space ' '
    "measure": # function to measure the width (X-COM coordinates) of the
               # provided string. for example: font.measure("UFO Defense")

## text.coffee
Provides two functions to obtain game text in a language independent way.

## activity
An activity is a take on the Android idea of an activity. A single purpose
screen that allows viewing/modifying some part of the application state. By
passing from activity to activity the user (player) can use the application
(play the game).

In xcomjs, activity is defined by the following structure:

    activity =
      name: "ACTIVITY_NAME"          # the name of the activity
      enter: ->                      # called before this activity begins
      leave: ->                      # called after this activity is finished
      mousedown: (e) ->              # called when the user presses a mouse button
      mousemove: (e) ->              # called when the user moves the mouse
      mouseup: (e) ->                # called when the user releases a mouse button
      render: (timestamp, canvas) -> # called by the game engine to draw the display
      update: (timestamp) -> this    # called by the game engine to update logic/state

### activity.update
This function is a little special, in that the return object is used as
the next activity object. Most of the time, the activity will return itself
(i.e.: this) as the next activity to be used. If the user is ready to
transition to another activity, the `update()` method should return that
instead.

The `timestamp` parameter is simply the game engine passing `Date.now()`.

### activity.render
The `timestamp` parameter is the timestamp passed to the callback provided
to the browser for `requestAnimationFrame`.

## gui
This subdirectory contains User Interface components. Right now, Button is
the only class, but provides convenient button behavior.

## state
This subdirectory contains game state components. The Game class is the
primary class, representing the current state of a game of X-COM.
