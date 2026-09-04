# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 📁 Project Structure

- **Root**: Rails 8 application with PostgreSQL, TailwindCSS, Devise, Sidekiq
- **Architecture**: Service objects pattern (`app/services/`) with `ApplicationService` base class and `Result` value objects
- **Database**: PostgreSQL with migrations split into primary/cache/queue/cable in production
- **Auth**: Devise with OTP and Google OAuth2 via OmniAuth
- **Background Jobs**: Sidekiq with JobLog model for tracking
- **API**: RESTful routes under `api/v1` namespace
- **Testing**: RSpec + Capybara with factories in `spec/factories/`
- **Assets**: TailwindCSS + Propshaft asset pipeline

## 🚀 Common Commands

### Development Setup
```bash
# Initial setup
bundle install
bin/rails db:create db:migrate db:seed

# Start dev server with CSS watcher
bin/dev

# Run tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/book_spec.rb

# Run tests with coverage
bundle exec rspec --coverage

# Run tests in watch mode
bin/rspec-watch

# Run a specific test by line number
bundle exec rspec spec/models/user_spec.rb:23
```

### Linting & Code Quality
```bash
# Run RuboCop
bundle exec rubocop

# Fix RuboCop offenses automatically
bundle exec rubocop --auto-correct

# Run RuboCop in specific directory
bundle exec rubocop app/services/

# Check specific file for offenses
bundle exec rubocop app/controllers/books_controller.rb
```

### Database & Migrations
```bash
# Create and run migrations
bin/rails db:migrate

# Rollback last migration
bin/rails db:rollback

# Reset database
bin/rails db:reset

# Run seeds
bin/rails db:seed

# View migration history
bin/rails db:migrate:status
```

### Assets & Build
```bash
# Precompile assets for production
bin/rails assets:precompile

# Watch CSS (via foreman in Procfile.dev)
# Already running when using bin/dev
```

## 🏗️ High-Level Architecture

### Service Object Pattern
- **ApplicationService**: Base class with `Result` value object pattern
- **Books::SearchBooksService**: Filters books by query and category
- **Books::CreateBookService**: Creates books with validation
- **Otp::SendOtpService**: Handles OTP sending
- **Otp::VerifyOtpService**: Validates OTP codes
- **Users::RegisterService**: User registration logic
- **Users::AuthenticateWithSupabaseJwtService**: JWT authentication

### API Structure
```
/api/v1/books[/:id] - CRUD operations
/auth/login - JWT token endpoint
/otp/* - OTP verification flow
/devise/omniauth_callbacks - OAuth2 callback
```

### Authentication Flow
1. **OTP**: Session-based OTP sent via Resend email service
2. **OAuth2**: Google login via OmniAuth
3. **JWT**: Token-based auth for API endpoints
4. **Devise**: Complete user management (register/login/reset)

### Background Jobs
- **WelcomeEmailJob**: Sends welcome email on user creation
- **Solid Queue**: PostgreSQL-backed job queue
- **JobLog**: Tracks job execution (success/failure)

### Data Flow
1. **Controllers**: Thin routers that delegate to services
2. **Services**: Business logic with Result pattern
3. **Models**: ActiveRecord with validations/scopes
4. **Serializers**: FastJsonapi for JSON APIs
5. **Jobs**: Sidekiq for async operations

## 🧪 Testing Strategy

### Test Suite Structure
- **Unit Tests** (`spec/models/`, `spec/services/`, `spec/jobs/`): Test individual components
- **Controller Tests** (`spec/controllers/`): HTTP request/response
- **System Tests** (`spec/system/`): Full user workflows
- **Integration Tests** (`spec/requests/`): API endpoints

### Test Patterns
- Use FactoryBot for test data (`spec/factories/`)
- Parameterized tests for edge cases
- System specs for user journeys
- Mock email services in tests
- Database isolation between test runs

## 🔄 Development Workflow

### Session Management
```bash
# Check current session
bin/rails dev:cache

# Environment-specific config
config/environments/{development,test,production}.rb
```

### Code Review Process
1. Check for RuboCop offenses first
2. Write tests for new functionality
3. Use service objects for business logic
4. Validate token presence in JSON requests
5. Follow existing naming conventions

### Common Error Scenarios
- **Database Connection**: Check PostgreSQL is running
- **Asset Pipeline**: Ensure TailwindCSS compiled
- **Background Jobs**: Verify Sidekiq is running in production
- **Email Services**: Configure RESEND_API_KEY and email settings
- **Authentication**: JWT secret key base required for API auth

## 📍 Key Files to Reference

- `app/services/application_service.rb`: Service pattern conventions
- `spec/` directory: Complete test suite patterns
- `db/migrate/`: Migration history and database schema evolution
- `config/routes.rb`: Route architecture and API design
- `app/controllers/`: Controller patterns (thin routers)
- `app/services/books/`: Search and create patterns
- `DEVELOPMENT_LOG.md`: Deployment lessons and production fixes
- `README.md`: Setup and usage instructions

## ⚠️ Production Considerations

From DEVELOPMENT_LOG.md lessons:
1. **Database**: Never use SQLite in production (use PostgreSQL)
2. **Gem Groups**: Move production-needed gems (`devise`, `fast_jsonapi`) out of `:development, :test` groups
3. **Database Config**: Production uses separate database connections for cache/queue/cable
4. **Sidekiq**: Remove Sidekiq requirements from production routes.rb
5. **CSS**: Use `<%= stylesheet_link_tag "tailwind" %>` for compiled assets
6. **Environment Variables**: Set RAILS_MASTER_KEY, DATABASE_URL, RAILS_ENV for Render deployment

This codebase emphasizes clean architecture with service objects, comprehensive testing, and follows Rails best practices. Future work should maintain these patterns while avoiding the common pitfalls documented in DEVELOPMENT_LOG.md.