variable "host" {
  type        = string
  description = "The host for the git repository."
}

variable "type" {
  type        = string
  description = "The type of the hosted git repository (github or gitlab)."
}

variable "org" {
  type        = string
  description = "The org/group where the git repository exists/will be provisioned."
}

variable "repo" {
  type        = string
  description = "The short name of the repository (i.e. the part after the org/group name)"
}

variable "branch" {
  type        = string
  description = "The name of the branch that will be used. If the repo already exists (provision=false) then it is assumed this branch already exists as well"
  default     = "main"
}

variable "token" {
  type        = string
  description = "The personal access token used to access the repository"
  sensitive   = true
}

variable "public" {
  type        = bool
  description = "Flag indicating that the repo should be public or private"
  default     = false
}

variable "strict" {
  type        = bool
  description = "Flag indicating that an error should be thrown if the repo already exists"
  default     = false
}
