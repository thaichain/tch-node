# ThaiChain Blockchain Node

This repository contains the Docker setup for running a ThaiChain blockchain node. The node runs both the execution layer (Geth) and consensus layer (Lighthouse) clients to participate in the ThaiChain network.

## Overview

ThaiChain is a blockchain network with the following specifications:
- **Chain ID**: 7
- **Network**: Thaichain
- **Execution Layer**: Geth (Ethereum Go Client)
- **Consensus Layer**: Lighthouse

## Prerequisites

- Docker and Docker Compose installed on your system
- A server with a public IP address
- Sufficient disk space for blockchain data
- Network ports 30303, 9000, 8551, 5052 open for inbound/outbound traffic

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd tch-node
```

### 2. Update Public IP (IMPORTANT)

Before starting the node, you **must** run the `update_ip.sh` script to automatically detect and set your public IP address in the `.env` file:

```bash
chmod +x update_ip.sh
./update_ip.sh
```

This script will:
- Automatically detect your public IP address
- Update the `NODE_PUBLIC_IP` variable in the `.env` file
- Create a backup of your original `.env` file

**Note**: The `NODE_PUBLIC_IP` variable is crucial for proper node discovery and networking. Without running this script, your node may not be able to connect to the network properly.

### 3. Configure Environment Variables

Edit the `.env` file to customize your node settings:

```bash
nano .env
```

Key environment variables:
- `NODE_PUBLIC_IP`: Your public IP address (automatically set by update_ip.sh)
- `FEE_RECIPIENT`: Ethereum address to receive transaction fees
- `CHAIN_ID`: Network chain ID (default: 7)
- `ELNODES`: Execution layer boot nodes
- `CLNODES`: Consensus layer boot nodes

### 4. Start the Node

Use Docker Compose to start both the execution and consensus layer clients:

```bash
docker-compose up -d
```

This will start:
- **Geth**: The execution layer client on port 8545 (HTTP), 8546 (WS), and 30303 (P2P)
- **Lighthouse**: The consensus layer client on port 5052 (HTTP) and 9000 (P2P)

## Services

### Execution Layer (Geth)

- **Image**: `ethereum/client-go`
- **Data Directory**: `./data/geth`
- **Sync Mode**: Full sync with archive state
- **HTTP API**: Available on `http://localhost:8545`
- **WebSocket API**: Available on `ws://localhost:8546`
- **Auth RPC**: Available on port 8551

### Consensus Layer (Lighthouse)

- **Image**: `sigp/lighthouse:v8.0.0`
- **Data Directory**: `./data/lighthouse`
- **HTTP API**: Available on `http://localhost:5052`
- **P2P Port**: 9000 (UDP/TCP)
- **Checkpoint Sync**: Uses `https://cl.thaichain.org`

## Configuration Files

### `config/config.yaml`
Main consensus layer configuration including:
- Genesis settings
- Fork schedule
- Network parameters
- Validator settings

### `config/genesis.json`
Execution layer genesis block configuration.

### `config/jwt.hex`
JWT secret for communication between execution and consensus layers.

### `init-script.sh`
Initialization script for Geth that sets up the genesis block.

## Monitoring and Logs

### View Logs

To view logs for both services:

```bash
docker-compose logs -f
```

To view logs for a specific service:

```bash
docker-compose logs -f geth
docker-compose logs -f beacon
```

### Health Check

Check if your node is syncing properly by accessing:
- Execution layer: `http://localhost:8545`
- Consensus layer: `http://localhost:5052`

## Network Configuration

### Required Ports

Make sure the following ports are open on your firewall:

- **30303**: Execution layer P2P (TCP/UDP)
- **9000**: Consensus layer P2P (TCP/UDP)
- **8551**: Auth RPC for execution layer
- **5052**: Consensus layer HTTP API

### Boot Nodes

The node is pre-configured with official ThaiChain boot nodes for both execution and consensus layers.

## Troubleshooting

### Common Issues

1. **Node not connecting to peers**
   - Ensure you ran `./update_ip.sh` before starting
   - Check that your public IP is correctly set in `.env`
   - Verify ports 30303 and 9000 are open

2. **Low disk space**
   - Monitor disk usage in `./data/` directories
   - Consider using snapshot sync instead of full sync if needed

3. **Sync stuck**
   - Check logs for any error messages
   - Verify network connectivity
   - Restart services: `docker-compose restart`

### Reset Node Data

To completely reset your node data:

```bash
docker-compose down
sudo rm -rf data/
docker-compose up -d
```

**Warning**: This will delete all blockchain data and require resyncing from scratch.

## Security Considerations

- Keep your Docker and system packages updated
- Use a firewall to restrict access to RPC ports
- Monitor node logs for suspicious activity
- Backup your `.env` file and configuration

## Support

For additional support:
- Check the official ThaiChain documentation
- Join the ThaiChain community channels
- Review log files for error messages

## License

This repository is licensed under the terms specified in the LICENSE file.