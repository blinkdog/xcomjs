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

### Spacing
Small characters seem to overwrite the shadow the previous character.
Large characters seem to use the full shadow of the character.
So, when measuring glyphs, we take one pixel away from the width of
small characters. That way they can be drawn the way X-COM draws them.

There are two special cases. First, in small fonts, the uppercase 'L'
character is drawn as if it were one pixel narrower. That is, a
character following an 'L' doesn't just overwrite the shadow/shading
pixels, it actually draws upon the L itself.

Second, X-COM does not provide a space character. The small characters
appear to treat a space as a fully transparent character of width 5.
The large characters appear to treat a space as a fully transparent
character with a width of 11.

## Interactives
Buttons and fonts seem to reverse their color schemes when pushed.
It uses the same palette indexes, it's just that they're computed
from dark-to-light instead of light-to-dark.

55555555555555555551
54444444444444444421
54333333333333333321
54333333333333333321
54333333333333333321
54333333333333333321
54222222222222222221
51111111111111111111

## Sounds
[UFOpaedia](http://ufopaedia.org/index.php?title=SOUND) has an article
on the sound samples from X-COM. I did a little additional reverse
engineering and discovered the following:

The .CAT files contain an offset/length table at the beginning of
the file. Each entry has the following format:

    Offset  4 bytes (UInt32LE)
    Length  4 bytes (UInt32LE)

Each entry in the table is thus 8 bytes long. So it is possible to
calculate the length of the table by taking the first offset and
dividing by 8. This gives the number of entries in the file.

    File Index
        Repeat (x Number-Of-Entries)
            Offset  4 bytes (UInt32LE)
            Length  4 bytes (UInt32LE)
    File 0
    File 1
    ...
    File N-1

There is also some kind of header preceeding each file:

    File i
        Header
            Header_Size  1 byte (UInt8LE)
            Header_Byte  # bytes (as specified in the previous byte)
        File Data
            File_Bytes   (Length) bytes, as specified in the file index

So each file contained within X-COM's .CAT files has two or three extra bytes
pre-pended to the actual data files. All but one of the files contained
in SAMPLE.CAT, SAMPLE2.CAT, and SAMPLE3.CAT are Microsoft WAVE files with
the following format:

    Encoding: Unsigned PCM  
    Channels: 1 @ 8-bit    
    Samplerate: 11025Hz

UFOpaedia says SAMPLE2.CAT, File 1 (the second file in the .CAT) contains
"garbage". However, the contents look suspiciously like a portion of a
build script, with calls to Turbo Assembler and the Watcom C/C++ compiler:

    del ufo2exe\ufo.exe
    tasm /j.386p /w+ /ml /m /p /s /zi /d__WATCOMC__=900 apw_asm.s
    tasm /j.386p /w+ /ml /m /p /s /zi /d__WATCOMC__=900 digit.asm
    tasm /j.386p /w+ /ml /m /p /s /zi /d__WATCOMC__=900 timer32.s
    wcc386 -ms -3r -d2 -oa sound.c
    copy sound.obj ufo2exe
    copy timer32.obj ufo2exe
    copy digit.obj ufo2exe
    copy apw_asm.obj ufo2exe
    call mu

The remaining files have a very simple RIFF/WAVE/fmt/data encoding of
the Unsigned 8-Bit 11025Hz PCM data. It begins at Offset 0x2C (Offset 44)
in the WAVE data file and continues to the end of the file. The exact
length of this data can be found in the 4 bytes (UInt32LE) just prior
to the data, at Offset 0x28 (Offset 40).

## Difficulty Selection Screen

### Text Resources

    window.XCOM.ENGLISH[782] = "Select Difficulty Level"
    window.XCOM.ENGLISH[783] = "1> Beginner"
    window.XCOM.ENGLISH[784] = "2> Experienced"
    window.XCOM.ENGLISH[785] = "3> Veteran"
    window.XCOM.ENGLISH[786] = "4> Genius"
    window.XCOM.ENGLISH[787] = "5> Superhuman"

### Graphical Layout

The background (back palette 0) and window border (COLOR_GREEN), start
at upper-left coordinates 64, 10 and have dimensions: 192, 180

"Select Difficulty Level" is COLOR_YELLOW and starts at 112, 30. It is
probably centered and can be rendered with drawCenterText.

The buttons are COLOR_GREEN with COLOR_GREEN labels. There are five buttons
with upper-left coordinates:

    80,  55
    80,  80
    80, 105
    80, 130
    80, 155

The buttons have dimensions: 160, 18. The labels are covered under
Text Resources above.

## Select Site For New Base
The background (back palette 0) and window border (COLOR_OTHER_GREEN), start
at upper-left coordinates 0, 0 and have dimensions: 256, 28

The text "SELECT SITE FOR NEW BASE" is displayed in the small font
with the (COLOR_GREEN) palette. It starts at upper-left coordinates: 8, 10.
It is found in the string resources at Index 283:

    window.XCOM.ENGLISH[283] = "SELECT SITE FOR NEW BASE"

COLOR_OTHER_GREEN seems to be palette 0 at Index 240

## The current date on the Geoscape
This one really is an odd display. The background is basically a large button
and the current date and time is drawn on top of it. The coordinates given
in this section are relative to the upper-left corner of the button at 0,0.

The color scheme used for the font is a scheme I'm calling COLOR_DATE_BLUE.
It is part of the geoscape palette (palette 0) starting at index 245.

The way the time is drawn depends on the current time. The hours, the minutes,
and the colons separating hours, minutes, and seconds are drawn in the large
font. The colons are fixed at 22,2 and 46,2 and never change.

Between 1 and 9 (inclusive), the hour is right-justified and drawn at 12,2
and between 10 and 23 (inclusive), the hour is left-justified and drawn at
2,2. 

The minutes are always left-justified and drawn at 26,2.

The seconds are drawn in the small font, and relatively speaking sit on a
slightly lower baseline than the hours and minutes. The seconds are left
justified and always drawn at 50,8.

For the rest of the date, I ignored the way X-COM renders it. I'm relying
on an external library (moment.js) to do the date handling. One of the
features of the library is localization. So instead of relying upon the
French and German string resources, I allow the library to provide a
properly localized result.

X-COM rendered the day of the week in upper-case letters. I chose to retain
this, and simply center it horizontally in the 63-pixel wide button where
the date information is rendered.

Similarly with the day of the month and the month, they are rendered per
the localization of the library and centered horizontally in the button.

Similarly with the year, it is centered horizontally in the button.

A game of X-COM begins on Jan 1st, 1999. In 1994 when X-COM was released,
this was ~5 years into the future and seemed a long way off. Today, it
seems like it was a long time ago. I wanted to retain the feeling that the
game is set [twenty minutes into the future](http://tvtropes.org/pmwiki/pmwiki.php/Main/TwentyMinutesIntoTheFuture).

At first, I thought to start games of xcomjs at the present time. That is,
if you started a game on 15 August 2020, then the initial date of the game
itself would be 15 August 2020. The problem here is that X-COM has game
mechanics that work on a monthly basis; vehicle rental, base maintenance,
salaries paid, activity vs. aliens, etc.

So I decided to start games of xcomjs on the first of the following month.
If you start a game on 15 August 2020, then the date of the start of the
game will be 01 September 2020. Starting a game on 01 September 2020 would
result in a game start date of 01 October 2020 and so forth.
