/*
* Copyright (c) 2017 Heiko Müller (https://github.com/heiko-m)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Heiko Müller <mue.heiko@web.de>
*/

namespace Elememory.Widgets {
    /** 
      * Switch which toggles between two states represented by different icons.
      */
    public class ToggleSwitch : Gtk.EventBox {
        public int selected { get; construct set; }
        public string iconname_0 { get; construct; }
        public string iconname_1 { get; construct; }
        public string? tooltip_text_0 { get; construct; }
        public string? tooltip_text_1 { get; construct; }
        private Gtk.Image[] icons;

        public ToggleSwitch (string iconname_0, string iconname_1, int selected) {
            this.with_tooltip_texts (iconname_0, iconname_1, selected, null, null);
        }

        public ToggleSwitch.with_tooltip_texts (string iconname_0, string iconname_1, int selected, string? tooltip_text_0, string? tooltip_text_1) {
            Object (
                selected: selected,
                iconname_0: iconname_0,
                iconname_1: iconname_1,
                tooltip_text_0: tooltip_text_0,
                tooltip_text_1: tooltip_text_1
            );
        }

        construct {
            icons = new Gtk.Image[2];
            icons[0] = new Gtk.Image.from_resource (iconname_0);
            icons[0].tooltip_text = tooltip_text_0;
            icons[1] = new Gtk.Image.from_resource (iconname_1);
            icons[1].tooltip_text = tooltip_text_1;

            add (icons[selected]);
        }

        public override bool button_press_event (Gdk.EventButton event) {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                selected = selected == 0 ? 1 : 0;

                remove (get_child ());
                add (icons[selected]);
                show_all ();
            }

            return true;
        }
    }
}
