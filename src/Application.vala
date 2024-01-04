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
        // other options: warning ("text"), error ("text"), critical ("text")
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
        
        var start_headerbar = new Gtk.HeaderBar () {
            show_title_buttons = false,
            title_widget = new Gtk.Label ("")
        };
        start_headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        
        //headerbar.pack_start (quit_button);
        start_headerbar.pack_start (new Gtk.WindowControls (Gtk.PackType.START));
        
        var start_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0) {
            width_request = 200
        };
        start_box.append (start_headerbar);
        var option1_button = new Gtk.Button.with_label ("Option 1");
        option1_button.add_css_class (Granite.STYLE_CLASS_FLAT);
        start_box.append (option1_button);
        
        var end_headerbar = new Gtk.HeaderBar() {
            show_title_buttons = false
        };
        end_headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        
        /* 
         * The order really matters, pack a widget to the end and always
         * replace the last widget in his palce.
         */
        end_headerbar.pack_end (new Gtk.WindowControls (Gtk.PackType.END));
        end_headerbar.pack_end (menu_button);
        
        var end_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        end_box.append (end_headerbar);
        
        /* Gtk.Box Example:
         *
         * var label = new Gtk.Label ("Hello World!");
         * var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
         * box.append (label);
         * box.append (new Gtk.Label (_("Welcome to my App")));
         */
         
        /* Gtk.Grid Example: */
        // First we create all the widgets we want to lay out in our grid
        var hello_button = new Gtk.Button.with_label (_("Show Notification"));
        hello_button.add_css_class (Granite.STYLE_CLASS_DESTRUCTIVE_ACTION);
        hello_button.clicked.connect (() => {
            var notification = new Notification ("Welcome to My App");
            notification.set_body ("This is a notification!");
            notification.set_icon (new ThemedIcon ("process-completed"));
            notification.add_button ("Quit My App", "app.quit");
            notification.set_priority (NotificationPriority.URGENT);
            send_notification ("my-notification", notification);
        });
        var hello_label = new Gtk.Label (_("Label 1"));
        
        var goodbye_button = new Gtk.Button.with_label (_("Replace Notification"));
        goodbye_button.add_css_class (Granite.STYLE_CLASS_SUGGESTED_ACTION);
        goodbye_button.clicked.connect (() => {
            var notification = new Notification ("Hello Again");
            notification.set_body ("This is a second Notification!");
            
            send_notification ("my-notification", notification);
        });
        var goodbye_label = new Gtk.Label (_("Label 2"));
        
        var vertical_separator = new Gtk.Separator (Gtk.Orientation.VERTICAL);
        vertical_separator.set_opacity (0);
        
        // Then we create a new Grid and set its spacing properties
        var grid = new Gtk.Grid () {
            column_spacing = 6,
            row_spacing = 6
        };
        
        // Finally, we attach those widgets to the Grid.
        // Attach first row of widgets --> attach (column, row, width. height)
        grid.attach (hello_button, 1, 0, 1, 1);
        grid.attach (hello_label, 2, 0, 1, 1);
        
        // Attach second row of widgets
        grid.attach (goodbye_button, 1, 2);
        grid.attach_next_to (
            goodbye_label, // Put this objet
            goodbye_button, // In reference to this objet
            Gtk.PositionType.BOTTOM, // To which side of referenced widget
            1, 1 // Size of the target widget
        );
        grid.attach (vertical_separator, 0, 0, 1, 9);
        
        
        // Badges and Progress bars
        var badge_button = new Gtk.Button.with_label ("Show badge");
        badge_button.clicked.connect (() => {
            Granite.Services.Application.set_badge_visible.begin (true);
            Granite.Services.Application.set_badge.begin (12);
        });
        
        grid.attach (badge_button, 2, 3, 1, 1);
        
        var progress_button = new Gtk.Button.with_label ("Show progressbar");
        progress_button.clicked.connect (() => {
            Granite.Services.Application.set_progress_visible.begin (true);
            Granite.Services.Application.set_progress.begin (0.2f);
        });
        
        grid.attach_next_to (
            progress_button,
            badge_button,
            Gtk.PositionType.RIGHT, // To which side of widget
            1, 1
        );
        
        end_box.append (grid);
        
        // Test GSettings to save the state of this switch
        // and the main_window size and position.
        // Commonly settings object goes at the beginning of activate () method
        var settings = new GLib.Settings ("com.github.libredeb.gtk-hello");
        
        var useless_switch = new Gtk.Switch () {
            halign = CENTER,
            valign = CENTER
        };
        
        grid.attach_next_to (
            useless_switch,
            goodbye_button,
            Gtk.PositionType.RIGHT,
            1, 1
        );
        
        settings.bind ("useless-setting", useless_switch, "active", DEFAULT);
        // --------------------------------------------------------------------
        
        // Using the user's style preference (light or dark)
        // First we get the default instances for Granite.Settings and Gtk.Settings
        var granite_settings = Granite.Settings.get_default ();
        var gtk_settings = Gtk.Settings.get_default ();
        
        // Then, we check if the user's preference is for the dark style and set it if it is
        gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;

        // Finally, we listen to changes in Granite.Settings and update our app if the user changes their preference
        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK;
        });
        // --------------------------------------------------------------------
        
        var panel = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
            start_child = start_box,
            end_child = end_box,
            resize_start_child = false,
            shrink_end_child = false,
            shrink_start_child = false
        };
        
        var main_window = new Gtk.ApplicationWindow (this) {
            child = panel,
            title = "My App",
            default_width = settings.get_int ("window-width"),
            default_height = settings.get_int ("window-height"),
            titlebar = new Gtk.Grid () { visible = false }
        };
        
        main_window.close_request.connect (() => {
            int w, h;
            
            w = main_window.get_width ();
            h = main_window.get_height ();
            
            settings.set_int ("window-width", w);
    		settings.set_int ("window-height", h);
    		
    		return false;
        });
        
        main_window.present ();
    }
    
    public static int main (string[] args) {
        stdout.printf (_("Starting My App...\n"));
        return new MyApp ().run (args);
    }
}
