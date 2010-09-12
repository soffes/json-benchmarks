# iOS JSON Benchmarks

This is the code I used to write [my post about JSON benchmarks](http://samsoff.es/post/iphone-json-benchmarks) and [my updated post](http://samsoff.es/posts/updated-iphone-json-benchmarks).

This is a pretty primitive way to benchmark stuff, but it works for what I'm doing. There is no UI for this app. Just look at the console.

## Summary

The frameworks ranked reading in this order: [JSONKit][], [Apple JSON][], [YAJL][], [JSON Framework][], and [TouchJSON][].

Writing ranked in this order: [JSONKit][], [JSON Framework][], [Apple JSON][], [YAJL][], and [TouchJSON][].

## Detailed Results

Here are the results as of September 12, 2010 running on a 16GB 1st Gen iPad running iOS 3.2.2 (7B500). Revision for the respective libraries are specified below.

### [JSONKit][]

At revision [c9ffd8f823e68df96fa2](http://github.com/johnezang/JSONKit/commit/c9ffd8f823e68df96fa2f87185bee861984ef637)

**Average read:** 0.006731 seconds

**Average write:** 0.006809 seconds

### [Apple JSON][]

Version bundled with iOS 3.2.2

**Average read:** 0.015801 seconds

**Average write:** 0.017987 seconds

### [YAJL][]

At revision [f2a948a0509d8e423e31](http://github.com/gabriel/yajl-objc/commit/f2a948a0509d8e423e312972e1dbaeb10150c776)

**Average read:** 0.019490 seconds

**Average write:** 0.026230 seconds

### [JSON Framework][]

At revision [afa87b16b385383fcdc0](http://github.com/stig/json-framework/commit/afa87b16b385383fcdc07822da84dece8084b88f)

**Average read:** 0.020877 seconds

**Average write:** 0.016982 seconds

### [TouchJSON][]

At revision [ed94707e76bbe38452a3](http://github.com/schwa/TouchJSON/commit/ed94707e76bbe38452a320a00f9464674e061f60)

**Average read:** 0.036283 seconds

**Average write:** 0.085583 seconds

[Apple JSON]: http://samsoff.es/posts/parsing-json-with-the-iphones-private-json-framework
[TouchJSON]: http://github.com/schwa/TouchJSON
[JSON Framework]: http://github.com/stig/json-framework
[YAJL]: http://github.com/gabriel/yajl-objc
[JSONKit]: http://github.com/johnezang/JSONKit
