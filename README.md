# Data integrity on AWS

Data integrity features provided by AWS, based on DLP course.

The following 

| Service | |

- S3 Object Lock
- S3 Glacier Vault Lock
- AWS Backup Vault Lock
- Legal Holds


## S3 Object Lock

- Prevents objects from being **deleted** from a configurable amount of time.
- Only for NEW buckets, while they are being created. Cannot apply this for existing buckets.
- Automatically enables versioning.
- New objects inherit bucket settings, but once created, it is possible to apply object-by-object settings.

Modes:
- Governance - Authorization to delete objects is granted via the `s3:BypassGovernanceRetention` actions.
- Compliance - No one is allowed to delete the object until the lock has expired. Not even the Root.

## S3 Glacier Vault Lock

- Operates with a Resource Policy.
- Denies anyone the `DeleteArchive` unless conditions are met.
- Used in addition to IAM or vault access policies.

When a lock is applied it stays for "In-progress" state for 24 hours. It is possible to teste everything during this period.

🚨 Vault lock policy cannot be modified or deleted after confirmation.

## AWS Backup Vault Lock

- Prevents backups in the vault from being deleted until lock expiration.

ℹ️ There is a difference between these retention periods:
- Backup Job retention period - Defines how long a backup job should be retained.
- Backup Vault Lock retention period - Retention period backup job

Enabling the vault lock will also protect the Backup Vault from being deleted indefinitely, unlike Glacier.

Retention modes:
- Governance - Users may be authorized to delete objects or vault
- Compliance - Enables with start date (at least 3 days in the future). During this grace period the lock may be modified or removed. After this, the vault is immutable, and no one can delete backups or delete/manage the vault, forever. Only terminating the AWS account.

## Legal Holds

Can be applied to:
- S3 Object lock legal hold (requires S3 object lock to be enabled). Object-level setting.
- AWS Backup legal hold (does not require vault lock). Prevents backups from being deleted for duration of lock. All or selected backups.
