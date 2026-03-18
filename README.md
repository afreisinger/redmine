# Redmine Docker Stack 🚀

Complete Docker Stack to run **Redmine 6.1.2** with custom plugins and themes, PostgreSQL database, and persistent storage support.

## 📋 Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Themes and Plugins](#themes-and-plugins)
- [Database](#database)
- [Troubleshooting](#troubleshooting)

---

## ✨ Features

✅ **Redmine 6.1.2** - Complete project management tool  
✅ **PostgreSQL 16** - Robust and scalable database  
✅ **15+ Plugins** - Extended functionality  
✅ **5 Themes** - Customizable interface  
✅ **Docker Compose** - Simplified orchestration  
✅ **Persistent Volumes** - Secure data storage  
✅ **Health Checks** - Automatic monitoring  
✅ **Production Ready** - Deploy-ready environment  

---

## 📁 Project Structure

```
.
├── ru/                                # Main stack
│   ├── docker-compose.yml             # Service orchestration
│   ├── env.example                    # Environment variables (git-ignored)
│   ├── backup.sh                      # Database backup script
│   ├── db-backup/                     # Automatic backups
│   │
│   ├── redmine-plugins/               # Custom plugins image
│   │   ├── Dockerfile                 # Multi-stage build
│   │   ├── plugins/                   # Plugin ZIPs (15 files)
│   │   │   ├── redmine_agile-1_6_13-light-1.zip
│   │   │   ├── redmine_budgets-1_0_8-light.zip
│   │   │   ├── redmine_checklists-4_0_1-light-1.zip
│   │   │   ├── redmine_cms-1_2_6-light.zip
│   │   │   ├── redmine_contacts_invoices-4_2_15-light.zip
│   │   │   ├── redmine_crm-4_4_4-light.zip
│   │   │   ├── redmine_drive-1_2_4-light.zip
│   │   │   ├── redmine_favorite_projects-2_1_6-light.zip
│   │   │   ├── redmine_finance-2_1_12-light.zip
│   │   │   ├── redmine_people-1_6_13-light.zip
│   │   │   ├── redmine_products-2_2_7-light.zip
│   │   │   ├── redmine_questions-1_0_8-light.zip
│   │   │   ├── redmine_resources-2_0_7-light.zip
│   │   │   ├── redmine_tags-2_1_0-light.zip
│   │   │   └── redmine_zenedit-3_0_0-light.zip
│   │   └── initdb/                    # Database initialization
│   │       ├── initdb.sh
│   │       └── redmine-db.sql
│   │
│   ├── redmine-themes/                # Custom themes image
│   │   ├── Dockerfile                 # Multi-stage build
│   │   └── themes/                    # Theme ZIPs (5 files)
│   │       ├── a1_theme-4_1_2.zip
│   │       ├── circle_theme-2_2_4.zip
│   │       ├── coffee_theme-1_0_0.zip
│   │       ├── highrise_theme-1_2_0.zip
│   │       └── opale_theme-1_6_6.zip│
│   │
│   ├── .github/                       # GitHub workflows
│   │   └── workflows/
│   │       ├── build-docker.yml
│   │       └── deploy.yml
│   │
│   └── (documentation files)
```

---

## 📋 Requirements

- **Docker** ≥ 20.10
- **Docker Compose** ≥ 1.29
- **2GB RAM** minimum
- **10GB disk** for volumes
- **proxy network** (see Installation)

---

## 🚀 Installation

### 1. Create proxy network (not mandatory)

```bash
docker network create proxy
```

### 2. Navigate to directory

```bash
cd /path/to/redmine
```

### 3. Copy environment variables

```bash
cp env.example .env
```

Edit `.env` with real values:

```env
DB_NAME=redmine
DB_USER=redmine
DB_PASSWORD=your_secure_password

# Generate with: openssl rand -hex 64
REDMINE_SECRET_KEY_BASE=your_generated_key

# Image versions
THEMES_VERSION=1.0.0
PLUGINS_VERSION=1.0.0
```

### 4. Start the stack

```bash
# Build images and start services
docker compose up -d

# View logs
docker compose logs -f redmine
```

### 5. Verify service health

```bash
docker compose ps
```

Wait until all services show `healthy` ✓

### 6. Access Redmine

- **URL**: http://localhost:3000
- **Default username**: admin
- **Default password**: admin

⚠️ **Change credentials immediately** in Administration > Users

---

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_NAME` | Database name | `redmine` |
| `DB_USER` | Database user | `redmine` |
| `DB_PASSWORD` | Database password | - |
| `REDMINE_SECRET_KEY_BASE` | Rails secret key | - |
| `THEMES_VERSION` | Theme image tag | `1.0.0` |
| `PLUGINS_VERSION` | Plugin image tag | `1.0.0` |

### Ports

| Service | Port | URL |
|---------|------|-----|
| Redmine | 3000 | http://localhost:3000 |
| PostgreSQL | - | Internal only |

### Volumes

| Volume | Purpose |
|--------|---------|
| `redmine_storage` | PostgreSQL data |
| `redmine_files` | Uploaded files |
| `redmine_plugins` | Active plugins |
| `redmine_themes` | Installed themes |
| `redmine_logs` | Redmine logs |
| `redmine_initdb` | DB init scripts |

---

## 🎯 Usage

### Main Commands

```bash
# Start services
docker compose up -d

# View logs in real-time
docker compose logs -f redmine

# Stop services
docker compose down

# Rebuild images
docker compose build --no-cache

# Run command in Redmine
docker compose exec redmine rails -v
```

### Add Plugins

1. Download plugin ZIP (compatible version)
2. Copy to `./redmine-plugins/plugins/`
3. Rebuild image:

```bash
docker build -t redmine-plugins:2.0.0 ./redmine-plugins
```

4. Update `docker-compose.yml`:

```yaml
redmine-plugins:
  image: redmine-plugins:2.0.0
```

5. Restart:

```bash
docker compose down && docker compose up -d
```

### Add Themes

Same process as plugins:

1. Copy ZIP to `./redmine-themes/themes/`
2. Rebuild:

```bash
docker build -t redmine-themes:2.0.0 ./redmine-themes
```

3. Update and restart compose

---

## 📦 Themes and Plugins

### 🎨 Installed Themes

| Theme | Version | Description |
|-------|---------|-------------|
| A1 Theme | 4.1.2 | Modern and clean |
| Circle Theme | 2.2.4 | Circular design |
| Coffee Theme | 1.0.0 | Dark and professional |
| Highrise Theme | 1.2.0 | Responsive |
| Opale Theme | 1.6.6 | Minimalist |

Change theme in: **Administration > Settings > Theme**

### 🔌 Installed Plugins

| Plugin | Version | Functionality |
|--------|---------|---------------|
| Agile | 1.6.13 | Agile management |
| Budgets | 1.0.8 | Budget control |
| Checklists | 4.0.1 | Task checklists |
| CMS | 1.2.6 | Content management |
| Contacts & Invoices | 4.2.15 | CRM + invoicing |
| CRM | 4.4.4 | Contact management |
| Drive | 1.2.4 | File storage |
| Favorite Projects | 2.1.6 | Quick access |
| Finance | 2.1.12 | Financial control |
| People | 1.6.13 | Personnel management |
| Products | 2.2.7 | Product catalog |
| Questions | 1.0.8 | Q&A forum |
| Resources | 2.0.7 | Resource planning |
| Tags | 2.1.0 | Tagging system |
| Zenedit | 3.0.0 | Advanced editor |

Enable plugins in: **Administration > Plugins > Enable**

---

## 💾 Database

### Manual Backup

```bash
./backup.sh
```

Creates dump in `db-backup/redmine_TIMESTAMP.sql`

### Restore Backup

```bash
# Copy backup to container
docker cp db-backup/redmine_TIMESTAMP.sql redmine-db:/tmp/

# Restore
docker compose exec db psql -U redmine -d redmine < /tmp/redmine_TIMESTAMP.sql
```

### Clean Data

```bash
# Stop services
docker compose down

# Remove volume
docker volume rm ru_redmine_storage

# Restart (re-initializes database)
docker compose up -d
```

---

## 🔧 Troubleshooting

### Redmine won't start

```bash
# View detailed logs
docker compose logs redmine

# Check database health
docker compose logs db
```

**Common causes:**
- Database not ready (wait 30-60 seconds)
- Missing `proxy` network: `docker network create proxy`
- Port 3000 in use: change in `docker-compose.yml`

### Plugins/Themes not loading

```bash
# Check volumes
docker volume ls | grep redmine

# Clean and restart
docker compose down -v && docker compose up -d
```

### Database permission issues

```bash
# Restart DB container
docker compose restart db
```

### Reset admin password

```bash
docker compose exec redmine rails console << EOF
user = User.where(login: "admin").first
user.password = "new_password"
user.password_confirmation = "new_password"
user.save!
exit
EOF
```

---

## 📚 Resources

- [Official Redmine Documentation](https://www.redmine.org/projects/redmine/wiki)
- [Docker Redmine Images](https://hub.docker.com/_/redmine)
- [Redmine Plugins](https://www.redmine.org/plugins)
- [Redmine Community](https://www.redmine.org/projects/redmine/boards)

---

## 📝 License

This project uses:
- **Redmine** - GPL-2.0
- **PostgreSQL** - PostgreSQL License
- Plugins and themes according to their respective licenses

---

**Last update:** March 2026
