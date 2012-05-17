use strict;
use warnings;
use FindBin::libs;
use File::Spec;
use Image::libsiftfast;
use Data::Dumper;

my $image_file = File::Spec->catfile( $FindBin::RealBin, "lena_std.jpg" );

my $sift           = Image::libsiftfast->new;
my $pnm_file       = $sift->convert_to_pnm($image_file);
my $feature_points = $sift->extract_features($pnm_file);

print Dumper $feature_points;