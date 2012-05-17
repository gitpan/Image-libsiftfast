package Image::libsiftfast;
use strict;
use warnings;
use Data::Dumper;
use Imager;

our $VERSION = '0.01_01';

sub new {
    my $class = shift;
    my $self = bless {@_}, $class;
    $self->{siftfast_path} ||= 'siftfast';
    $self->{imager} = Imager->new;
    return $self;
}

sub convert_to_pnm {
    my $self = shift;
    my $file = shift;

    my $imager = $self->{imager};
    $imager->read( file => $file ) or die $imager->errstr;
    my $new = $imager->convert( preset => 'grey' );
    $file =~ s/jpg/pnm/;
    $new->write( file => $file, type => "pnm", pnm_write_wide_data => 1 )
        or die($!);
    return $file;
}

sub extract_features {
    my $self     = shift;
    my $pnm_file = shift;

    my $siftfast_path = $self->{siftfast_path};
    my @stdout = `$siftfast_path < $pnm_file 2>&1`;

    my $stderr_message = shift @stdout;
    $stderr_message .= shift @stdout;

    my @array = map { chomp $_; $_ } @stdout;
    shift @array;    # remove first line;
    my $return_string = join( "\n", @array );

    my @feature_vectors;
    for ( split "\n\n", $return_string ) {
        my @rec = split "\n", $_;
        my @array;
        for (@rec) {
            my @f = split " ", $_;
            push @array, @f;
        }
        my $X           = shift @array;
        my $Y           = shift @array;
        my $scale       = shift @array;
        my $orientation = shift @array;
        my $vector      = \@array;

        push @feature_vectors,
            {
            frames => {
                X           => $X,
                Y           => $Y,
                scale       => $scale,
                orientation => $orientation,
            },
            vector => $vector,
            };
    }
    return \@feature_vectors;

}

1;
__END__

=head1 NAME

Image::libsiftfast - perl wrapper of siftfast command

=head1 SYNOPSIS

  use Image::libsiftfast;

  my $sift            = Image::libsiftfast->new;
  my $feature_vectors = $sift->extract_features("test.pnm");

=head1 DESCRIPTION

Image::libsiftfast is a siftfast command wrapper.


=head1 AUTHOR

Takeshi Miki E<lt>miki@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
