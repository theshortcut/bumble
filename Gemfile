GIT_PROTOCOL = ENV['http_proxy'] ? 'http' : 'git'

source 'http://rubygems.org/'

gem 'rails',             :git => "#{GIT_PROTOCOL}://github.com/rails/rails.git"
gem 'arel',              :git => "#{GIT_PROTOCOL}://github.com/rails/arel.git"

gem 'will_paginate',     :git => "#{GIT_PROTOCOL}://github.com/mislav/will_paginate.git",
                         :branch => 'rails3'

gem 'loofah',            :git => "#{GIT_PROTOCOL}://github.com/phaza/loofah.git",
                         :branch => 'rails3'

# gem 'whenever',          :git => "#{GIT_PROTOCOL}://github.com/javan/whenever.git",
#                          :branch => 'integration'

gem 'authlogic',         :git => "#{GIT_PROTOCOL}://github.com/scrum8/authlogic.git"
gem 'feedzirra',         :git => "#{GIT_PROTOCOL}://github.com/pauldix/feedzirra.git"

# gem 'thinking-sphinx',   '1.3.17'
gem 'gravtastic',        '2.2.0'
gem 'scrobbler',         '0.2.3'
gem 'bluecloth',         '2.0.7'
gem 'haml',              '3.0.12'
gem 'mysql',             '2.8.1'
gem 'sitemap_generator', '0.3.3'

group :test do
  gem 'shoulda'
  gem 'factory_girl'
  gem 'factory_girl_rails'
end
