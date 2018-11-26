# instantsearch-ios-config
Centralised config files shared to the Algolia iOS SDK (Client, Core, IS)

**It is used as a git subtree in our iOS SDK.**

## Usage

### To add the config folder in a brand new project in

It will be added as a `config` folder with a remote called `config

```
git remote add config git@github.com:algolia/instantsearch-ios-config.git

git fetch config

git subtree add --prefix=config config/master --squash

```

### Contribution Daily work

This is when you already have your config folder (subtree) added to your project.

In order to get the latest changes from the main config repo, then you should do a pull like so:
```
git subtree pull --prefix=config config master --squash
```

If you want to contribute to the main config repo, then after pulling the latest changes, you can push your changes like so (it will automatically detect the commits that have changes in the `config` folder, and will push them to main config repo.

```
git subtree push --prefix=config config master
```

## Content

This config repo contains the following functionalities:

### Swiftlint 

It contains the swiftlint executable so that everyone that pulls the container repos (Client, Core, IS) do not need to download swiftlint on their machine. This also applies to our CI bitrise that will be able to run swiftlint from Fastlane without any problems. It also has the `.swiftlint.yml` that specifies all rules to be followed by all the libraries.

### Fastlane

It contains a Fastfile that has common functionality shared accross all container repos. The container repos import this Fastfile, and can use the methods and lanes that are available there. 
