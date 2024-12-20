# SecureAuth - Two-Factor Authentication Application

A modern Ruby on Rails application featuring two-factor authentication (2FA) with flexible login options using either email or mobile number.

## Features

- User authentication with Devise
- Login with Email or Mobile Number (10-digit)
- Two-Factor Authentication (2FA) support
- Modern, responsive UI with Tailwind CSS
- Account confirmation via email
- Password recovery
- Account lockout after failed attempts
- Session tracking (IP address, sign-in count, timestamps)

## Technology Stack

- **Ruby version**: 3.x
- **Rails version**: 7.1.6
- **Database**: MySQL
- **CSS Framework**: Tailwind CSS
- **Authentication**: Devise
- **Frontend**: Turbo, Stimulus

## System Dependencies

- Ruby 3.x
- Rails 7.1.6
- MySQL 8.0+
- Node.js and Yarn (for asset compilation)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd two_factor_auth
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Configure database:
Update `config/database.yml` with your MySQL credentials.

4. Create and setup database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

5. Start the development server:
```bash
bin/dev
```

The application will be available at `http://localhost:3000`

## Configuration

### Devise Setup

The application uses Devise for authentication with custom configuration:

- **Authentication Keys**: Users can login with either email or mobile number
- **Confirmable**: Email confirmation required for new accounts
- **Lockable**: Account locks after failed login attempts
- **Trackable**: Tracks sign-in count, timestamps, and IP addresses
- **Recoverable**: Password reset functionality

### Email Configuration

Update `config/environments/development.rb` and `config/environments/production.rb` with your email provider settings:

```ruby
config.action_mailer.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'example.com',
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

## Usage

### User Registration

Users can register with:
- Name
- Email address
- Mobile number (10-digit format)
- Password

### Login Options

Users can sign in using either:
- **Email**: user@example.com
- **Mobile Number**: 9944884488

The system automatically detects which credential type is being used.

### Two-Factor Authentication

Once logged in, users can enable 2FA from their account settings to add an extra layer of security.

## Database Schema

### Users Table

- `email` - User's email address (unique)
- `mobile_no` - User's mobile number (unique, 10 digits)
- `name` - User's full name
- `encrypted_password` - Encrypted password
- `reset_password_token` - Token for password reset
- `confirmation_token` - Token for email confirmation
- `unlock_token` - Token for account unlock
- `sign_in_count` - Number of sign-ins
- `current_sign_in_at` - Current sign-in timestamp
- `last_sign_in_at` - Last sign-in timestamp
- `current_sign_in_ip` - Current sign-in IP address
- `last_sign_in_ip` - Last sign-in IP address

## Development

### Running Tests

```bash
rails test
```

### Code Style

The application follows standard Ruby and Rails conventions.

### Asset Compilation

Assets are automatically compiled when running `bin/dev`. To manually compile:

```bash
rails assets:precompile
```

## Deployment

1. Set environment variables:
   - `SECRET_KEY_BASE`
   - `DATABASE_URL`
   - `SMTP_USERNAME`
   - `SMTP_PASSWORD`

2. Precompile assets:
```bash
RAILS_ENV=production rails assets:precompile
```

3. Run migrations:
```bash
RAILS_ENV=production rails db:migrate
```

4. Start the server:
```bash
RAILS_ENV=production rails server
```

## Security Features

- Password encryption using bcrypt
- CSRF protection
- SQL injection prevention
- XSS protection
- Session management
- Account lockout mechanism
- Email confirmation
- Secure password reset flow

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is available as open source under the terms of the MIT License.

## Support

For issues, questions, or contributions, please open an issue in the repository.
