package HTMLTemplate::Plugin;

use strict;
use warnings;

use MT::Util qw/ trim /;

sub convert_tags {
    my ($cb, %args) = @_;

    my $tmpl = $args{'template'};
    if ($tmpl && !$tmpl->build_dynamic) {

        my $blog = $args{'blog'};
        my $plugin = MT->component('HTMLTemplate');

        unless ($blog) {
            if (MT->config->DebugMode > 0) {
                MT->log({message => 'No blog context passed to HTMLTemplate::Plugin::convert_tags.'});
            }
            return;
        }

        my $tags = trim($plugin->get_config_value('html_template', 'blog:' . $blog->id));
        return unless $tags && $tags ne '';

        my @tags = ($tags =~ m/(\S+)/g);
        foreach my $tag (@tags) {
            my $html = ${$args{'content'}};
            $html =~ s!<(/?)$tag(if|loop|unless|else|var|include)\b!<$1TMPL_\U$2!ig;
            ${$args{'content'}} = $html;
        }
    }

1;