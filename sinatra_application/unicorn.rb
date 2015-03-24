# set path to app that will be used to configure unicorn,
# note the trailing slash in this example
@dir = File.join(File.dirname(__FILE__), '../current')

worker_processes 2
working_directory @dir

timeout 30

# Specify path to socket unicorn listens to,
# we will use this in our nginx.conf later
listen "/var/dev-io/sockets/unicorn.sock", :backlog => 64

# Set process id path
pid "/var/dev-io/tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "/var/dev-io/log/unicorn.stderr.log"
stdout_path "/var/dev-io/log/unicorn.stdout.log"
