# Five Aliens Backend API

A Rails API application for managing gaming leaderboards, user authentication, and organization management.

## Table of Contents

- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Running the Application](#running-the-application)
- [API Endpoints](#api-endpoints)
- [Authentication](#authentication)

## Tech Stack

- **Ruby**: 3.3.5
- **Rails**: 7.2.1 (API mode)
- **Database**: PostgreSQL
- **Authentication**: api_guard (JWT-based)

## Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.3.5 (use rbenv, rvm, or asdf)
- PostgreSQL (version 9.3 or higher)
- Bundler gem

## Installation

1. **Clone the repository**

```bash
git clone git@github.com:LucianoConceicaoJunior/gaming-api.git
cd five_aliens_backend_api
```

2. **Install dependencies**

```bash
bundle install
```

## Database Setup

1. **Create databases**

```bash
rails db:create
```

2. **Run migrations**

```bash
rails db:migrate
```

3. **Seed the database (optional)**

```bash
rails db:seed
```

## Running the Application

### Development Server

Start the Rails server:

```bash
rails server
# or
rails s
```

The API will be available at `http://localhost:3000`

## API Endpoints

### Health Check

```
GET /api/up
```

Returns 200 if the application is running properly.

### Authentication (Gaming namespace)

```
POST   /api/gaming/sign_in              # User sign in
DELETE /api/gaming/sign_out             # User sign out
POST   /api/gaming/refresh_access_token # Refresh JWT token
```

### Leaderboard (Gaming namespace)

```
POST /api/gaming/insert_leaderboard_row # Insert a new leaderboard entry
GET  /api/gaming/get_leaderboard_rank   # Get leaderboard rankings
GET  /api/gaming/get_user_rank          # Get specific user's rank
```

### Management (Management namespace)

```
GET /api/management/organization                      # Get organization details
GET /api/management/organization/projects             # List all projects
GET /api/management/organization/projects/:project_id/leaderboards # List project leaderboards
```

### Example API Calls

```bash
# Health check
curl http://localhost:3000/api/up

# Sign in (email and password can be ommited in order to sign in as guest)
curl -X POST http://localhost:3000/api/gaming/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'

# Get leaderboard (with authentication, use Access token return above)
curl http://localhost:3000/api/gaming/get_leaderboard_rank \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Authentication

This API uses JWT (JSON Web Tokens) for authentication via the `api_guard` gem.

### Getting a Token

1. Sign in via `/api/gaming/sign_in` with credentials
2. Receive `access_token` and `refresh_token` in response
3. Include the access token in subsequent requests:

```
Authorization: Bearer YOUR_ACCESS_TOKEN
```

### Token Refresh

When your access token expires, use the refresh token:

```bash
curl -X POST http://localhost:3000/api/gaming/refresh_access_token \
  -H "Content-Type: application/json" \
  -d '{"refresh_token": "YOUR_REFRESH_TOKEN"}'
```
