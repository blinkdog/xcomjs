# confirmNightmareMode.coffee
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

###
  NOTES:
    - Should display the standard background (background 0) in the 
      Terror Site red palette.
    - Should play the Terror Site MIDI.
    - Two Buttons
        - Launch
        - Cancel
    - Text similar to:
    
          THE NIGHTMARE SCENARIO   <-- big font
          
          This is The Nightmare Scenario. The aliens will be unbelievably
          difficult to defeat. The aliens will actually cheat in order to
          win the game. The game is practically impossible to win.
          
          Do you wish to play The Nightmare Scenario?
###

# TODO: Implement 'confirmNightmareMode'
exports.activity =
  enter: ->
    alert 'The Nightmare Scenario'

#----------------------------------------------------------------------------
# end of confirmNightmareMode.coffee
