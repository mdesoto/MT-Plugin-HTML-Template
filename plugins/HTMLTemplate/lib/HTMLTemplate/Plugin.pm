# Copyright 2010 Michael De Soto. This program is distributed under the 
# terms of the GNU General Public License. Consult LICENSE for more information.

package HTMLTemplate::Plugin;

use strict;
use warnings;

use MT::Util qw/ trim /;

sub convert_tags {
    my ($cb, %args) = @_;

    my $blog = $args{'blog'};
    unless ($blog) {
        if (MT->config->DebugMode > 0) {
            MT->log({message => 'No blog context passed to HTMLTemplate::Plugin::convert_tags.'});
        }
        return;
    }

    my $plugin = MT->component('HTMLTemplate');
    if ($plugin->get_config_value('is_active', 'blog:' . $blog->id)) {

        my $tmpl = $args{'template'};
        if ($tmpl && !$tmpl->build_dynamic) {

            my $tags = trim($plugin->get_config_value('html_template', 'blog:' . $blog->id));
            return unless $tags && $tags ne '';

            my @tags = ($tags =~ m/(\S+)/g);
            foreach my $tag (@tags) {
                my $html = ${$args{'content'}};
                $html =~ s!<(/?)$tag(if|loop|unless|else|var|include)\b!<$1TMPL_\U$2!ig;
                ${$args{'content'}} = $html;
            }
        }
    }
}

1;