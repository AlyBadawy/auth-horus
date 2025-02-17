# Auth Horus

A secure authentication system built with Ruby on Rails, featuring comprehensive testing and robust security measures.

## 🚀 Quick Start

### Prerequisites

- Ruby (per `.ruby-version`)
- PostgreSQL

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/alybadawy/auth-horus.git
   cd auth-horus
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Set up database**
   ```bash
   bundle exec rails db:create
   bundle exec rails db:schema:load
   ```

## 🔧 Development

Start the development server:

```bash
bin/dev
```

## 🧪 Testing

Run the test suite:

```bash
bundle exec rspec
```

> 📊 Minimum test coverage requirement: 95%

## 🛡️ Quality Assurance

### Code Style

```bash
bin/rubocop
```

### Security Scan

```bash
bin/brakeman
```

## 🔄 CI/CD

Our GitHub Actions workflow automatically runs:

- Security vulnerability scans
- Code style checks
- Test suite
- Coverage reports

## 🗄️ Database Configuration

PostgreSQL environment variables:

```bash
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=test_db
```

## 🔑 Key Features

- Secure authentication system
- Comprehensive test coverage
- Static code analysis
- Security vulnerability scanning
- Automated CI/CD pipeline

## 📝 License

Licensed under the GNU General Public License v2.0. See [LICENSE](LICENSE) for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

Made with ❤️ using Ruby on Rails
Developed by Aly Badawy

![Auth Horus Logo](https://github.com/AlyBadawy/AlyBadawy/assets/1198568/471e5332-f8d0-4b78-a333-7e207780ecc1)
