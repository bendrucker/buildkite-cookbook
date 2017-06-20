name 'buildkite'
version '1.0.4'

description 'Installs and configures the buildkite agent'

maintainer 'Ben Drucker'
maintainer_email 'bvdrucker@gmail.com'

license 'MIT'

issues_url 'https://github.com/bendrucker/buildkite-cookbook/issues'
source_url 'https://github.com/bendrucker/buildkite-cookbook'

supports 'ubuntu'
supports 'windows'

chef_version '>= 12'

depends 'apt', '>= 6.1'
depends 'git', '~> 6.1.0'
depends 'windows', '~> 3.1.0'
depends 'winsw', '~> 1.2.2'
