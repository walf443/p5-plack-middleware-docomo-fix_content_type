package Plack::Middleware::DoCoMo::FixContentType;

use strict;
use warnings;
our $VERSION = '0.01';

use parent 'Plack::Middleware';
use Plack::Util;

# this regex copied from HTTP::MobileAgent
# don't use HTTP::MobileAgent for performance.
our $DOCOMO_RE = qr{^DoCoMo/\d\.\d[ /]}; 

sub call {
    my ($self, $env) = @_;

    my $res = $self->app->($env);
    # This middleware only work for DoCoMo.
    # Don't consider xhtml_compliant. 
    # If you care about this, use enable_if and HTML::MobileAgent::DoCoMo->xhtml_compliant.
    if ( $env->{USER_AGENT} && $env->{USER_AGENT} =~ $DOCOMO_RE ) { 
        my $content_type = Plack::Util::header_get($res->[1], 'Content-Type');
        if ( $content_type =~ m{^text/html} ) {
            $content_type =~ s{^text/html}{application/xhtml+xml}i;
            Plack::Util::header_set($res->[1], 'Content-Type', $content_type);
        }
    }

    return $res;
}

1;
__END__

=head1 NAME

Plack::Middleware::DoCoMo::FixContentType - rewrite Content-Type header text/html to application/xhtml+xml

=head1 SYNOPSIS

    use Plack::Builder;
    bulider {
        enable 'DoCoMo::FixContentType';
        $app;
    };

=head1 DESCRIPTION

Plack::Middleware::DoCoMo::FixContentType is

=head1 AUTHOR

Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

