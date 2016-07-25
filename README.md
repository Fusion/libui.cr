# libui.cr

Crystal-lang bindings for [libui](https://github.com/andlabs/libui), a GUI library for Linux, OS X and Windows.

(well, forget about Windows for now, this is Crystal)

![OS X](https://raw.githubusercontent.com/andlabs/libui/master/examples/controlgallery/darwin.png)

## What's New

07/24/16
- Now with YAML builder

06/19/16
- Sync'd to upstream #9656a81
- Control Gallery example not updated but library is.

## Installation

Add these package to your dependencies in shard.yml:

    dependencies:
      libui:
        github: fusion/libui.cr


## Usage

### Standard (C-like) usage

Have a look at src/examples/controlgallery, which is a direct port of a C example.

### Crystal-only YAML builder

(see src/examples/crgallery)

This is a feature I am introducing in addition to the library bindings.
It allows devs to specify a UI without hard coding it and maintain it using 
fragments described in simple .yml files.

Some davantages:
- No need to recompile your code to test a UI change
- Team collaboration now easier
- Descriptive UI
- Separation of concerns

Obvious drawback:
- No compile-time checks

Note that inflating fragments and pure coding can be mixed.

#### API

    CUI.menubar "path_to_yml_file"

    CUI.inflate "path_to_yml_file"

    CUI.get/CUI.get!
    CUI.get_as_menuitem/CUI.get_as_menuitem!
    CUI.get_mainwindow/CUI.get_mainwindow!

The '!' forms will throw an exception if component is not found.

## Development

Recent versions of Crystal now require you to include the current path explicitely to find libraries:

    crystal build --link-flags "-L$(PWD)" src/examples/controlgallery/main.cr

At least on OS X, if you omit this flag, libui.A.dylib will not be found.

To run the generated binary:

    LD_LIBRARY_PATH=. ./main

## Contributing

1. Fork it ( https://github.com/fusion/libui.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[fusion]](https://github.com/fusion) Chris F Ravenscroft - creator, maintainer
