![](.github/images/repo_header.png)

[![n8n](https://img.shields.io/badge/n8n-1.83.2-blue.svg)](https://github.com/n8n-io/n8n/releases/tag/n8n%401.83.2)
[![Dokku](https://img.shields.io/badge/Dokku-Repo-blue.svg)](https://github.com/dokku/dokku)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/d1ceward-on-dokku/minio_on_dokku/graphs/commit-activity)
# Run n8n on Dokku

## Perquisites

### What is n8n?

[n8n](https://n8n.io/) is an extendable workflow automation tool. With a fair-code distribution model.

### What is Dokku?

[Dokku](http://dokku.viewdocs.io/dokku/) is the smallest PaaS implementation you've ever seen - _Docker
powered mini-Heroku_.

### Requirements
* A working [Dokku host](http://dokku.viewdocs.io/dokku/getting-started/installation/)
* [PostgreSQL](https://github.com/dokku/dokku-postgres) plugin for Dokku
* [Letsencrypt](https://github.com/dokku/dokku-letsencrypt) plugin for SSL (optionnal)

# Setup

**Note:** Throughout this guide, we will use the domain `n8n.example.com` for demonstration purposes. Make sure to replace it with your actual domain name.

## Create the app

Log into your Dokku host and create the n8n app:

```bash
dokku apps:create n8n
```

## Configuration

### Install, create and link PostgreSQL plugin

```bash
# Install postgres plugin on Dokku
dokku plugin:install https://github.com/dokku/dokku-postgres.git postgres
```

```bash
# Create running plugin
dokku postgres:create n8n
```

```bash
# Link plugin to the main app
dokku postgres:link n8n n8n
```

### Setting encryption key

```bash
dokku config:set n8n N8N_ENCRYPTION_KEY=$(echo `openssl rand -base64 45` | tr -d \=+ | cut -c 1-32)
```

### Setting webhook url

```bash
dokku config:set n8n WEBHOOK_URL=http://n8n.example.com
```

## Domain setup

To enable routing for the n8n app, we need to configure the domain. Execute the following command:

```bash
dokku domains:set n8n n8n.example.com
```

## Push n8n to Dokku

### Grabbing the repository

Begin by cloning this repository onto your local machine.

```bash
# Via SSH
git clone git@github.com:d1ceward-on-dokku/n8n_on_dokku.git

# Via HTTPS
git clone https://github.com/d1ceward-on-dokku/n8n_on_dokku.git
```

### Set up git remote

Now, set up your Dokku server as a remote repository.

```bash
git remote add dokku dokku@example.com:n8n
```

### Push n8n

Now, you can push the n8n app to Dokku. Ensure you have completed this step before moving on to the [next section](#ssl-certificate).

```bash
git push dokku master
```

## SSL certificate

Lastly, let's obtain an SSL certificate from [Let's Encrypt](https://letsencrypt.org/).

```bash
# Add https port
dokku proxy:ports-add n8n https:443:5000

# Install letsencrypt plugin
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

# Set certificate contact email
dokku letsencrypt:set n8n email you@example.com

# Generate certificate
dokku letsencrypt:enable n8n
```

## Wrapping up

Congratulations! Your n8n instance is now up and running, and you can access it at [https://n8n.example.com](https://n8n.example.com).
