require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require "bundler/gem_tasks"

# http://blog.zachallett.com/pry-reload/
#
# I should gemify this later.
task :console do
  require 'pry'
  require 'tak'

  # http://stackoverflow.com/questions/9236264/how-to-disable-warning-for-redefining-a-constant-when-loading-a-file
  def silence_warnings(&block)
    warn_level, $VERBOSE = $VERBOSE, nil

    result   = block.call
    $VERBOSE = warn_level

    result
  end

  # Modified a bit to silence some constant reload warnings
  # and to return a true or the error.
  def reload!
    !!silence_warnings do
      $LOADED_FEATURES
        .select { |feat| feat =~ /\/tak\// }
        .each { |file| load file }
    end
  rescue => e
    e
  end

  ARGV.clear
  Pry.start
end
