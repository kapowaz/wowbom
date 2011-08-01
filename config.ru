require 'resque/server'
require './application'

Wowbom.disable :run

use HireFireApp::Middleware
map('/') { run Wowbom }
map('/resque') { run Resque::Server }