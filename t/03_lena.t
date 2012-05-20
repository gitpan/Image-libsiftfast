use strict;
use warnings;
use Image::libsiftfast;
use Test::More tests => 3;
use FindBin::libs;
use File::Spec;
use Data::Dumper;

my $jpeg
    = File::Spec->catfile( $FindBin::RealBin, "../sample", "lena_std.jpg" );

my $sift = Image::libsiftfast->new;
my $pnm  = $sift->convert_to_pnm($jpeg);
is( $pnm,
    File::Spec->catfile( $FindBin::RealBin, "../sample", "lena_std.pnm" ) );

my $data = $sift->extract_keypoints($pnm);
is( $data->{keypoint_num}, int @{ $data->{keypoints} } );
is( $data->{image_size},   '512x512' );
