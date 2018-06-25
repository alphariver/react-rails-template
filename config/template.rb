remove_file "config/database.yml"
template "config/database.yml.tt"
copy_file "config/initializers/generators.rb"

if apply_capistrano?
    template "config/deploy.rb.tt"
    template "config/deploy/production.rb.tt"
    template "config/database.production.yml.tt"
end