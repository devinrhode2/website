#!/bin/bash
set -e
shopt -s dotglob

git checkout master

# Remove the temporary directory since things may have changed
rm -rf /tmp/dist

# Rebuild the files and copy them to the tmp folder
bower update emberui
grunt dist
cp -rv dist /tmp/dist

# copy JS files EAK filtered out
cp -rv public/assets/scripts /tmp/dist/assets/scripts

# copy 404 page & .gitignore
cp dist/index.html /tmp/dist/404.html
cp .gitignore /tmp/dist/

# Checkout gh-pages, save what we need, delete the rest and copy over
git checkout gh-pages
git pull --rebase origin gh-pages
cp CNAME /tmp/dist/
cp -rv builds /tmp/dist/
git rm -r ./
cp -rv /tmp/dist/* ./

# Commit and push the changes then switch back to master
git add .
git commit -am "Update website content"
git push origin gh-pages
git checkout master
echo "Website update successful"
