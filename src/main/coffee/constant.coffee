# constant.coffee
# Copyright 2014 Patrick Meade.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#----------------------------------------------------------------------------

exports.COLOR_DATE_BLUE = [0, 245]    # Palette 0, Index 245
exports.COLOR_GREEN = [0, 134]        # Palette 0, Index 134
exports.COLOR_OTHER_GREEN = [0, 240]  # Palette 0, Index 240
exports.COLOR_YELLOW = [0, 139]       # Palette 0, Index 139

exports.DIFFICULTY_BEGINNER = 0
exports.DIFFICULTY_EXPERIENCED = 1
exports.DIFFICULTY_VETERAN = 2
exports.DIFFICULTY_GENIUS = 3
exports.DIFFICULTY_SUPERHUMAN = 4

exports.GLYPH_SIZE =
  LARGE:
    WIDTH: 16
    HEIGHT: 16
  SMALL:
    WIDTH: 8
    HEIGHT: 9

exports.MOUSE_BUTTON_LEFT = 0

exports.MOUSE_BUTTON_MIDDLE = 1

exports.MOUSE_BUTTON_RIGHT = 2

exports.OVERLAY_SIZE =
  WIDTH: 64
  HEIGHT: 154

exports.SAMPLE_BUTTON_PUSH = 0

exports.SAMPLE_RATE = 11025

exports.XCOM_SIZE =
  WIDTH: 320
  HEIGHT: 200

#----------------------------------------------------------------------------
# end of constant.coffee
