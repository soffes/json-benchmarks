# iOS JSON Benchmarks

This is the code I used to write [my post about JSON benchmarks](http://samsoff.es/post/iphone-json-benchmarks) and [my updated post](http://samsoff.es/posts/updated-iphone-json-benchmarks).

There is basic UI for this app. Pretty charts might be cool in the future though. View the log for detailed results.

## Results Summary

Last updated 10/15/2010

The frameworks ranked reading in this order: [JSONKit][], [YAJL][], [Apple JSON][], [JSON Framework][], and [TouchJSON][].

Writing ranked in this order: [JSONKit][], [JSON Framework][], [Apple JSON][], [YAJL][], and [TouchJSON][].

For detailed time results, run the app on a device.

## Building

You will need iOS 4.0 or greater to build the application since it uses blocks. You will also need to get the submodules with the following command:

    $ git submodule update --init

Then simply open the project and build normally.

## Thanks

Huge thanks to [Stig Brautaset](http://github.com/stig) for improving benchmarking and keeping [JSON Framework][] up to date. Thanks to [Jonathan Wight](http://github.com/schwa) for keeping [TouchJSON][] up to date.

[Apple JSON]: http://samsoff.es/posts/parsing-json-with-the-iphones-private-json-framework
[TouchJSON]: http://github.com/schwa/TouchJSON
[JSON Framework]: http://github.com/stig/json-framework
[YAJL]: http://github.com/gabriel/yajl-objc
[JSONKit]: http://github.com/johnezang/JSONKit
