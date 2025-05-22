
---

# sbtc-supplysage - Supply Chain Transparency Contract

**Version**: 1.0
**Language**: Clarity (Stacks Smart Contract Language)
**Category**: Supply Chain | Blockchain Transparency | Role-Based Access Control | Audit Compliance

---

## 🧩 Overview

**ClearSight** is a smart contract for blockchain-based supply chain transparency. It ensures authenticated product tracking with robust role-based access control (RBAC), comprehensive audit logs, validation layers, and status transition enforcement. The contract is tailored to enhance visibility, accountability, and trust among manufacturers, distributors, and retailers.

---

## 🔐 Features

### ✅ Role-Based Access Control (RBAC)

* **Roles**: Admin, Manufacturer, Distributor, Retailer
* Only authorized roles can perform sensitive actions (e.g., product registration and status updates)

### 🚚 Product Lifecycle & Status Tracking

* Tracks product lifecycle with **enhanced statuses**:
  `registered`, `in-transit`, `delivered`, `transferred`, `verified`, `returned`, `rejected`

### 🕵️ Audit Trail

* Immutable logs of all actions, with timestamps, actor details, and descriptions

### 📜 Validation & Status Management

* Enforces **valid input lengths**, non-empty fields, and **logical status transitions**

### 📘 Historical Tracking

* Maintains:

  * Status update history per product
  * Ownership and action-based product history
  * Full audit logs for traceability

---

## 🧰 Contract Structure

### 🏷 Constants

* Max lengths: Product ID (36), Location (50), Reason (50)
* Roles: Admin (1), Manufacturer (2), Distributor (3), Retailer (4)
* Defined error codes and product statuses

### 🗃 Data Maps

* `products`: Track current product data
* `user-roles`: Store role assignments
* `status-history`: Track each product’s status updates
* `product-history`: Record transfers and ownership changes
* `audit-log`: Centralized log of all significant actions

---

## ⚙️ Public Functions

### `register-product(product-id, location)`

* Manufacturer-only
* Registers a new product with an initial status and audit log

### `update-product-status(product-id, new-status, reason, location)`

* Manufacturer-only
* Updates the product status with validation and logs the change

### `assign-role(user, role)`

* Admin-only
* Assigns a user one of the allowed roles

---

## 🔍 Read-only Functions

### `get-product-details(product-id)`

* Returns current data about a registered product

### `get-status-history(product-id, update-number)`

* Retrieves specific status update information from the product history

---

## 🛑 Errors

| Code | Description               |
| ---- | ------------------------- |
| 100  | Not authorized            |
| 101  | Product already exists    |
| 102  | Product not found         |
| 103  | Invalid status            |
| 104  | Invalid product ID        |
| 105  | Invalid location          |
| 106  | Invalid owner             |
| 107  | Role already exists       |
| 108  | Invalid role              |
| 109  | Invalid status transition |
| 110  | Invalid reason            |

---

## 🔄 Valid Status Transitions

| Current Status | Allowed Transitions         |
| -------------- | --------------------------- |
| `registered`   | `in-transit`, `transferred` |
| `in-transit`   | `delivered`, `returned`     |
| `delivered`    | `verified`, `rejected`      |
| `transferred`  | `verified`                  |

---

## 🏁 Deployment Notes

* Ensure the deploying wallet has `Admin` rights.
* Use `assign-role` to distribute roles to other users before allowing actions.

---

## 🔐 Security Considerations

* Only Admins can assign roles.
* Input validation prevents injection and malformed entries.
* Audit logs ensure tamper-evident trails.
* Transitions between product statuses are strictly validated to avoid anomalies.

---
