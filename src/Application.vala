/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2023 Juan Lozano <libredeb@gmail.com>
 */
public class MyApp : Gtk.Application {
    public MyApp () {
        Object (
            application_id: "com.github.libredeb.gtk-hello",
            flags: GLib.ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void startup () {
        base.startup ();
        
        var quit_action = new GLib.SimpleAction ("quit", null);
        
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q", "<Control>w"});
        quit_action.activate.connect (quit);
    }
    
    protected override void activate () {
        string init_message = _("Loading user interface...");
        message (init_message);
        
        // Actions Example, see startup () method too
        /*
        var quit_button = new Gtk.Button.from_icon_name ("process-stop") {
            action_name = "app.quit",
            tooltip_markup = Granite.markup_accel_tooltip (
                get_accels_for_action ("app.quit"),
                "Exit Application"
            )
        };
        quit_button.add_css_class (Granite.STYLE_CLASS_LARGE_ICONS);
        */
        
        // Popovers Example
        var quit_button = new Gtk.Button () {
            action_name = "app.quit",
            child = new Granite.AccelLabel.from_action_name ("Exit Application", "app.quit")
        };
        quit_button.add_css_class (Granite.STYLE_CLASS_MENUITEM);
        
        var popover = new Gtk.Popover () {
            child = quit_button
        };
        popover.add_css_class (Granite.STYLE_CLASS_MENU);
        
        var menu_button = new Gtk.MenuButton () {
            icon_name = "open-menu",
            popover = popover,
            primary = true,
            tooltip_markup = Granite.markup_accel_tooltip ({"F10"}, "Menu")
        };
        menu_button.add_css_class (Granite.STYLE_CLASS_LARGE_ICONS);
        
        var headerbar = new Gtk.HeaderBar () {
            show_title_buttons = true
        };
        
        //headerbar.pack_start (quit_button);
        headerbar.pack_end (menu_button);
        
        /* Gtk.Box Example:
         *
         * var label = new Gtk.Label ("Hello World!");
         * var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
         * box.append (label);
         * box.append (new Gtk.Label (_("Welcome to my App")));
         */
         
        /* Gtk.Grid Example: */
        // First we create all the widgets we want to lay out in our grid
        var hello_button = new Gtk.Button.with_label (_("Hello"));
        var hello_label = new Gtk.Label (_("Label 1"));
        
        var goodbye_button = new Gtk.Button.with_label (_("Goodbye"));
        var goodbye_label = new Gtk.Label (_("Label 2"));
        
        // Then we create a new Grid and set its spacing properties
        var grid = new Gtk.Grid () {
            column_spacing = 6,
            row_spacing = 6
        };
        
        // Finally, we attach those widgets to the Grid.
        // Attach first row of widgets --> attach (column, row, width. height)
        grid.attach (hello_button, 0, 0, 1, 1);
        grid.attach (hello_label, 1, 0, 1, 1);
        
        // Attach second row of widgets
        grid.attach (goodbye_button, 0, 1);
        grid.attach_next_to (
            goodbye_label,
            goodbye_button,
            Gtk.PositionType.BOTTOM, // To which side of widget
            1, 1
        );
        
       
        var main_window = new Gtk.ApplicationWindow (this) {
            child = grid,
            default_height = 300,
            default_width = 300,
            title = "Hello World",
            titlebar = headerbar
        };
        
        main_window.present ();
    }
    
    public static int main (string[] args) {
        stdout.printf (_("Starting My App...\n"));
        return new MyApp ().run (args);
    }
}
