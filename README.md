# myubuntu
Create a Docker container running Ubuntu 23.04 LTS with some preinstalled packages useful for development.

## Installation Instructions
First, make sure you have [Docker installed](https://docs.docker.com/get-docker/). Docker must be running whenever you want to install or use the container.
1. Navigate to your desired installation directory. This will be the directory on your host machine which you will have access to from the container (located at `~/host/`).

    For instance, in your terminal:
    ```shell
    cd ~/Desktop/myfolder/
    ```
2. Clone this repo and move the files into your desired installation directory.
    ```shell
    git clone https://github.com/nathanaeng/docker-myubuntu
    mv ./docker-myubuntu/* . && rm -rf ./docker-myubuntu
    ```

3. Give proper permissions to `startup.sh` and run the script. This will also create an alias in `~/.zshrc` called `ubuntu` which you can type in the terminal from now on to start and attach to your Docker container (from any directory - however the original installation directory will still be the only once accessible from inside the container). *Note: you will need to restart the terminal or run* `source ~/.zshrc` *to use this alias.*
    ```shell
    chmod +x startup.sh
    ./startup.sh
    ```

    This may take several minutes depending on your internet connection.

You can now get to developing! You can install any other desired packages with `sudo apt-get install <PACKAGE_NAME>`. The default username and password are both `myubuntu`. These values can be changed in `startup.sh`.

## Customization
### Names
The default container name, username, password, and alias are all stored in `startup.sh`. You can change these values, but if you have already created the container you must run the following commands:
```shell
ubuntu delete
ubuntu
```
The image name located in `startup.sh` pertains to the name of the Docker image used to create the container. Changing the image name will not have any affect on your usage of the container so it is advised to not change this value.

### zsh
Upon starting the container, you can run the following to configure Powerlevel10k to your liking:
```shell
p10k configure
```

### Vim
There is a default `.vimrc` provided, but this can be changed at any time.

## Usage and Stopping the Container
It is probably safest and most performant to save the majority of your work in the host directory rather than in the container itself. Rather, the intended use of this container is for testing your actual code.

To stop the container, return to your host terminal by typing `exit` or `Ctrl + P + Q` in the Docker terminal and then run

```shell
ubuntu stop
```

To restart the container at any time, run the following command in your terminal from any directory:

```shell
ubuntu
```