#http://lateralcoding.com/pushing-content-from-travis-ci-org-to-github/
#http://docs.travis-ci.com/user/deployment/releases/
echo "Then, you need to add the token to your .travis.yml file. First, we'll encrypt the token so only Travis can see it. For this, you need the travis Rubygem installed: gem install travis."


if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  echo -e "Starting to update gh-pages\n"

  #cp -R coverage $HOME/coverage

  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis"
  git clone --quiet --branch=gh-pages https://${GH_TOKEN:-$TOKEN}@github.com:brownman/prototypes.git gh-pages >/dev/null

#  https://${GH_TOKEN}@github.com/Uko/Rubidium-WHOIS.git  gh-pages > /dev/null



#  cd gh-pages
  #cp -Rf $HOME/coverage/* .
  file=session.ogv
  ls -l $file
  cp -Rf $HOME/$file .

  git add -f .
  git commit -m "Travis build $TRAVIS_BUILD_NUMBER pushed to gh-pages"
  git push -fq origin gh-pages > /dev/null

  echo -e "Done magic with coverage\n"
fi
