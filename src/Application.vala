public class GtkHello : Gtk.Application {

    public GtkHello() {
        Object (
            application_id: "com.github.libredeb.gtk-hello",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    
    protected override void activate () {
        var main_window = new Gtk.ApplicationWindow (this) {
            default_height = 300,
            default_width = 300,
            title = "Gtk Hello"
        };
        
        var button_hello = new Gtk.Button.with_label ("Click me!") {
            margin = 12
        };
        
        button_hello.clicked.connect (() => {
            button_hello.label = "Hello World!";
            button_hello.sensitive = false;
        });
        
        main_window.add (button_hello);
        main_window.show_all ();
    }
    
    public static int main (string[] args) {
        return new GtkHello ().run (args);
    }

}
