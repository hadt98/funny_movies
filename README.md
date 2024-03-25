# README

This README would normally document whatever steps are necessary to get the
application up and running.
## Run local
### 1.setup (ubuntu)
```
    //install psql
    sudo apt install postgresql postgresql-contrib
    sudo systemctl start postgresql.service
    
    //install rvm and ruby 3.1.2
    \curl -L https://get.rvm.io | bash #install rvm
    source $HOME/.bashrc
    rvm install 3.1.2
    rvm use 3.1.2
```
#### evn require
```
    echo "export YOUTUBE_API='xxxxxxxx' > $HOME/.bashrc

```

### 2.Setup dependencies and databases
```
    ./bin/setup_dev
``` 

### 3.start servers
```
    rails s
```

## run local with docker





Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
