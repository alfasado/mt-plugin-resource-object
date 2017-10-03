package ResourceObject::Tags;

use strict;
use warnings;

{
    package MT::App::CMS;
    sub current_api_version { return MT->request( 'data_api_current_version' ) }
}

{
    package MT;
    sub current_api_version { return MT->request( 'data_api_current_version' ) }
    sub user {
        use File::Basename;
        if ( dirname($0) eq 'tools' ) {
            return MT::Author->anonymous;
        }
    }
}

sub _hdlr_resource_object {
    my ( $ctx, $args, $cond ) = @_;
    my $model = $args->{ model } || $args->{ stash } || 'entry';
    my $version = $args->{ version } || 3;
    MT->request( 'data_api_current_version', $version );
    my $id = $args->{ id };
    my $obj;
    if ( $id ) {
        $obj = MT->model( $model )->load( $id );
    } else {
        $obj = $ctx->stash( $model );
    }
    if (! $obj ) {
        return '{}';
    }
    require MT::DataAPI::Resource;
    my $res = MT::DataAPI::Resource->from_object( $obj ) || return '{}';
    require MT::DataAPI::Format::JSON;
    return MT::DataAPI::Format::JSON::serialize( $res );
}

1;