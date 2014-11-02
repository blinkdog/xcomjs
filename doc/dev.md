# dev
Development Notes (i.e.: What if I come back in six months to an
unrecognizable pile of CoffeeScript?)

## window
Some things attached to the global `window` object.

### window.DATA
`window.DATA` is `data.json` loaded into a variable. `data.json` contains
the binary data from X-COM: UFO Defense in base64 encoded strings. This is
the raw/unedited data in the format used by X-COM.

### window.XCOM
`window.XCOM` is `window.DATA` with minimal parsing to massage the data
into JavaScript accessible data structures with JavaScript encodings.
For example, strings used by the game are translated from the native
[Code Page 437](https://en.wikipedia.org/wiki/Code_page_437) to UTF-8.
Palette entries are translated from the native VGA (0-63) to HTML5 RGB (0-255).

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