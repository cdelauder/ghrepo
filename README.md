# ghrepo

This is a Ruby gem that you can use to create GitHub repos from the command line. It currently supports creating an empty repo, a repo with a boilerplate HTML5 file or a repo with a boilerplate Rails application. You can also add collaborators when creating the repo.

If you don't want to have to enter your GitHub username and password (or API token) everytime you create a GitHub repo with this gem, set the following environment variables on your system.

```
GHREPO_KEY=PERSONAL_GITHUB_API_TOKEN
GHREPO_USERNAME=YOUR_GITHUB_USERNAME
```

Also, if you want to default to using SSH, set the following environment variable

```
GHREPO_SSH=true
```

You can create a personal GitHub API token here:
<img src="http://monosnap.com/image/5k6tgEW16fB9cajNn43q6s3Q8gJnZM.png">

## Installation

    $ gem install ghrepo

## Usage

Create an empty repo on GitHub and clone that directory into the directory that you are currently in

```
$ ghrepo THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

Create an empty repo on GitHub and clone that directory using the SSH address

```
$ ghrepo -ssh THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

Create an empty repo on GitHub, build a boilerplate Rails app and push it to the GitHub repository that was just created

```
$ ghrepo -rails THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

Create an empty repo on GitHub, build a boilerplate Rails app and push it to the GitHub repository that was just created using SSH

```
$ ghrepo -rails -ssh THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

Create an empty repo on GitHub, build a boilerplate HTML5 index.html file and push it to the GitHub repository that was just created

```
$ ghrepo -html THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

Create an empty repo on GitHub, build a boilerplate HTML5 index.html and push it to the GitHub repository that was just created using SSH

```
$ ghrepo -html -ssh THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

Add collaborators. If adding more than more than one collaborator, separate each name with a space.

```
$ ghrepo -c COLLAB_USERNAME COLLAB_USERNAME2 THE_NAME_OF_THE_REPO_YOU_WANT_TO_CREATE
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
