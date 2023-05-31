# flexible-origin-install
Automated script for installing Flexible Origin instances

## Ubuntu 22.04 LTS
Create a flexible origin instance with white background
Tested on 22.04+ LTS

```bash
bash <(curl -s https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/install_ubuntu.sh)
```

## Ubuntu 22.04 LTS - blue
Create a flexible origin instance with blue background
Tested on 22.04+ LTS

```bash
bash <(curl -s https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/install_blue_ubuntu.sh)
```

## Ubuntu 22.04 LTS - green
Create a flexible origin instance with green background
Tested on 22.04+ LTS

```bash
bash <(curl -s https://raw.githubusercontent.com/rafaalpizar/flexible-origin-install/master/install_green_ubuntu.sh)
```

## Docker
- To build the image:
```bash
docker build -t flexible-origin:latest .
```

- To test a container:
```bash
docker run -it --rm --name fo flexible-origin:latest
```

