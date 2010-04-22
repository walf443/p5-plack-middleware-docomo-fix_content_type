use strict;
use warnings;
use Test::More;
use Plack::Test;
use Plack::Builder;
use HTTP::Request;

subtest 'total testing' => sub {
    test_psgi(
        app => sub {
            my $env = shift;
            my $app = builder {
                enable 'Lint';
                enable 'DoCoMo::FixContentType';
                enable 'Lint';
                sub {
                    my $env = shift;
                    return [ 200, [ 'Content-Type' => 'text/html; charset=Shift_JIS' ], [] ];
                }
            };
            $app->($env);
        },
        client => sub {
            my $cb = shift;
            subtest 'access from docomo' => sub {
                my $req = HTTP::Request->new(GET => 'http://localhost/test');
                $req->header('User-Agent' => 'DoCoMo/2.0 L06A(c100;TB;W24H15) (c1000;TB;W24H12)');
                my $res = $cb->($req);
                is($res->header('Content-Type'), 'application/xhtml+xml; charset=Shift_JIS', 'should convert text/html to application/xhtml+xml');

                done_testing();
            };

            subtest 'access from not docomo agent' => sub {
                my $req = HTTP::Request->new(GET => 'http://localhost/test');
                $req->header('User-Agent' => 'KDDI-SA31 UP.Browser/6.2.0.7.3.129 (GUI) MMP/2.0');
                my $res = $cb->($req);
                is($res->header('Content-Type'), 'text/html; charset=Shift_JIS', 'should not convert');

                done_testing();
            };
        },
    );

    done_testing();
};

done_testing();

