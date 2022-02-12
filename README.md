# gtk-hello

An example GTK+ app saying Hello!

## How to Run?

1. **Install Dependencies**

First you need is to install dependencies in your system. For example, in ubuntu you can run the following command:
```bash
$ sudo apt-get install build-essential make cmake meson valac libgtk-3-dev gettext gobject-introspection libgee-0.8-dev libgirepository1.0-dev libglib2.0-dev libgranite-dev libxml2-dev valadoc
```

2. **Compile the source code**

Then, you want to generate a binary executable file... to do this, compile the source with the next command:
```bash
$ valac --pkg gtk+-3.0 src/Application.vala
```

3. **Run the app**

To execute the app you can run this command:
```bash
$ ./Application
```
