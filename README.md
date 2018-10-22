# instantsearch-ios-config
Config files used for the Algolia iOS SDK 

**It is used as a git subtree in our iOS SDK.**

### To Setup the subtree in `config` folder with a remote called `config`

```
git remote add config git@github.com:algolia/instantsearch-ios-config.git

git fetch config

git subtree add --prefix=config config/master --squash

```

### Contribution Daily work

```
git subtree pull --prefix=config config master --squash

git subtree push --prefix=config config master
```
