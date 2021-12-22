This repository is template for Rails application with Vite.
The installed applications are as follows:

* DB: MySQL
* Frontend: Vite Ruby
* UnitTest: RSpec

# Dependencies
* Git
* rbenv
* nodenv

# Usage
```shell
$ curl -L -O https://github.com/commis1059/vite_rails_template/archive/refs/heads/main.zip
$ mv vite_rails_template-main ${PROJECT_NAME}
$ cd ${PROJECT_NAME}
$ cp .env.template .env
$ vi .env
$ ./install.sh
```

## .env example
PROJECT_NAME is used database names (Ex. example_development). if PROJECT_NAME is empty, database names uses the current directory name.

```shell
RUBY_VERSION=3.0.3
NODE_VERSION=16.13.1
GIT_USER_NAME=user
GIT_USER_EMAIL=user@example.com
PROJECT_NAME=example
```