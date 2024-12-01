;; Decentralized Job Marketplace Smart Contract
;; This contract allows users to register as job seekers or employers, 
;; create job listings, and retrieve profiles and job postings.

(define-map job-seekers
    principal
    {
        name: (string-ascii 100),
        skills: (list 10 (string-ascii 50)),
        location: (string-ascii 100),
        resume: (string-ascii 500)
    }
)

(define-map employers
    principal
    {
        company-name: (string-ascii 100),
        industry: (string-ascii 50),
        location: (string-ascii 100)
    }
)

(define-map job-listings
    principal
    {
        title: (string-ascii 100),
        description: (string-ascii 500),
        employer: principal,
        location: (string-ascii 100),
        requirements: (list 10 (string-ascii 50))
    }
)

;; Custom error constants
(define-constant ERR-NOT-FOUND (err u404))
(define-constant ERR-ALREADY-EXISTS (err u409))
(define-constant ERR-INVALID-SKILLS (err u400))
(define-constant ERR-INVALID-LOCATION (err u401))
(define-constant ERR-INVALID-RESUME (err u402))
(define-constant ERR-INVALID-JOB (err u403))
(define-constant ERR-INVALID-EMPLOYER (err u404))

