# 🚀 Premium Bookstore

> **Modern, high-performance web application** — to browse, search, and manage a curated collection of books.

[![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white)](https://rubyonrails.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)](https://tailwindcss.com/)

[![Portfolio](https://img.shields.io/badge/Portfolio-sohamchavan.site-blueviolet?style=for-the-badge)](https://www.sohamchavan.site/)

---

## 📌 Table of Contents

- [About](#-about)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Development Log](#-development-log)
- [Getting Started](#-getting-started)
- [Usage](#-usage)
- [Screenshots](#-screenshots)
- [Roadmap](#-roadmap)
- [Contributing](#-contributing)
- [Author](#-author)

---

## 📖 About

Premium Bookstore is a modern web application built to solve the need for a seamless book management and browsing experience.
It is designed for avid readers and administrators, focusing on high-performance catalog navigation, premium responsive UI, and secure authentication workflows.

---

## ✨ Features

- ✅ **Dynamic Catalog** — Browse a wide range of books across categories like Fiction, Science, History, and more.
- ✅ **Advanced Search** — Quickly find your favorite books by title or author with powerful filtering.
- ✅ **Secure Authentication** — Complete user management with Devise, featuring OTP verification and Google OAuth2 login.
- ✅ **Responsive Design** — A stunning, premium UI built with TailwindCSS, optimized for all devices.
- ✅ **Robust API** — RESTful API endpoints for external integrations and data access.

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Backend** | Ruby on Rails 8.0.2 |
| **Database** | PostgreSQL |
| **Frontend** | HTML · JavaScript · TailwindCSS |
| **Auth** | Devise · OmniAuth (Google) |
| **Background Jobs** | Sidekiq |
| **Testing** | RSpec & Capybara |
| **Assets** | Propshaft & Importmap |

---

## 📝 Development Log

This project maintains a detailed [Development & Deployment Log](DEVELOPMENT_LOG.md) that tracks:
- Deployment strategies (e.g. Render Free Tier).
- Lessons learned and bug fixes.
- Database migration details (SQLite to PostgreSQL).
- Environment variable requirements.

---

## 🚀 Getting Started

### Prerequisites

```bash
ruby       >= 3.2.2
rails      >= 8.0.2
postgresql >= 12
bundler    >= 2.4
```

### Installation

```bash
# 1. Clone the repo
git clone git@github.com:sohamchavan07/bookstore.git
cd bookstore

# 2. Install dependencies
bundle install

# 3. Set up environment variables
cp .env.example .env
# Fill in the required values in .env

# 4. Set up the database
bin/rails db:create db:migrate db:seed

# 5. Start the dev server
bin/dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 💡 Usage

```bash
# Run the test suite
bundle exec rspec

# Run Sidekiq (if applicable for background jobs)
bundle exec sidekiq

# Build and run Docker container (for production-ready deployment)
docker build -t bookstore .
docker run -p 80:80 -e RAILS_MASTER_KEY=<your_key> bookstore
```

---

## 📸 Screenshots

| Page / Feature | Preview |
|----------------|---------|
| Catalog Search | ![Search Feature](./screenshots/search_placeholder.png) |
| Authentication | ![Auth Feature](./screenshots/auth_placeholder.png) |

> *Add actual screenshots to the `/screenshots` folder in the repo root.*

---

## 🗺️ Roadmap

- [x] MVP — core features live
- [x] Add authentication (OTP, Google OAuth2)
- [x] Mobile-responsive polish
- [x] Switch database from SQLite to PostgreSQL
- [ ] Deploy to production on Render
- [ ] Setup CI/CD Pipeline

---

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

1. Fork the repo
2. Create your branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 👤 Author

**Soham Chavan**

[![Portfolio](https://img.shields.io/badge/Portfolio-sohamchavan.site-blueviolet?style=flat-square)](https://www.sohamchavan.site/)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sohamchavan07/)
[![X](https://img.shields.io/badge/X-000000?style=flat-square&logo=x&logoColor=white)](https://x.com/soham_chavan07)
[![Gmail](https://img.shields.io/badge/Gmail-D14836?style=flat-square&logo=gmail&logoColor=white)](mailto:sohamchavan.sc07@gmail.com)

---

## 📄 License

This project is licensed under the [MIT License](./LICENSE).

---

<p align="center">
  Made with ❤️ by <a href="https://www.sohamchavan.site/">Soham Chavan</a>
</p>
