ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => ENV.fetch("DATABASE_PASSWORD", ""),
  :database => ENV.fetch("DATABASE_NAME", "recruiter_index_development")
)
