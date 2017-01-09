name 'buildkite'
version '1.0.1'

description 'Installs and configures the buildkite agent'

maintainer 'Ben Drucker'
maintainer_email 'bvdrucker@gmail.com'

license 'MIT'

issues_url 'https://github.com/bendrucker/buildkite-cookbook/issues'
source_url 'https://github.com/bendrucker/buildkite-cookbook'

supports 'ubuntu'
supports 'windows'

depends 'apt', '~> 5.0.0'
depends 'git', '~> 5.0.1'
depends 'windows', '~> 2.1.1'
depends 'winsw', '~> 0.3'
