#! /usr/bin/env ruby

require 'optparse'
require 'ruby-nessus'

time = Time.new

ARGV << '-h' if ARGV.empty?

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: nessusploitable.rb [options] [path]"
  opts.on('-p', '--print', 'Print to stdout and exit. Requires the -f option.') { |v| options[:print] = v }
  opts.on('-f', '--file PATH', 'File path for a single file.') { |v| options[:file_path] = v }
  opts.on('-d', '--directory PATH', 'Directory path to import multiple .nessus files.') { |v| options[:dir_path] = v }
  opts.on('-h', '--help', "Prints help") do
    puts "Nessusploitable - Parses Nessus .nessus files for exploitable vulnerabilities and prints to stdout or outputs a report file in TSV format for Excel"
    puts "Import the report data into Excel in Tab Separated Values format."
    puts "Author: Steve Campbell, @lpha3ch0"
    puts opts
    exit
  end
end.parse!

if options[:print]
  if not options.include?(:file_path)
    puts "You must include a file path ( -f or --file option ). Exiting"
    puts ""
    puts opts
  end
  nessus = RubyNessus::Parse.new("#{options[:file_path]}")
  puts "IP Address".ljust(15) + "\t" + "Hostname".ljust(30) + "\t" + "Port".ljust(25) + "\t" + "Exploit"
  nessus.scan.each_host do |host|
    host.each_event do |event|
      if event.exploit_framework_metasploit || event.exploitability_ease == "No exploit is required"
        if host.hostname.nil?
          hostname = ""
        else
          hostname = host.hostname
        end
        puts "#{host.ip.ljust(15)}\t#{hostname.ljust(30)}\t##{event.port.to_s.ljust(25)}\t#{event.name}"
      end
    end
  end
  exit
end

if options[:dir_path]
  File.open("#{time.month}-#{time.day}-#{time.year}-#{time.hour}-#{time.minute}-#{time.second}-nessus.csv", 'w') do |file|
    file.puts "Risk\tHost IP\tHostname\tPort\tName\tMetasploit Module\tReferences"
    Dir.glob("#{options[:dir_path]}/*.nessus").each do |n|
      ness = RubyNessus::Parse.new(n)
      ness.scan.each_host do |host|
        host.each_event do |event|
          if event.exploitability_ease == "No exploit is required"
            file.puts "#{event.risk}\t#{host.ip}\t#{host.hostname}\t#{event.port}\t#{event.name}\t#{event.metasploit_name}\t#{event.see_also}"
          elsif event.exploitability_ease == "Exploits are available"
            file.puts "#{event.risk}\t#{host.ip}\t#{host.hostname}\t#{event.port}\t#{event.name}\t#{event.metasploit_name}\t#{event.see_also}"
          end
        end
      end
    end
  end
elsif options[:file_path]
  File.open("#{time.month}-#{time.day}-#{time.year}-#{time.hour}-#{time.min}-#{time.sec}-nessus.csv", 'w') do |file|
    file.puts "Risk\tHost IP\tHostname\tPort\tName\tMetasploit Module\tReferences"
    ness = RubyNessus::Parse.new("#{options[:file_path]}")
    ness.scan.each_host do |host|
      host.each_event do |event|
        if event.exploitability_ease == "No exploit is required"
          file.puts "#{event.risk}\t#{host.ip}\t#{host.hostname}\t#{event.port}\t#{event.name}\t#{event.metasploit_name}\t#{event.see_also}"
        elsif event.exploitability_ease == "Exploits are available"
          file.puts "#{event.risk}\t#{host.ip}\t#{host.hostname}\t#{event.port}\t#{event.name}\t#{event.metasploit_name}\t#{event.see_also}"
        end
      end
    end
  end
end
