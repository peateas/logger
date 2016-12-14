require 'log4r'
include Log4r

Given(/^no existing log files for a name$/) do
  unless defined?($start)
    if File.exists?('default.log')
      File.rename('default.log', "default#{Time.now.strftime('-%1y%2m%2d-%2H%2M-%2S%3N')}.log")
    end
    $start=true
  end
end

Given /^some running code that wants to log to a name$/ do
  @name = 'test309'
  @logger = Log4r::Logger.new(@name)
  @console = StderrOutputter.new(:console)
  @default = FileOutputter.new(:default, :filename => 'default.log')
  @console.level=WARN
  @logger.add(@console, @default)
end

When(/^the code warns about something$/) do
  @warning = "please listen to this warning at #{Time.now}"
  @logger.warn(@warning)
end

When(/^the code informs us about something$/) do
  @message = "please listen to this message at #{Time.now}"
  @logger.info(@message)
end

Then(/^I (do|do not) see (information|warning) in the (console|.* log)$/) do |no, message, where|
  case message
    when 'warning'
      message = @warning
    when 'information'
      message = @message
    else
      raise 'should be able to get here'
  end
  case where
    when 'console'
      case no
        when 'do'
          puts("you should see a log for '#{message}' on the console")
        when 'do not'
          puts("you should not see a log for '#{message}' on the console")
        else
          raise 'should be able to get here'
      end
    else
      where =~ /(.*) log/
      filename = "#{$1}.log"
      expect(File).to exist(filename)
      found=false
      File.new(filename).each_line do |line|
        if line=~Regexp.new(Regexp.quote(message))
          found = true
          break
        else
          found = false
        end
      end
      case no
        when 'do'
          expect(found).to be(true), "#{message} not in log"
        when 'do not'
          expect(found).to be(false), "#{message} in log but shouldn't be"
        else
          raise 'should be able to get here'
      end
  end
end


