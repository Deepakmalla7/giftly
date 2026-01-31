# Giftly Backend API

A TypeScript/Node.js backend API for the Giftly Flutter application.

## Features

- User authentication (register, login, logout)
- JWT-based authorization
- MongoDB database integration
- Password hashing with bcrypt
- Input validation with express-validator
- CORS support

## Tech Stack

- **Runtime**: Node.js
- **Language**: TypeScript
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT (JSON Web Tokens)
- **Password Hashing**: bcryptjs
- **Validation**: express-validator

## Getting Started

### Prerequisites

- Node.js (v16 or higher)
- MongoDB (local installation or MongoDB Atlas)
- npm or yarn

### Using Docker (Recommended)

1. Make sure Docker and Docker Compose are installed

2. Start the services:
   ```bash
   docker-compose up -d
   ```

3. The backend will be available at `http://localhost:3000`
   MongoDB will be available at `mongodb://localhost:27017`

4. To stop the services:
   ```bash
   docker-compose down
   ```

### Manual Installation

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Make sure MongoDB is running locally

4. Create a `.env` file with your configuration

5. Build and start:
   ```bash
   npm run build
   npm start
   ```

For development:
```bash
npm run dev
```

The server will start on `http://localhost:3000`

## API Endpoints

### Authentication

#### Register User
- **POST** `/api/auth/register`
- **Body**:
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123"
  }
  ```

#### Login User
- **POST** `/api/auth/login`
- **Body**:
  ```json
  {
    "email": "john@example.com",
    "password": "password123"
  }
  ```

#### Get Profile
- **GET** `/api/auth/profile`
- **Headers**: `Authorization: Bearer <token>`

#### Logout
- **POST** `/api/auth/logout`
- **Headers**: `Authorization: Bearer <token>`

### Health Check

#### Get Health Status
- **GET** `/api/health`

## Project Structure

```
backend/
├── src/
│   ├── controllers/     # Request handlers
│   ├── middleware/      # Custom middleware
│   ├── models/         # Mongoose models
│   ├── routes/         # API routes
│   └── server.ts       # Main server file
├── dist/               # Compiled JavaScript
├── package.json
├── tsconfig.json
└── .env
```

## Environment Variables

- `PORT`: Server port (default: 3000)
- `MONGODB_URI`: MongoDB connection string
- `JWT_SECRET`: Secret key for JWT signing
- `JWT_EXPIRES_IN`: JWT expiration time (default: 7d)

## Development

### Running Tests
```bash
npm test
```

### Building
```bash
npm run build
```

## API Response Format

### Success Response
```json
{
  "message": "Operation successful",
  "data": { ... },
  "token": "jwt_token_here" // for auth endpoints
}
```

### Error Response
```json
{
  "message": "Error description",
  "errors": [ ... ] // validation errors
}
```

## Security Features

- Password hashing with bcrypt
- JWT token-based authentication
- Input validation and sanitization
- CORS protection
- Secure headers