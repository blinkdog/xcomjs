# xcomjs
X-COM: Browser Defense

## Installation
The following sequence will build and run the game in Firefox.

    git clone https://github.com/blinkdog/xcomjs
    cd xcomjs
    npm install
    cake rebuild
    bin/make-xcom-data /path/to/XCOM data.json
    cake rebuild
    cake run

## Thanks
I wrote xcomjs, but drew heavily upon the reference material found at
[UFOpaedia.org](http://ufopaedia.org/). Truly, my code stands upon the
shoulders of the geniuses who reverse engineered and clearly documented
the binary file formats of the original UFO: Enemy Unknown.

I'd also like to thank Dominic Szablewski for his blog post [Drawing Pixels is
Hard](http://phoboslab.org/log/2012/09/drawing-pixels-is-hard). It pointed me
in the right direction for rendering pixel graphics on the HTML5 canvas.

## License
xcomjs<br/>
Copyright 2014 Patrick Meade.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
