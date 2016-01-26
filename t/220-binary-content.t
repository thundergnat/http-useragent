#!perl6

use v6;

use Test;

use HTTP::UserAgent;
plan 4;

if %*ENV<NETWORK_TESTING> {
    my $ua = HTTP::UserAgent.new;
    subtest {
        my $res;
        lives-ok { $res = $ua.get("http://httpbin.org/image/jpeg") }, "getting image";
        is $res.media-type.type, 'image/jpeg', "and we actually got a JPEG";
        ok $res.is-binary, "and the result says it's binary";
        ok $res.content ~~ Blob, "and we got back a Blob";
        is $res.content.elems, ~$res.field('Content-Length'), "and got the right length";
    }, "get jpeg";
    subtest {
        my $res;
        lives-ok { $res = $ua.get("http://httpbin.org/image/png") }, "getting image";
        is $res.media-type.type, 'image/png', "and we actually got a PNG";
        ok $res.is-binary, "and the result says it's binary";
        ok $res.content ~~ Blob, "and we got back a Blob";
        is $res.content.elems, ~$res.field('Content-Length'), "and got the right length";
    }, "get png";
    subtest {
        my $res;
        lives-ok { $res = $ua.get("http://httpbin.org/stream-bytes/1024") }, "getting application/octet-stream";
        is $res.media-type.type, 'application/octet-stream', "and we actually got a bunch of bytes";
        ok $res.is-binary, "and the result says it's binary";
        ok $res.content ~~ Blob, "and we got back a Blob";
        is $res.content.elems, 1024, "and got the right length";
    }, "get octet-stream (chunked)";
    subtest {
        my $res;
        lives-ok { $res = $ua.get("http://httpbin.org/bytes/1024") }, "getting application/octet-stream";
        is $res.media-type.type, 'application/octet-stream', "and we actually got a bunch of bytes";
        ok $res.is-binary, "and the result says it's binary";
        ok $res.content ~~ Blob, "and we got back a Blob";
        is $res.content.elems, 1024, "and got the right length";
        is $res.content.elems, ~$res.field('Content-Length'), "and got the right length";
    }, "get octet-stream (not-chunked)";
}
else {
    skip-rest("'NETWORK_TESTING' not set not performing tests");
}


done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
