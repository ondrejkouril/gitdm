#!/usr/bin/env ruby
require 'csv'
require 'digest'

def add_forbidden_data1(args)
  # Read currently forbidden list
  config_file = 'cncf-config/forbidden-sha1.csv'
  shas = {}
  begin
    CSV.foreach(config_file, headers: true) do |row|
      h = row.to_h
      sha = h['sha']
      shas[sha] = true
      puts "Already forbidden SHA1: '#{sha}'"
    end
  rescue Errno::ENOENT => e
    puts "No forbidden config yet, ok"
  end

  # Process new forbidden list
  sha1 = Digest::SHA1.new
  added = false
  args.each do |argo|
    arg = argo.strip
    sha = sha1.hexdigest arg
    if shas.key? sha
      puts "This is already forbidden value: '#{arg}' --> SHA1: '#{sha}', skipping"
      next
    end
    puts "Adding value '#{arg}' --> SHA1: '#{sha}' to forbidden list"
    shas[sha] = true
    added = true
  end
  return unless added

  # Save new forbidden file (we added something)
  hdr = %w(sha)
  CSV.open(config_file, 'w', headers: hdr) do |csv|
    csv << hdr
    shas.keys.sort.each do |sha|
      csv << [sha]
    end
  end
end

def add_forbidden_data256(args)
  # Read currently forbidden list
  config_file = 'cncf-config/forbidden-sha256.csv'
  shas = {}
  begin
    CSV.foreach(config_file, headers: true) do |row|
      h = row.to_h
      sha = h['sha']
      shas[sha] = true
      puts "Already forbidden SHA256: '#{sha}'"
    end
  rescue Errno::ENOENT => e
    puts "No forbidden config yet, ok"
  end

  # Process new forbidden list
  sha256 = Digest::SHA256.new
  added = false
  args.each do |argo|
    arg = argo.strip
    sha = sha256.hexdigest arg
    if shas.key? sha
      puts "This is already forbidden value: '#{arg}' --> SHA256: '#{sha}', skipping"
      next
    end
    puts "Adding value '#{arg}' --> SHA256: '#{sha}' to forbidden list"
    shas[sha] = true
    added = true
  end
  return unless added

  # Save new forbidden file (we added something)
  hdr = %w(sha)
  CSV.open(config_file, 'w', headers: hdr) do |csv|
    csv << hdr
    shas.keys.sort.each do |sha|
      csv << [sha]
    end
  end
end

if ARGV.size < 1
  puts "Missing arguments: email1@doma2.com 'Hidden Name' anything_that_should_not_appear_in_repo"
  exit(1)
end

add_forbidden_data1(ARGV)
add_forbidden_data256(ARGV)
