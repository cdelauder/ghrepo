# Ghrepo

If you don't want to have to enter your GitHub username and password (or API token) everytime you create a GitHub repo with this gem, set the following environment variables on your system.

GHREPO_KEY=PERSONAL_GITHUB_API_TOKEN

GHREPO_USERNAME=YOUR_GITHUB_USERNAME

You can create a personal GitHub API token here:
<img src="https://d2oawfjgoy88bd.cloudfront.net/5393b246c38aa547534fcae3/5393b246c38aa547534fcae5/5393b24ac38aa54754e9b138.png?Expires=1402277210&Signature=GpJuRQJMfxRpGohuxHZnKd9H1DcmBskpLshyJsMF4y2RQc89-YcRWY-gYtT6yFzG7lD2483YKlGk6H5mjljG0kEp-eAvVndMPSkdX9wK~VRJMWgoC9Y3RobP9nOruCaRR4O6wKngFjetKrTcHvCL6CyE9PcSCQIy2ta4Ua0EBaaJ794RcNp0fIxv3XzYqNiPM0Nfo~c7zFn0kPU9BULq56zbSfBI3B1fnIGaIM1iLCDHP6RWWD4ECd3q62PlwhPX42equ5PLD2P~u20gmgujWvw-fUiyj65UZeVf0esaknZmoatZdIhu3B6FkOx6~et9gahYz1s98KfKrbPRfiJplA__&Key-Pair-Id=APKAJHEJJBIZWFB73RSA">

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
