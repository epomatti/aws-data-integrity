variable "region" {
  type    = string
  default = "us-east-2"
}

### Module toggles ###
variable "toggle_create_s3" {
  type = bool
  default = false
}

variable "toggle_create_glacier" {
  type = bool
  default = false
}

### Glacier ###
variable "glacier_lockpolicy_ArchiveAgeInDays" {
  type = number
  default = 365
}
