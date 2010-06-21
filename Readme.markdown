# iPhone JSON Benchmarks

This is the code I used to write [my post about JSON benchmarks](http://samsoff.es/post/iphone-json-benchmarks).

This is a pretty primitive way to benchmark stuff, but it works for what I'm doing. There is no UI for this app. Just look at the console.

## Summary

On both the iPad and iPod Touch, the frameworks ranked in this order: Apple JSON, YAJL, JSON Framework, and TouchJSON.

## Detailed Results

### iPad

Here are the results as of June 20, 2010 running on a 16GB 1st Gen iPad running iOS 3.2

#### Touch JSON 1.0.8

Average read: 0.037721 seconds
Average write: 0.090411 seconds


#### JSON Framework 2.2.3

Average read: 0.030266 seconds
Average write: 0.017024 seconds

#### YAJL 0.2.19

Average read: 0.021091 seconds
Average write: 0.027363 seconds

#### Apple's JSON.framework

Average read: 0.016789 seconds
Average write: 0.018917 seconds

### iPod Touch

Here are the results as of June 20, 2010 running on a 8GB 3rd Gen iPod Touch running iOS 3.1.3

#### Touch JSON 1.0.8

Average read: 0.142997 seconds
Average write: 0.388615 seconds


#### JSON Framework 2.2.3

Average read: 0.119305 seconds
Average write: 0.067417 seconds

#### YAJL 0.2.19

Average read: 0.075903 seconds
Average write: 0.108805 seconds

#### Apple's JSON.framework

Average read: 0.068048 seconds
Average write: 0.069958 seconds
