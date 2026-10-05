# Mobile Repair Management System — Laravel Edition

This folder is the Laravel conversion of the supplied plain-PHP application. The Bootstrap design, MySQL schema, demo data, roles, and main workflows are retained. Laravel now provides routing, controllers, middleware, validation, sessions, CSRF protection, Blade views, and database access.

The interface has been upgraded into a responsive graduation-project dashboard with role-specific navigation, operational metrics, charts, compact management tables, repair timelines, printable invoices, and a public tracking experience. See `docs/GRADUATION_PROJECT_GUIDE.md` for presentation workflows, objectives, architecture, security controls, and suggested report chapters.

## Requirements

- PHP 8.2 or newer with `pdo_mysql`, `mbstring`, `openssl`, `fileinfo`, and `curl`
- Composer 2
- MySQL 8+ or MariaDB 10.5+
- Internet access for the first Composer install and the Bootstrap/Chart.js CDNs

## Quick setup (recommended)

1. Install XAMPP (PHP/MySQL) or Laragon, and install Composer from <https://getcomposer.org/download/>. During Composer setup, select your PHP executable, usually `C:\xampp\php\php.exe`.
2. Start MySQL in XAMPP/Laragon.
3. Open phpMyAdmin at `http://localhost/phpmyadmin` and import `database/schema.sql`. The script creates `mobile_repair_system` and loads the demonstration data.
4. Open PowerShell in this project folder and run:

   ```powershell
   composer install
   Copy-Item .env.example .env
   php artisan key:generate
   php artisan config:clear
   php artisan serve
   ```

5. Open `http://127.0.0.1:8000`.

If `php` is not recognized but XAMPP is installed, use the full path:

```powershell
C:\xampp\php\php.exe artisan key:generate
C:\xampp\php\php.exe artisan serve
```

## Database settings

The defaults in `.env.example` match a normal XAMPP installation:

```dotenv
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mobile_repair_system
DB_USERNAME=root
DB_PASSWORD=
```

Change these values in `.env` if your MySQL username, password, port, or database name differs. After changing `.env`, run `php artisan config:clear`.

## Demo accounts

| Role | Email | Password |
|---|---|---|
| Administrator | `admin@mrms.com` | `Admin@123` |
| Receptionist | `reception@mrms.com` | `Reception@123` |
| Technician | `technician@mrms.com` | `Tech@123` |

Public tracking is available at `http://127.0.0.1:8000/track`. Sample: ticket `MR000125`, phone `0611111111`.

## Apache/XAMPP alternative

For Apache instead of `artisan serve`, create a virtual host whose `DocumentRoot` points to this project's `public` folder. Laravel must be served from `public`, not from the project root. Enable Apache `mod_rewrite`, allow `.htaccess` overrides, and set `APP_URL` in `.env` to the virtual-host URL.

## What changed

- Direct `.php` URLs became named Laravel routes in `routes/web.php`.
- Page logic moved into controllers under `app/Http/Controllers`.
- Shared authentication and role checks moved into middleware.
- PDO calls moved to Laravel's query builder and transactions.
- HTML pages moved to Blade templates under `resources/views`.
- Assets, the original schema/demo data, and documentation were retained.

The original extracted plain-PHP project remains in the neighboring `mobile-repair-management-system` folder as a reference and was not modified.
