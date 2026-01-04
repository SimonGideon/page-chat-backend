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

## Admin UI

The Rails app now exposes a [Trestle](https://github.com/TrestleAdmin/trestle) dashboard so non-technical teammates can manage content:

- Start the server as usual (`bundle exec rails server -p 4000`).
- Visit `http://localhost:4000/admin`.
- Manage Books, Authors, Categories, and Users from the left navigation. A simple dashboard shows recent books and key counts.
- Members cannot be deleted; instead set their status to **Disabled**, **Suspended**, or **Inactive** from the admin form (they default to **Active**).
- Passwords are never entered manually. Use the **Reset Password** button on a member record (or the action in the members table) to send them a freshly generated password via email. Make sure `config/environments/*.rb` is configured with working SMTP credentials so the notification can be delivered.

By default the admin area does **not** require separate credentials, so be sure to run it only on trusted networks or add your own authentication/SSO layer before deploying to production.

## Email / SMTP configuration

Password reset emails (and other Devise notifications) rely on Action Mailer’s built-in SMTP
adapter. Copy `env.example` to `.env`, fill in the `SMTP_*` values (Gmail App Password or any
other provider), and start Rails—`dotenv-rails` auto-loads them in development/test. Production
should set the same environment variables so the mailer can authenticate.


## API Versioning

All HTTP clients should now target the versioned base path `https://<host>/api/v1`.  
Example: `POST /api/v1/login` replaces the previous `/login` route. Future versions will
follow the same pattern (`/api/v2`, etc.), making it safe to evolve the contract without
breaking existing integrations.

