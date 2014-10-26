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
