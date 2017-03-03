/* Copyright 2017, Heiko Müller
*
* This file is part of eleMemory.
*
* eleMemory is free software: you can redistribute it and/or modify it under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, either version 3 of the License, or (at your option) any later
* version.
*
* eleMemory is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
* A PARTICULAR PURPOSE. See the GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* eleMemory. If not, see http://www.gnu.org/licenses/.
*/

using Gtk;

public class IndicatorBar : Gtk.ActionBar {
    /** This class represents the bottom indicator bar. **/
    public IndicatorBar () {
        var stats_label = new Label ("Draws: 0     Matches: 0");
        set_center_widget (stats_label);
    }

    public void update_stats (int draws, int matches) {
    }
}
