TRAVIS SCREENCAST
==
- upload the x11 session to github:

- generate OAUTH token:
- http://blog.cocoapods.org/Guides-And-Blog-Travis-Deploy/
- https://github.com/travis-ci/travis.rb
- http://lateralcoding.com/pushing-content-from-travis-ci-org-to-github/

- http://stackoverflow.com/questions/18027115/committing-via-travis-ci-failing
- http://sleepycoders.blogspot.co.il/2013/03/sharing-travis-ci-generated-files.html
- https://raw.githubusercontent.com/Uko/Rubidium-WHOIS/master/.utility/update-gh-pages.sh

commands:
```bash
gem install travis
cd project
travis pubkey -r owner/project

travis encrypt 'GIT_NAME="Account Name" GIT_EMAIL=example@example.com GH_TOKEN=SOMEREALLYLONGSTRING' --add

```

```yaml
language: ruby
branches:
  only:
  - master
rvm:
- 2.0.0
install:
- git config --global user.email "bots@cocoapods.org"
- git config --global user.name "CocoaPods Bot"
- rake bootstrap
script:
- git remote set-url origin "https://${GH_TOKEN}@github.com/CocoaPods/blog.cocoapods.org.git"
- rake deploy
env:
  global:
    secure: XXXX
```
