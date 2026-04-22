# Development & Deployment Log: Bookstore Project

This log tracks the journey of preparing this Rails 8 application for deployment on Render's free tier.

## 🚀 Deployment Strategy: Render (Free Tier)
- **Runtime:** Docker
- **Database:** PostgreSQL (for persistence on Free Tier)
- **Background Jobs:** Solid Queue (PostgreSQL-backed)
- **Cache:** Solid Cache (PostgreSQL-backed)
- **Action Cable:** Solid Cable (PostgreSQL-backed)

---

## 🛠 Lessons Learned & Fixes

### 1. Database Migration (SQLite to PostgreSQL)
*   **The Mistake:** Initially using SQLite. On Render's Free Tier, SQLite files are wiped on every restart because there is no persistent disk support.
*   **The Fix:** 
    *   Switched to `pg` gem.
    *   Updated `config/database.yml` to use `DATABASE_URL` and simplified it so that `primary`, `cache`, `queue`, and `cable` all share the same PostgreSQL instance (Render Free Tier only provides one database).
    *   Updated `Dockerfile` to install `libpq-dev` and `postgresql-client`.

### 2. The "Devise" Production Error
*   **The Mistake:** Placing the `devise` gem inside the `group :development, :test` block.
*   **The Problem:** Docker builds for production use `BUNDLE_WITHOUT="development"`. When the build tried to precompile assets, it failed with `NameError: uninitialized constant Devise` because the gem wasn't installed.
*   **The Fix:** Moved `gem "devise"` to the top-level global scope in the `Gemfile` so it is available in all environments.

### 3. CSS & Tailwind Integration
*   **The Mistake:** Having two competing CSS files (`application.css` and `tailwind/application.css`) and a layout pointing to a missing asset name.
*   **The Fix:**
    *   Merged the "Premium Theme" custom CSS into the Tailwind source file at `app/assets/tailwind/application.css`.
    *   Updated the layout to use `<%= stylesheet_link_tag "tailwind" %>` because the `tailwindcss-rails` gem compiles the output to `tailwind.css`.

### 4. Build-Time Database Connections
*   **The Mistake:** Leaving explicit `connects_to` blocks in `production.rb` that pointed to a separate `queue` database.
*   **The Problem:** During `assets:precompile`, Rails tries to initialize the database connection. If it looks for a specific `queue` database that isn't defined in `database.yml`, the build fails.
*   **The Fix:** Commented out `config.solid_queue.connects_to` in `production.rb` to let it default to the primary connection.

---

## 📝 Deployment Requirements Checklist
Before deploying to Render, ensure the following **Environment Variables** are set in the Render Dashboard:

1.  **`RAILS_MASTER_KEY`**: Found in `config/master.key`.
2.  **`DATABASE_URL`**: The **Internal Database URL** from your Render PostgreSQL instance.
3.  **`RAILS_ENV`**: Set to `production`.

---

## 💡 Pro-Tip for Future Projects
Always check your gem groups! If a gem provides a model, helper, or is referenced in `routes.rb` (like `devise` or `sidekiq`), it **must** be available in the production group.
