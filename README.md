# Subdominator: Your One-Stop Solution for Subdomain Enumeration

<p align="center">
  <img src="https://raw.githubusercontent.com/Edd13Mora/Subdominator/main/d0ac3d5a64b4fa685ebaf969976eeac0-removebg-preview.png">
</p>

## Description

Subdominator is a comprehensive tool designed to streamline the process of subdomain enumeration and DNS probing. Utilizing a variety of methods like `subfinder` and `assetfinder`, it compiles a list of subdomains related to a given top-level domain. Not only does it discover immediate subdomains, but it also performs deep host enumeration to reveal even more hidden assets. Integrated with `massdns`, Subdominator allows you to seamlessly validate subdomains and resolve DNS queries in one easy-to-use script.

## Features

- **Subdomain Enumeration**: Automatically fetches subdomains using `subfinder` and `assetfinder`.
- **DNS Enumeration**: Utilizes a custom DNS wordlist to perform DNS brute-forcing.
- **Deep Host Enumeration**: Unveils subdomains at various depths, making it useful for comprehensive network reconnaissance.

## Installation

```bash
git clone https://github.com/Edd13Mora/Subdominator.git
cd Subdominator
chmod +x main.sh
```
## Usage
```
./main.sh <domain> [path_to_dns_list] [path_to_resolver_list]
```
## Example 
Use standart dsn and resolver file of the project if you don't have custom ones
{Works better on a VPS}
```
./main.sh example.com /home/kali/dns.txt /home/kali/resolver.txt
```
 <img src="https://raw.githubusercontent.com/Edd13Mora/Subdominator/main/demo.png">

## Dependencies

Make sure to install these before running the script.
```
subfinder
assetfinder
massdns
httprobe
```
## Contributing
Feel free to submit pull requests to contribute.
