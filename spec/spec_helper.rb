# encoding: utf-8
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.join(File.dirname(__FILE__))
end

require 'ezcript'
