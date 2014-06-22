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
      args.include?('-s') ? make_search(credentials, repo_name) : git_url = create_repo(credentials, repo_name)

      args.include?('-rails') ? include_rails(args, repo_name, git_url) : `git clone "#{git_url}"`
      add_html(repo_name, git_url) if args.include?('-html')
      find_collabs(args, credentials, repo_name) if args.include?('-c')

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

  def create_repo(credentials, repo_name)
    response = `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/user/repos -d '{"name":"'#{repo_name}'"}'`
    git_url = JSON.parse(response)[credentials[:url]]
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

  def add_html(repo_name, git_url)
    app_dir = "./#{repo_name}"
    latest_ghrepo_gem = (Dir.entries(ENV["GEM_HOME"] + "/gems")).select {|l| l.start_with?('ghrep')}.last
    html5_file = ENV["GEM_HOME"] += "/gems/" + latest_ghrepo_gem + "/lib/html5-boilerplate.html"
    Dir.chdir(app_dir)
    `cp #{html5_file} ./index.html`
    `git add .`
    `git commit -m "boilerplate html"`
    `git push -u origin master`
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

  def find_collabs(args, credentials, repo_name)
    starts_with_c = args.drop_while {|arg| arg.start_with?('-c')}
    collabs_list = starts_with_c.reject {|flags| flags.start_with?('-')}
    collabs_list.each {|collab| add_collaborator(collab, credentials, repo_name)}
  end

  def add_collaborator(collab, credentials, repo_name)
    `curl -i -u "#{credentials[:username]}:#{credentials[:password]}" -X PUT -d '' https://api.github.com/repos/"#{credentials[:username]}"/"#{repo_name}"/collaborators/"#{collab}"`
    puts "succesfully added collaborator ", collab
  end

  def make_search(credentials, repo_name)
    response = `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/search/repositories?q="#{repo_name}"&per_page=5`
    display_search_results(credentials, parse_search(response))
  end

  def parse_search(response)
    repositories = JSON.parse(response)['items']
  end

  def display_search_results(credentials, repositories)
    repo_number = 1
    repositories.each {|repo| puts "#{repo_number} #{repo['full_name']}"; repo_number += 1}
    select_repo(credentials, repositories)
  end

  def select_repo(credentials, repositories)
    puts "type the number of the repository you would like to clone or hit enter to cancel"
    print "repository number > "
    selection = STDIN.gets.to_i
    valid_selection?(selection, repositories) ? clone_repo(credentials, selection, repositories) : (puts "That was an invalid selection")
  end

  def valid_selection?(selection, repositories)
    (1..repositories.length).include?(selection)
  end

  def clone_repo(credentials, selection, repositories)
    index = selection - 1
    git_url = repositories[index][credentials[:url]]
    `git clone "#{git_url}"`
  end
end
