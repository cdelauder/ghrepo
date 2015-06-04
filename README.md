# Ghrepo

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
$ ghrepo soverywow
```

Create an empty repo on GitHub and clone that directory using the SSH address

```
$ ghrepo -ssh soverywow
```

Create a new repo within an existing project and push it to GitHub.
This functionality exists only if your current directory contains one or more of the following:
* *.html
* *.ru
* app
* Gemfile
```
$ ghrepo soverywow
```

Create an empty repo on GitHub, build a boilerplate Rails app and push it to the GitHub repository that was just created

```
$ ghrepo -rails soverywow
```

Create an empty repo on GitHub, build a boilerplate Rails app and push it to the GitHub repository that was just created using SSH

```
$ ghrepo -rails -ssh soverywow
```

Create an empty repo on GitHub, build a boilerplate HTML5 index.html file and push it to the GitHub repository that was just created

```
$ ghrepo -html soverywow
```

Create an empty repo on GitHub, build a boilerplate HTML5 index.html and push it to the GitHub repository that was just created using SSH

```
$ ghrepo -html -ssh soverywow
```

Add collaborators

```
$ ghrepo -c COLLABORATOR_USERNAME soverywow
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
