# libui.cr

Crystal-lang bindings for [libui](https://github.com/andlabs/libui), a GUI library for Linux, OS X and Windows.

(well, forget about Windows for now, this is Crystal)

![OS X](https://raw.githubusercontent.com/andlabs/libui/master/examples/controlgallery/darwin.png)

## What's New

06/19/16
- Sync'd to upstream #9656a81
- Control Gallery example not updated but library is.

## Installation

Add these package to your dependencies in shard.yml:

    dependencies:
      libui:
        github: fusion/libui.cr


## Usage

Have a look at src/examples/controlgallery, which is a direct port of a C example.

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
