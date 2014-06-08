# encoding: utf-8

require "ghrepo/version"
require "json"
require "io/console"

module Ghrepo

  extend self

  def start(args)
    $repo_name = args.pop

    if args.any?

      credentials = set_credentials(args)
      response = get_curl_response(credentials)
      $git_url = JSON.parse(response)[credentials[:url]]

      if curl_has_errors(response)
        show_curl_errors
      else

        if args.include?('-rails')
          include_rails(args)
        else
          create_repo(args)
        end

        add_html if args.include?('-html')
      end
    else
      much_dumb
    end
  end

  def create_repo(args)
    `git clone "#{$git_url}"`
  end

  def prompt_password
    print "password > "
    password = STDIN.noecho(&:gets).chomp
  end

  def set_url(args)
    ENV['GHREPO_SSH'] || args.include?('-ssh') ? 'ssh_url' : 'clone_url'
  end

  def set_username
    ENV['GHREPO_USERNAME'] || prompt_username
  end

  def prompt_username
    print "github username > "
    username = STDIN.gets.chomp
  end

  def set_password
    ENV['GHREPO_KEY'] || prompt_password
  end

  def set_credentials(args)
    {url: set_url(args), username: set_username, password: set_password}
  end

  def add_html
    app_dir = "./#{$repo_name}"
    latest_ghrepo_gem = (Dir.entries(ENV["GEM_HOME"] + "/gems")).select {|l| l.start_with?('ghrep')}.last
    html5_file = ENV["GEM_HOME"] += "/gems/" + latest_ghrepo_gem + "/lib/html5-boilerplate.html"
    Dir.chdir(app_dir)
    `cp #{html5_file} ./index.html`
    `git add .`
    `git commit -m "boilerplate html"`
    `git push -u origin master`
  end

  def include_rails(args)
    add_rails
    push_rails
  end

  def add_rails
    puts "\nbuilding your rails app...."
    `rails new "#{$repo_name}"`
    Dir.chdir($repo_name)
    `git init`
    `git remote add origin "#{$git_url}"`
  end

  def push_rails
    `git add .`
    `git commit -m "boilerplate rails"`
    `git push -u origin master`
  end

  def curl_has_errors(response)
    if JSON.parse(response)["errors"]
      return true
    end
  end

  def much_dumb
    puts "RTFM dummy!"
    puts <<-eos
    ░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░
    ░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░
    ░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░
    ░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░
    ░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░
    ░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░
    ░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░
    ░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░
    ░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░
    ░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░
    ▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░
    ▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
    ▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░
    ░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░
    ░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░
    ░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░
    ░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░
    ░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░
    ░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░
    eos
    puts "such moron very dumb"
  end

  def get_curl_response(credentials)
    `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/user/repos -d '{"name":"'#{$repo_name}'"}'`
  end

  def show_curl_errors
    puts JSON.parse(response)["errors"][0]["message"]
  end
end
