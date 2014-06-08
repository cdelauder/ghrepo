# Ghrepo

If you don't want to have to enter your GitHub username and password (or API token) everytime you create a GitHub repo with this gem, set the following environment variables on your system.

GHREPO_KEY=PERSONAL_GITHUB_API_TOKEN
GHREPO_USERNAME=YOUR_GITHUB_USERNAME

You can create a personal GitHub API token here:
<img src="http://monosnap.com/image/5k6tgEW16fB9cajNn43q6s3Q8gJnZM">

## Installation

    $ gem install ghrepo

## Usage

Create an empty repo on GitHub and clone that directory into the directory that you are currently in

```
$ ghruby soverywow
```


Create an empty repo on GitHub and clone that directory using the SSH address

```
$ ghruby -ssh soverywow
```

Create an empty repo on GitHub, build a boilerplate Rails app and push it to the GitHub repository that was just created

```
$ ghruby -rails soverywow
```

Create an empty repo on GitHub, build a boilerplate Rails app and push it to the GitHub repository that was just created using SSH

```
$ ghruby -rails -ssh soverywow
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
