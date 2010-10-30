package RelativeURL::Plugin;

use strict;
use MT;
#use MT::Plugin;
use MT::Template::Context;

sub _relative_url_version {
    my ( $ctx, $args ) = @_;
#    my $plugin = MT->component("RelativeURL");
#    my $version = $plugin->version;
    my $version = '1.0.1';
    return $version;
}

sub _relative_url_base {
    my($ctx, $args, $cond) = @_;
	defined(my $url = $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond))
		or return;
	return $ctx->error("The specified URL '$url' does not begin with http:// or https://")
		unless !$url || $url =~ m|^https?://|;

	$ctx->stash('MTRelativeURLBase', $url);
	"";
}

sub _relative_url {
    my($ctx, $args, $cond) = @_;
	my $url = $ctx->stash('builder')->build($ctx, $ctx->stash('tokens'), $cond)
		or return;
	return _filter_relative_url($url, $args->{base_url} || 1, $ctx);
}

sub _filter_relative_url {
    my($url, $base_url, $ctx) = @_;
	my $blog = $ctx->stash('blog')
		or return $ctx->error("Outside the context of a blog");

	$base_url = $ctx->stash('MTRelativeURLBase') || '' if $base_url eq '1';

	if($base_url =~ m|^https?://|) {
		## Try to build relative URI (i.e. "../index.htm")
		my ($base_site, $url_site);
		## Make sure URI is not empty (i.e. "http://www.foo.com" shoul be "http://www.foo.com/"
		$url .= "/" if $url =~ m|^https?://[^/]+$|;
		$base_url .= "/" if $base_url =~ m|^https?://[^/]+$|;
		## Extract host info (i.e. "http://www.foo.com" or "http://www.foo.com:8080"
		($base_site) = $base_url =~ m|(https?://[^/]+)|;
		($url_site) = $url =~ m|(https?://[^/]+)|;
		## Make sure url points to same server/port
		return $url if(!$base_site or $base_site ne $url_site);
		## Strip file name of base URL
		$base_url =~ s|[^/]*$||;
		## Convert to path chunks
		my @base = split(/\//, $base_url);
		my @url = split(/\//, $url);
		my $relative = '';
		## Build relative path
		while (1) {
			my ($base_chunk, $url_chunk) = (shift @base, shift @url);
			if(defined $base_chunk) {
				if (!defined $url_chunk) {
					$relative = "../$relative";
				} elsif ($base_chunk ne $url_chunk) {
					$relative .= "/" if $relative;
					$relative = "../$relative$url_chunk";
				}
			} elsif(defined $url_chunk) {
				$relative .= "/" if $relative;
				$relative .= "$url_chunk";
			} else {
				last;
			}
		}
		$url = $relative;
	} else {
		## Use blog's site as base URL and return full URI (i.e. "/journal/index.htm")
		my ($site, $relative);
		($site) = $blog->site_url =~ m|^(https?://[^/]+)|;
		($relative) = $url =~ m|^$site(/.*)| if $site;
		$url = $relative if $relative;
	}

	return $url;
}

sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);
    require MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

1;
