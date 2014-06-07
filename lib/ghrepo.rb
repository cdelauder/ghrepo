# encoding: utf-8

require "ghrepo/version"
require "json"
require "io/console"

module Ghrepo

  extend self

  def start(args)
    if args.any?
      repo_name = args.pop
      credentials = set_credentials(args)
      response = `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/user/repos -d '{"name":"'#{repo_name}'"}'`
      git_url = JSON.parse(response)[credentials[:url]]

      args.include?('-rails') ? include_rails(args, repo_name, git_url) : `git clone "#{git_url}"`
    else
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
  end

  def prompt_password
    print "password > "
    password = STDIN.noecho(&:gets).chomp
  end

  def set_url(args)
    args.include?('-ssl') ? 'ssh_url' : 'clone_url'
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

  def include_rails(args, repo_name, git_url)
    add_rails(repo_name, git_url)
    push_rails
  end

  def add_rails(repo_name, git_url)
    puts "\nbuilding your rails app...."
    `rails new "#{repo_name}"`
    Dir.chdir(repo_name)
    `git init`
    `git remote add origin "#{git_url}"`
  end

  def push_rails
    `git add .`
    `git commit -m "boilerplate rails"`
    `git push -u origin master`
  end
end
