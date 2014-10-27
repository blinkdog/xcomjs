# notes
Some development notes

## Buttons
The buttons on the intro screen use the following shades:

[1] 101, 207, 190   (index 134)
[2] 60, 166, 146    (index 135)
[3] 28, 130, 141    (index 136)
[4] 8, 89, 65       (index 137)
[5] 0, 52, 32       (index 138)

These shades seem to correspond to the GeoScape palette (full palette 0),
indexes 134-138 (inclusive).

The graphical layout of the button is as follows:

11111111111111111115
12222222222222222245
12333333333333333345
12333333333333333345
12333333333333333345
12333333333333333345
12444444444444444445
15555555555555555555

The size of the intro screen buttons is 192 x 20 pixels.

The upper-left corners of the three buttons are located at:

64, 90
64, 118
64, 146

## Window Borders
The window border on the intro screen uses the following shades:

[1] 101, 207, 190   (index 134)
[2] 60, 166, 146    (index 135)
[3] 28, 130, 141    (index 136)

These shades seem to correspond to the GeoScape palette (full palette 0),
indexes 134-136 (inclusive).

The graphical layout of the window border is as follows:

33333333333333333333333333333333333
32222222222222222222222222222222223
32111111111111111111111111111111123
32122222222222222222222222222222123
32123333333333333333333333333332123
32123                         32123
32123                         32123
32123                         32123
32123                         32123
32123333333333333333333333333332123
32122222222222222222222222222222123
32111111111111111111111111111111123
32222222222222222222222222222222223
33333333333333333333333333333333333

The size of the intro screen window border is 256 x 160 pixels.

The upper-left of the window border is located at: 32, 20

## Fonts
There are two different font colors in use on the intro screen. The
font color used to display the title uses the following shade:

[1] 170, 190, 81    (index 139)

This shade seems to correspond to the GeoScape palette (full palette 0),
index 139.

The font color used on the buttons seems to match the button
shades:

[1] 101, 207, 190   (index 134)
[2] 60, 166, 146    (index 135)
[3] 28, 130, 141    (index 136)
[4] 8, 89, 65       (index 137)
[5] 0, 52, 32       (index 138)

These shades seem to correspond to the GeoScape palette (full palette 0),
indexes 134-138 (inclusive).
