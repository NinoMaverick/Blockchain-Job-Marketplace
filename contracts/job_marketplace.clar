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

;; Public function to register a job seeker profile
(define-public (register-job-seeker 
    (name (string-ascii 100))
    (skills (list 10 (string-ascii 50)))
    (location (string-ascii 100))
    (resume (string-ascii 500)))
    (let
        (
            (caller tx-sender)
            (existing-profile (map-get? job-seekers caller))
        )
        ;; Ensure the profile does not already exist
        (if (is-none existing-profile)
            (begin
                ;; Validate input data
                (if (or (is-eq name "")
                        (is-eq location "")
                        (is-eq (len skills) u0)
                        (is-eq resume "")) ;; Ensure resume is not empty
                    (err ERR-INVALID-RESUME) ;; Handle invalid input
                    (begin
                        ;; Store the new job seeker profile
                        (map-set job-seekers caller
                            {
                                name: name,
                                skills: skills,
                                location: location,
                                resume: resume
                            }
                        )
                        (ok "Job seeker profile registered successfully.") ;; Return success message
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Public function to register an employer profile
(define-public (register-employer 
    (company-name (string-ascii 100))
    (industry (string-ascii 50))
    (location (string-ascii 100)))
    (let
        (
            (caller tx-sender)
            (existing-profile (map-get? employers caller))
        )
        ;; Ensure the profile does not already exist
        (if (is-none existing-profile)
            (begin
                ;; Validate input data
                (if (or (is-eq company-name "")
                        (is-eq industry "")
                        (is-eq location ""))
                    (err ERR-INVALID-LOCATION) ;; Handle invalid input
                    (begin
                        ;; Store the new employer profile
                        (map-set employers caller
                            {
                                company-name: company-name,
                                industry: industry,
                                location: location
                            }
                        )
                        (ok "Employer profile registered successfully.") ;; Return success message
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Public function to create a job listing
(define-public (create-job-listing 
    (title (string-ascii 100))
    (description (string-ascii 500))
    (location (string-ascii 100))
    (requirements (list 10 (string-ascii 50))))
    (let
        (
            (caller tx-sender)
            (existing-job (map-get? job-listings caller))
        )
        ;; Ensure the job listing does not already exist
        (if (is-none existing-job)
            (begin
                ;; Validate input data
                (if (or (is-eq title "")
                        (is-eq description "")
                        (is-eq location "")
                        (is-eq (len requirements) u0))
                    (err ERR-INVALID-JOB) ;; Handle invalid input
                    (begin
                        ;; Store the new job listing
                        (map-set job-listings caller
                            {
                                title: title,
                                description: description,
                                employer: caller,
                                location: location,
                                requirements: requirements
                            }
                        )
                        (ok "Job listing created successfully.") ;; Return success message
                    )
                )
            )
            (err ERR-ALREADY-EXISTS)
        )
    )
)

;; Read-only function to get job listing by job ID
(define-read-only (get-job-listing (job-id principal))
    (match (map-get? job-listings job-id)
        job (ok job)
        ERR-NOT-FOUND
    )
)

;; Read-only function to get a job seeker's profile
(define-read-only (get-job-seeker-profile (user principal))
    (match (map-get? job-seekers user)
        profile (ok profile)
        ERR-NOT-FOUND
    )
)

;; Read-only function to get an employer's profile
(define-read-only (get-employer-profile (user principal))
    (match (map-get? employers user)
        profile (ok profile)
        ERR-NOT-FOUND
    )
)
