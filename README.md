# libui.cr

Crystal-lang bindings for [libui](https://github.com/andlabs/libui), a GUI library for Linux, OS X and Windows.

(well, forget about Windows for now, this is Crystal)

## Installation

Add these package to your dependencies in shard.yml:

    dependencies:
      libui:
        github: fusion/libui.cr


## Usage

Have a look at src/examples/controlgallery, which is a direct port of a C example.

## Bugs

At the moment, on OS X, the example will cause a crash when exiting.
This unfortunate behavior exists in the original C library so we will have to wait for a fix.

## Development

Recent versions of Crystal now require you to include the current path explicitely to find libraries:

   crystal build --link-flags "-L$(PWD)" src/<your code>

At least on OS X, if you omit this flag, libui.A.dylib will not be found.

## Contributing

1. Fork it ( https://github.com/fusion/libui.cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[fusion]](https://github.com/fusion) Chris F Ravenscroft - creator, maintainer
