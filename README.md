# README

This is a funny movies website where user can share Youtube videos. They can view list published videos, could share their own 
and get notification about new uploaded video from other users.


## Run local

### 1.setup (ubuntu)

#### setup for backend

```
    //install psql
    sudo apt install postgresql postgresql-contrib
    sudo apt install libpq-dev
    sudo systemctl start postgresql.service
    
    //install rvm and ruby 3.1.2
    \curl -L https://get.rvm.io | bash #install rvm
    `echo "source $HOME/rvm.sh" >> $HOME/.bashrc`
   
    source $HOME/.bashrc
    rvm install 3.1.2
    rvm use 3.1.2
```

#### evn require

```
    echo "export YOUTUBE_API='xxxxxxxx'" >> $HOME/.bashrc

```

#### setup for fe

```
    //install rvm & node 16
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    source $HOME/.bashrc
    nvm install 16
    nvm use 16
```

### 2. setup dependencies and databases

```
    be 
    bundle install
    rails db:setup
    rails db:migrate
```

```
    fe
    npm install
```

### 3. start project

```
    //run be
    rails s

    //run fe
    
    cd funny_movie_fe 
    npm start
```

That will boot api on port 3000, btc frontend on port 4200
Access http://localhost:4200 to gain view the site

### 4. run test

```
    rspec ./spec/**/*_spec.rb
```

### 5. usages

    - Go to http://localhost:4200/home to see other published videos
    - Go to http://localhost:4200/auth/login to register/login 
    - Then you could share your own Youtube video links and receive notification from other users when they upload a video

![video demo](./assets/funny_movies_gif.gif)


## config with nginx 
```
server {
listen 80;

    server_name hadt.site;
    location / {
        root /var/www/funny_movie_fe;
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://localhost:3000/api;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header Host $host;
    }
    location /cable {
        proxy_pass http://localhost:3000/cable;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
    }
}
```



