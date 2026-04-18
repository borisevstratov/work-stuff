# Specification: [Feature Name]

**Date:** YYYY-MM-DD
**Status:** [Draft | Proposed | Implemented | Deprecated]

## 1. Overview
A concise description of the feature, utility, or architectural change. Explain the "why" and the core problem being solved.

## 2. Architecture & Design
High-level description of the components and their interactions.

### 2.1. Core Components
- **[Component Name]**: `[file/path]` - Description of responsibility.
- **[Service Name]**: `[file/path]` - Description of business logic.

## 3. Interface & API Surface
Detailed specification of how to interact with this feature.

### 3.1. API Endpoints (if applicable)
| Method | Endpoint | Description | Policies |
| :--- | :--- | :--- | :--- |
| GET | `/api/resource` | Summary of action | `isAuthorized` |

### 3.2. Service Methods / Utility Functions
`strapi.atsk.[namespace].[methodName](args)`

**Arguments:**
- `arg1`: `Type` - Description.
- `arg2`: `Type` - Description.

**Returns:**
- `ReturnType` - Description.

## 4. Data Model & Schema
Definitions for database tables, Strapi content types, or core interfaces.

### 4.1. Database / Content Type
- **Content Type**: `resource-name`
- **Table**: `table_name`
- **Key Fields**:
    - `field_name`: `Type` - Description.

### 4.2. Typings (JSDoc / TypeScript)
```javascript
/**
 * @typedef {Object} IEntityName
 * @property {string} uid
 */
```

## 5. Logic Flow
Step-by-step execution path for the primary use case.
1. **[Step 1]**: Action taken.
2. **[Step 2]**: Validation/Processing.
3. **[Step 3]**: Result/Output.

## 6. Security & Permissions
- **Authorization**: Describe how access is restricted (policies, ownership checks).
- **Sanitization**: How input/output is cleaned.
- **Data Protection**: Encryption or sensitive data handling.

## 7. Implementation Details
- **Location**: Primary directory for implementation.
- **Dependencies**: Required services, plugins, or npm packages.
- **Bootstrap**: How the feature is registered (e.g., in `config/functions/bootstrap.js`).

## 8. Verification & Testing
- **Test Command**: `npx jest path/to/test.test.js`
- **Manual Verification**: Steps to verify in the application.
- **Edge Cases**: Specific scenarios to be tested.

## 9. Action Items (Implementation TODOs)
- [ ] Task 1...
- [ ] Task 2...
- [ ] Task 3...
- [ ] *Note: Divide into phases only for complex, multi-stage implementations.*
