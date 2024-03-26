#!/usr/bin/env ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

class SetupDev
    attr_accessor :pids
  
    def initialize
      self.pids = []
    end
  
    def run
      prerequisite
      configure
      bundle_and_prepare_db_and_npm_api
      wait
    end
  
    def quit
      p %i[install_dev quit]
  
      pids.each do |pid|
        Process.kill("TERM", pid)
      rescue StandardError
        nil
      end
      begin
        Timeout.timeout(5) do
          pids.each { |pid| Process.wait(pid) }
        end
      rescue StandardError
      end
  
      pids.each { |pid| Process.kill("KILL", pid) if pid_alive?(pid) }
    end
  
    def prerequisite
      system "gem install bundler" unless system("which bundle")
    end
  
    def configure
    end
  
    def wait
      pids.each { |pid| Process.wait(pid) }
    end
  
    def make_application_yml
      pids << fork do
        system "cp config/application.example.yml config/application.yml" unless File.exist?("config/application.yml")
      end
    end
  
    def bundle_and_prepare_db_and_npm_api
      pids << fork do
        pid1 = fork do
          system "bundle install --with=development --with=test"
        end
  
        Process.wait(pid1)
  
        pid2a = fork do
          migrate_or_boostrap_db
        end
  
        pid2b = fork do
          system "cd funny_movie_fe && npm install"
        end
  
        Process.wait(pid2a)
        Process.wait(pid2b)
      end
    end
  
    def migrate_or_boostrap_db
      result = `spring rails db:migrate 2>&1`
      if result.include?("ActiveRecord::NoDatabaseError")
        system "spring rails db:setup db:test:prepare"
      end
    end

  
    def pid_alive?(pid)
      Process.getpgid(pid)
      true
    rescue Errno::ESRCH
      false
    end
  end
  
  setup_dev = SetupDev.new
  
  trap("SIGINT") { throw :ctrl_c }
  
  catch :ctrl_c do
    setup_dev.run
  rescue SignalException => e
    p [:signal_exception, e]
    setup_dev.quit
  end
  
  setup_dev.quit
  