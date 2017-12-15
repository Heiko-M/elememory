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
        private Gtk.Image icon_0;
        private Gtk.Image icon_1;

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
            icon_0 = new Gtk.Image.from_resource (iconname_0);
            icon_0.tooltip_text = tooltip_text_0;
            icon_1 = new Gtk.Image.from_resource (iconname_1);
            icon_1.tooltip_text = tooltip_text_1;

            if (selected == 0) {
                add (icon_0);
            } else {
                add (icon_1);
            }
            
            notify["selected"].connect (() => {
                toggle ();
           });
        }

        /**
          * Toggle switch state.
          */
        public void toggle () {
            if (selected == 0) {
                remove (get_child ());
                add (icon_0);
            } else {
                remove (get_child ());
                add (icon_1);
            }
            show_all ();
        }

        public override bool button_press_event (Gdk.EventButton event) {
            if (event.type == Gdk.EventType.BUTTON_PRESS) {
                selected = selected == 0 ? 1 : 0;
            }

            return true;
        }
    }
}
