# 📚 Premium Bookstore Application

Welcome to the **Premium Bookstore**, a modern, high-performance web application built with **Ruby on Rails 8**. This application provides a seamless experience for browsing, searching, and managing a curated collection of books across various categories.

---

## 🚀 Features

- **Dynamic Catalog**: Browse a wide range of books across categories like Fiction, Science, History, and more.
- **Advanced Search**: Quickly find your favorite books by title or author.
- **Secure Authentication**: Integrated with **Devise** for user management, featuring:
  - Email/Password login.
  - **OTP Verification**: Enhanced security with One-Time Password flow.
  - **Google OAuth2**: One-click login with Google.
- **Responsive Design**: A stunning, premium UI built with **TailwindCSS**, optimized for all devices.
- **Robust API**: RESTful API endpoints for external integrations.

---

## 🛠️ Tech Stack

| Component | Technology |
| :--- | :--- |
| **Framework** | Ruby on Rails 8.0.2 |
| **Database** | PostgreSQL |
| **Styling** | TailwindCSS |
| **Auth** | Devise & OmniAuth (Google) |
| **Testing** | RSpec & Capybara |
| **Background Jobs** | Sidekiq |
| **Assets** | Propshaft & Importmap |

---

## ⚙️ Getting Started

### Prerequisites
- **Ruby**: 3.2.2+ (Check `.ruby-version` or `Dockerfile`)
- **PostgreSQL**: Ensure it's running on your system.
- **Bundler**: `gem install bundler`

### Installation

1.  **Clone the repository**:
    ```bash
    git clone git@github.com:sohamchavan07/bookstore.git
    cd bookstore
    ```

2.  **Install dependencies**:
    ```bash
    bundle install
    ```

3.  **Database Setup**:
    ```bash
    bin/rails db:create
    bin/rails db:migrate
    bin/rails db:seed
    ```

4.  **Start the Server**:
    ```bash
    bin/dev
    ```
    *Open `http://localhost:3000` in your browser.*

---

## 🧪 Running Tests

We use **RSpec** for our test suite. To run all tests:
```bash
bundle exec rspec
```

---

## 🐳 Docker Support

For production-ready deployment, a `Dockerfile` is included. You can build and run the containerized app:
```bash
docker build -t bookstore .
docker run -p 80:80 -e RAILS_MASTER_KEY=<your_key> bookstore
```

---

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Created with ❤️ by [Soham Chavan](https://github.com/sohamchavan07)*
