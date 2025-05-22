;; ClearSight - Supply Chain Transparency Contract
;; Enhanced with RBAC, Audit Trail, Advanced Status Management, and Input Validation

;; title: source
;; version:
;; summary:
;; description:
;; Constants for validation
(define-constant MAX-PRODUCT-ID-LENGTH u36)
(define-constant MAX-LOCATION-LENGTH u50)
(define-constant MAX-REASON-LENGTH u50)

;; traits
;;
;; Enhanced status constants
(define-constant STATUS-REGISTERED "registered")
(define-constant STATUS-IN-TRANSIT "in-transit")
(define-constant STATUS-DELIVERED "delivered")
(define-constant STATUS-TRANSFERRED "transferred")
(define-constant STATUS-VERIFIED "verified")
(define-constant STATUS-RETURNED "returned")
(define-constant STATUS-REJECTED "rejected")

;; token definitions
;;
;; Action constants (all 12 chars or less)
(define-constant ACTION-UPDATE "status-upd")
(define-constant ACTION-REGISTER "register")
(define-constant ACTION-TRANSFER "transfer")

;; constants
;;
;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-PRODUCT-EXISTS (err u101))
(define-constant ERR-PRODUCT-NOT-FOUND (err u102))
(define-constant ERR-INVALID-STATUS (err u103))
(define-constant ERR-INVALID-PRODUCT-ID (err u104))
(define-constant ERR-INVALID-LOCATION (err u105))
(define-constant ERR-INVALID-OWNER (err u106))
(define-constant ERR-ROLE-EXISTS (err u107))
(define-constant ERR-INVALID-ROLE (err u108))
(define-constant ERR-INVALID-STATUS-TRANSITION (err u109))
(define-constant ERR-INVALID-REASON (err u110))

;; data vars
;;
;; Define roles
(define-constant ROLE-ADMIN u1)
(define-constant ROLE-MANUFACTURER u2)
(define-constant ROLE-DISTRIBUTOR u3)
(define-constant ROLE-RETAILER u4)

;; data maps
;;
;; Define data variables
(define-data-var contract-owner principal tx-sender)

;; public functions
;;
;; Role management
(define-map user-roles
    { user: principal }
    { role: uint }
)

;; read only functions
;;
;; Enhanced products map with status tracking
(define-map products 
    { product-id: (string-ascii 36) }
    { 
        manufacturer: principal,
        timestamp: uint,
        current-owner: principal,
        current-status: (string-ascii 12),
        verified: bool,
        status-update-count: uint
    }
)

;; private functions
;;
;; Status history map
(define-map status-history
    { 
        product-id: (string-ascii 36),
        update-number: uint
    }
    {
        status: (string-ascii 12),
        timestamp: uint,
        changed-by: principal,
        reason: (string-ascii 50),
        location: (string-ascii 50)
    }
)

;; Product history
(define-map product-history
    { 
        product-id: (string-ascii 36),
        timestamp: uint
    }
    {
        owner: principal,
        action: (string-ascii 12),
        location: (string-ascii 50),
        previous-owner: (optional principal)
    }
)

;; Audit trail
(define-map audit-log
    { 
        transaction-id: uint,
        timestamp: uint
    }
    {
        actor: principal,
        action: (string-ascii 12),
        product-id: (string-ascii 36),
        details: (string-ascii 50)
    }
)

(define-data-var audit-counter uint u0)

;; Enhanced validation functions
(define-private (is-valid-product-id (product-id (string-ascii 36)))
    (and
        (>= (len product-id) u1)
        (<= (len product-id) MAX-PRODUCT-ID-LENGTH)
        (not (is-eq product-id ""))
        (not (is-eq product-id " "))
        true
    )
)

(define-private (is-valid-location (location (string-ascii 50)))
    (and
        (>= (len location) u1)
        (<= (len location) MAX-LOCATION-LENGTH)
        (not (is-eq location ""))
        (not (is-eq location " "))
        true
    )
)
