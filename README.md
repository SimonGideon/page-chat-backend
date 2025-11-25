# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Errors in starting the up locally
```shell
config/master.key
config/credentials.yml.enc
```

Runt, the following command to remove the highlighted file
```shell
rm -rf config/credentials.yml.enc
```

Generate the files again
```shell
  EDITOR="mate --wait" bin/rails credentials:edit
```

## API Versioning

All HTTP clients should now target the versioned base path `https://<host>/api/v1`.  
Example: `POST /api/v1/login` replaces the previous `/login` route. Future versions will
follow the same pattern (`/api/v2`, etc.), making it safe to evolve the contract without
breaking existing integrations.

