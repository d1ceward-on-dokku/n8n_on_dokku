![](.github/images/repo_header.png)

[![n8n](https://img.shields.io/badge/n8n-1.123.25-blue.svg)](https://github.com/n8n-io/n8n/releases/tag/n8n%401.123.25)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
# Run n8n on Dokku

> **⚠️ Important: This project currently supports only n8n 1.x.x. Upgrading to n8n 2.x.x is not yet possible here, as version 2.x.x requires a separate Docker runner container. Contributions to add 2.x.x support are welcome!**

## Overview

This guide explains how to deploy [n8n](https://n8n.io/), an extendable workflow automation tool, on a [Dokku](http://dokku.viewdocs.io/dokku/) host. Dokku is a lightweight PaaS that simplifies deploying and managing applications using Docker.

## Prerequisites

Before proceeding, ensure you have the following:

- A working [Dokku host](http://dokku.viewdocs.io/dokku/getting-started/installation/).
- The [PostgreSQL plugin](https://github.com/dokku/dokku-postgres) installed on Dokku.
- (Optional) The [Let's Encrypt plugin](https://github.com/dokku/dokku-letsencrypt) for SSL certificates.

## Setup Instructions

### 1. Create the App

Log into your Dokku host and create the `n8n` app:

```bash
dokku apps:create n8n
```

### 2. Configure the App

#### Install, Create, and Link PostgreSQL Plugin

1. Install the PostgreSQL plugin:

    ```bash
    dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
    ```

2. Create a PostgreSQL service:

    ```bash
    dokku postgres:create n8n
    ```

3. Link the PostgreSQL service to the app:

    ```bash
    dokku postgres:link n8n n8n
    ```

#### Set the Encryption Key

Generate and set an encryption key for n8n:

```bash
dokku config:set n8n N8N_ENCRYPTION_KEY=$(echo `openssl rand -base64 45` | tr -d \=+ | cut -c 1-32)
```

#### Set the Webhook URL

Set the webhook URL for your n8n instance:

```bash
dokku config:set n8n WEBHOOK_URL=http://n8n.example.com
```

### 3. Configure Persistent Storage

To persist data between restarts (like community nodes, logs, etc...), create a folder on the host machine and mount it to the app container:

```bash
dokku storage:ensure-directory n8n --chown false
chown 1000:1000 /var/lib/dokku/data/storage/n8n
dokku storage:mount n8n /var/lib/dokku/data/storage/n8n:/home/node/.n8n
```

### 4. Configure the Domain and Ports

Set the domain for your app to enable routing:

```bash
dokku domains:set n8n n8n.example.com
```

Map the internal port `5678` to the external port `80`:

```bash
dokku ports:set n8n http:80:5678
```

### 5. Deploy the App

You can deploy the app to your Dokku server using one of the following methods:

#### Option 1: Deploy Using `dokku git:sync`

If your repository is hosted on a remote Git server with an HTTPS URL, you can deploy the app directly to your Dokku server using `dokku git:sync`. This method also triggers a build process automatically. Run the following command:

```bash
dokku git:sync --build n8n https://github.com/d1ceward-on-dokku/n8n_on_dokku.git
```

This will fetch the code from the specified repository, build the app, and deploy it to your Dokku server.

#### Option 2: Clone the Repository and Push Manually

If you prefer to work with the repository locally, you can clone it to your machine and push it to your Dokku server manually:

1. Clone the repository:

    ```bash
    # Via HTTPS
    git clone https://github.com/d1ceward-on-dokku/n8n_on_dokku.git
    ```

2. Add your Dokku server as a Git remote:

    ```bash
    git remote add dokku dokku@example.com:n8n
    ```

3. Push the app to your Dokku server:

    ```bash
    git push dokku master
    ```

Choose the method that best suits your workflow.

### 6. Enable SSL (Optional)

Secure your app with an SSL certificate from Let's Encrypt:

1. Add the HTTPS port:

    ```bash
    dokku ports:add n8n https:443:5678
    ```

2. Install the Let's Encrypt plugin:

    ```bash
    dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
    ```

3. Set the contact email for Let's Encrypt:

    ```bash
    dokku letsencrypt:set n8n email you@example.com
    ```

4. Enable Let's Encrypt for the app:

    ```bash
    dokku letsencrypt:enable n8n
    ```

## Wrapping Up

Congratulations! Your n8n instance is now up and running. You can access it at [https://n8n.example.com](https://n8n.example.com).

For more information about n8n, visit the [official documentation](https://docs.n8n.io/).
