# CS84-DAO

## Prerequisites

- Node.js (npm)
- Ganache
- Truffle suite
- openzappelin

## Install

Install and run [Ganache] (https://trufflesuite.com/ganache/) take note of your service port number.

Install Truffle suite and openzappelin by using the following commands

```bash
# Clone this repository
$ git clone https://github.com/Holmes-Git/CS84-DAO.git

# Go into the repository
$ cd CS84-DAO

# Install dependencies
$ npm install -g truffle
$ npm install @openzeppelin/contracts
$ truffle init

# Change the configuration in truffle-config.js to match your ganache environment

module.exports = {
  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*"        // Any network (default: none)
    }
  }
}

# Deploy contract using
$ truffle migrate --reset
```

> **Note**
> If you're using Linux Bash for Windows, [see this guide](https://www.howtogeek.com/261575/how-to-run-graphical-linux-desktop-applications-from-windows-10s-bash-shell/) or use `node` from the command prompt.

## Download
