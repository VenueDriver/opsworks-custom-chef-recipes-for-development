#!/usr/bin/ruby

# How many minutes will an idle system be allowed to live?
idle_seconds = 60 * 60

# The file used as a signal to indicate when to kill the instance.
filename = '/tmp/kill-me-now'

def log string
  open('/tmp/kill-me-now.log', 'a') { |f| f.puts "#{Time.now} - " + string }
end

if `w -h | wc -l`.to_i <= 0
  if File.exist?(filename)
    # If file is older than the time limit.
    if (Time.now - File.ctime(filename) >= idle_seconds)
      log "SHUTDOWN!!  Limit: #{idle_seconds}  Kill file age: #{Time.now - File.ctime(filename)}"
      `/sbin/shutdown -h now`
    else
      log "File age: #{Time.now - File.ctime(filename)}  To go: #{idle_seconds - (Time.now - File.ctime(filename))}"
    end
  else
    log "No users logged in.  Creating kill file.  Limit: #{idle_seconds}"
    `touch #{filename}`
  end
else
  log "User logged in.  Removing kill file."
  `rm #{filename}` if File.exist?(filename)
end
