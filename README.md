# Hasura PostgreSQL Views Example
Documenting a minimal example of a desired pattern to use postgres views as
versioned interfaces for use with Hasura.

The purpose of this is to enable a pattern where we can provide a consistent, versioned interface
to graphql consumers even as the database may change during development.

# Installation
```bash
docker-compose up -d
cd hasura
hasura migrate apply
```
Then navigate to `localhost:8081` 
