# encoding: utf-8

require "ghrepo/version"
require "json"
require "io/console"

module Ghrepo

  extend self

  def start(args)

    ################################
    # Light upgrade PSEUDO
    ################################
    # check if the dir is a git dir
    # check if the dir is empty
    # if dir empty hit new_ghrepo
    # if dir !empty hit init_ghrepo
    ################################

    check_git
    check_existing_dir ? new_ghrepo(args) : init_ghrepo(args)

  end

  def new_ghrepo(args)
    if args.any?
      repo_name = args.pop
      credentials = set_credentials(args)
      response = `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/user/repos -d '{"name":"'#{repo_name}'"}'`
      git_url = JSON.parse(response)[credentials[:url]]

      args.include?('-rails') ? include_rails(args, repo_name, git_url) : `git clone "#{git_url}"`
      add_html(repo_name, git_url) if args.include?('-html')
      find_collabs(args, credentials, repo_name) if args.include?('-c')
    else
      display_error("Invalid or No Command Line Argument provided:")
    end
  end

  def init_ghrepo(args)
    puts "This will initialize a new GitHub Repository for the current project."
    if args.any?

      repo_name = args.pop
      `git config --global credential.helper 'cache --timeout=3600'`
      credentials = set_credentials(args)
      response = `curl -u "#{credentials[:username]}:#{credentials[:password]}" https://api.github.com/user/repos -d '{"name":"'#{repo_name}'"}'`
      git_url = JSON.parse(response)[credentials[:url]]

      spec = Gem::Specification.find_by_name("ghrepo")
      gem_root = spec.gem_dir
      gem_lib = gem_root + "/lib"
      gitignore_file = gem_lib+"/.gitignore_boilerplate"

      `git init`
      `cp #{gitignore_file} ./.gitignore`
      `git remote add origin #{git_url}`
      `git add .`
      `git commit -m "initial commit application #{repo_name}"`

      puts "#" * 50
      puts "You may / may not be asked to re-authenticate."
      puts "#" * 50

      `git push -u origin master`

      find_collabs(args, credentials, repo_name) if args.include?('-c')

      puts "Repo created and pushed."
      puts "A heavy .gitignore file has been generated for you prior to push."
      puts "You are encouraged to edit it for your needs."

    else
      display_error("Invalid or No Command Line Argument provided:")
    end
  end

  def check_existing_dir
    dirs = Dir.entries('.').select { |word| word.match(/(\Whtml|\Wru|app|Gemfile)/)}
    if dirs.length > 0
      return false
    else
      return true
    end
  end

  def check_git
    puts "Checking .git status of this directory."
    display_error("Folder already a GIT repository.") if (Dir.entries('.').include? ".git")
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

    spec = Gem::Specification.find_by_name("ghrepo")
    gem_root = spec.gem_dir
    gem_lib = gem_root + "/lib"

    html5_file = gem_lib+"/lib/html5-boilerplate.html"
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
    puts "Successfully added collaborator ", collab
  end

  def display_error(msg = "such moron very dumb")
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
    p "*"*50
    puts msg
    p "*"*50
    raise msg
  end

end
