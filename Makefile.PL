use inc::Module::Install;
use Module::Install::ReadmeFromPod;
name 'Plack-Middleware-DoCoMo-FixContentType';
all_from 'lib/Plack/Middleware/DoCoMo/FixContentType.pm';
readme_from 'lib/Plack/Middleware/DoCoMo/FixContentType.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
build_requires 'Test::LoadAllModules';
build_requires 'Module::Install::ReadmeFromPod';
use_test_base;
auto_include;
WriteAll;
