# encoding: utf-8

require "ghrepo/version"
require "json"
require "io/console"

module Ghrepo

  extend self

  def start(args)
    if args.any?
      create_repo(args)
    else
      much_dumb
    end
  end

  def create_repo(args)
    repo_name = args.pop
    credentials = set_credentials(args)
    response = `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/user/repos -d '{"name":"'#{repo_name}'"}'`
    if curl_has_errors(response)
      puts JSON.parse(response)["errors"][0]["message"]
    else
      clone_repo(response, credentials)
    end
  end

  def prompt_password
    puts "password > "
    password = STDIN.noecho(&:gets).chomp
  end

  def set_url(args)
    args.include?('-ssl') ? 'ssh_url' : 'git_url'
  end

  def set_username
    ENV['GHREPO_USERNAME'] || prompt_username
  end

  def prompt_username
    puts "github username > "
    username = STDIN.gets.chomp
  end

  def set_password
    ENV['GHREPO_KEY'] || prompt_password
  end

  def set_credentials(args)
    {url: set_url(args), username: set_username, password: set_password}
  end

  def curl_has_errors(response)
    if JSON.parse(response)["errors"]
      return true
    end
  end

  def clone_repo(response, credentials)
    git_url = JSON.parse(response)[credentials[:url]]
    `git clone "#{git_url}"`
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
end
