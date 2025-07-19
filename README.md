# Banking API

A Ruby on Rails API application for handling financial transactions with robust concurrency control and precise decimal arithmetic.

## Features

This implementation ensures:

### Atomic Transactions

- **Database Transactions**: All balance updates happen within `ApplicationRecord.transaction` blocks
- **Row Locking**: Uses `SELECT FOR UPDATE` via `.lock` to prevent concurrent modifications
- **Deadlock Prevention**: Locks accounts in consistent order (sorted by ID) to prevent deadlocks

### Proper Decimal Handling

- **BigDecimal Usage**: All monetary amounts use BigDecimal for precise arithmetic (no floating-point errors)
- **Database Precision**: Decimal columns with `precision: 15, scale: 2` (up to 999,999,999,999.99)
- **Consistent Rounding**: Configured with `ROUND_HALF_UP` mode

### Data Consistency & Concurrency

- **Optimistic Locking**: Prevents lost updates through database constraints
- **Foreign Key Constraints**: Ensures referential integrity between transactions and accounts
- **Check Constraints**: Database-level validation for positive balances and amounts
- **Account Locking Order**: Prevents deadlocks by acquiring locks in deterministic order

### Key Features

- **Thread-Safe**: Multiple concurrent transactions won't corrupt account balances
- **ACID Compliance**: All operations are atomic, consistent, isolated, and durable
- **Error Handling**: Comprehensive error handling for all failure scenarios
- **Validation**: Both model-level and database-level validations

## Getting Started

### Prerequisites

- Ruby (version specified in `.ruby-version` or `Gemfile`)
- Rails
- Database (PostgreSQL/MySQL/SQLite)

### Installation

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Set up the database:
   ```bash
   rails db:create db:migrate
   ```

3. Start the server:
   ```bash
   rails server -p 8080
   ```

## Architecture

The implementation handles race conditions, ensures data integrity, and maintains precise decimal calculations suitable for financial applications.
