use inc::Module::Install;
name 'Image-libsiftfast';
all_from 'lib/Image/libsiftfast.pm';

requires 'Imager';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More', 'FindBin::libs';
auto_set_repository;
auto_include;
WriteAll;
