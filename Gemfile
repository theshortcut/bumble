GIT_PROTOCOL = ENV['http_proxy'] ? 'http' : 'git'

source 'http://rubygems.org/'

gem 'rails',               :git => "#{GIT_PROTOCOL}://github.com/rails/rails.git"
gem 'arel',                :git => "#{GIT_PROTOCOL}://github.com/rails/arel.git"

gem 'will_paginate',       :git => "#{GIT_PROTOCOL}://github.com/mislav/will_paginate.git",
                           :branch => 'rails3'

gem 'loofah',              :git => "#{GIT_PROTOCOL}://github.com/phaza/loofah.git",
                           :branch => 'rails3'

gem 'thinking-sphinx',     :git => "#{GIT_PROTOCOL}://github.com/freelancing-god/thinking-sphinx.git",
                           :branch => 'rails3',
                           :require => 'thinking_sphinx'

gem 'whenever',            :git => "#{GIT_PROTOCOL}://github.com/rlivsey/whenever.git",
                           :branch => 'rails3'

gem 'inherited_resources', :git => "#{GIT_PROTOCOL}://github.com/josevalim/inherited_resources.git"
gem 'authlogic',           :git => "#{GIT_PROTOCOL}://github.com/scrum8/authlogic.git"
gem 'feedzirra',           :git => "#{GIT_PROTOCOL}://github.com/pauldix/feedzirra.git"
gem 'is_paranoid',         :git => "#{GIT_PROTOCOL}://github.com/theshortcut/is_paranoid.git"

gem 'gravtastic',        '2.2.0'
gem 'scrobbler',         '0.2.3'
gem 'bluecloth',         '2.0.7'
gem 'haml',              '3.0.12'
gem 'sitemap_generator', '0.3.3'
gem 'mysql'

group :test do
  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end
